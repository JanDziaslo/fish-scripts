#!/usr/bin/fish

set timestamp (date +%Y-%m-%d_%H-%M)
set backup_name "backup_$timestamp.sql.gz"
set images_backup_name "backup_images_$timestamp.tar.gz"
set local_path "$HOME/dane/backups/affine/"

cd $HOME/docker/affine

# baza danych
docker compose exec -T postgres sh -c 'pg_dump -U $POSTGRES_USER -d $POSTGRES_DB' | gzip > $backup_name

# backup obrazkow
docker compose exec -T affine tar -C /root/.affine -czf - storage > $images_backup_name

# baza dancyh na zewnetrzny serwer
cp ./$backup_name $HOME/blob/backups/affine

# obrazki na zewnetrzny serwer
cp ./$images_backup_name $HOME/blob/backups/affine

# baza danych
mv ./$backup_name $local_path$backup_name

# obrazki
mv ./$images_backup_name $local_path$images_backup_name

echo "Zakończono: Backup bazy ($backup_name) i obrazków ($images_backup_name) został wysłany na szpont i zapisany lokalnie."
