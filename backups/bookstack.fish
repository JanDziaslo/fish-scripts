#!/usr/bin/env fish

set -l required_vars BOOKSTACK_BACKUP_DIR BOOKSTACK_BACKUP_DIR2 BOOKSTACK_CONTAINER BOOKSTACK_DB_CONTAINER BOOKSTACK_DB_NAME BOOKSTACK_DB_USER BOOKSTACK_DB_PASS

set -l missing_vars

for var in $required_vars
    if not set -q $var
        set -a missing_vars $var
    end
end

if test (count $missing_vars) -gt 0
    echo "BŁĄD: Brakujące zmienne środowiskowe:"
    for var in $missing_vars
        echo "  - $var"
    end
    echo ""
    echo "Ustaw je w ~/.config/fish/conf.d/bookstack-backup.fish:"
    echo ""
    echo "set -x BOOKSTACK_BACKUP_DIR \"/ścieżka/do/backupów\""
    echo "set -x BOOKSTACK_BACKUP_DIR2 \"/ścieżka/do/backupów2\""
    echo "set -x BOOKSTACK_CONTAINER \"bookstack\""
    echo "set -x BOOKSTACK_DB_CONTAINER \"bookstack_db\""
    echo "set -x BOOKSTACK_DB_NAME \"bookstackapp\""
    echo "set -x BOOKSTACK_DB_USER \"bookstack\""
    echo "set -x BOOKSTACK_DB_PASS \"twoje_haslo\""
    echo "set -x BOOKSTACK_RETENTION_DAYS \"30\"  # opcjonalne, domyślnie 30"
    echo ""
    echo "Następnie wykonaj: source ~/.config/fish/conf.d/bookstack-backup.fish"
    exit 1
end

# domyślnie 30
if not set -q BOOKSTACK_RETENTION_DAYS
    set BOOKSTACK_RETENTION_DAYS 30
end

# Timestamp
set TIMESTAMP (date '+%Y%m%d-%H%M%S')

# Tworzenie katalogow
mkdir -p "$BOOKSTACK_BACKUP_DIR"
mkdir -p "$BOOKSTACK_BACKUP_DIR2"

# 1. Backup bazy danych
echo "Backupuję bazę danych..."
docker exec "$BOOKSTACK_DB_CONTAINER" mariadb-dump -u"$BOOKSTACK_DB_USER" -p"$BOOKSTACK_DB_PASS" "$BOOKSTACK_DB_NAME" | gzip > "$BOOKSTACK_BACKUP_DIR/bookstack-db-$TIMESTAMP.sql.gz"
docker exec "$BOOKSTACK_DB_CONTAINER" mariadb-dump -u"$BOOKSTACK_DB_USER" -p"$BOOKSTACK_DB_PASS" "$BOOKSTACK_DB_NAME" | gzip > "$BOOKSTACK_BACKUP_DIR2/bookstack-db-$TIMESTAMP.sql.gz"

# 2. Backup plików (ze środka kontenera)
echo "Backupuję pliki..."
docker exec "$BOOKSTACK_CONTAINER" tar -czf /tmp/bookstack-files-$TIMESTAMP.tar.gz \
    /config/.env \
    /config/www/public/uploads \
    /config/www/storage/uploads \
    /config/www/themes 2>/dev/null

# Wyciągnij archiwum z kontenera
docker cp "$BOOKSTACK_CONTAINER:/tmp/bookstack-files-$TIMESTAMP.tar.gz" "$BOOKSTACK_BACKUP_DIR/"
docker cp "$BOOKSTACK_CONTAINER:/tmp/bookstack-files-$TIMESTAMP.tar.gz" "$BOOKSTACK_BACKUP_DIR2/"

# Usuń z kontenera
docker exec "$BOOKSTACK_CONTAINER" rm /tmp/bookstack-files-$TIMESTAMP.tar.gz

# 3. Usuń stare backupy
echo "Czyszczę stare backupy..."
find "$BOOKSTACK_BACKUP_DIR" -name "bookstack-*" -type f -mtime +$BOOKSTACK_RETENTION_DAYS -delete
find "$BOOKSTACK_BACKUP_DIR2" -name "bookstack-*" -type f -mtime +$BOOKSTACK_RETENTION_DAYS -delete

echo "Backup zakończony: $TIMESTAMP"
echo "Pliki w: $BOOKSTACK_BACKUP_DIR"
ls -lh "$BOOKSTACK_BACKUP_DIR"
echo "Pliki w: $BOOKSTACK_BACKUP_DIR2"
ls -lh "$BOOKSTACK_BACKUP_DIR2"
