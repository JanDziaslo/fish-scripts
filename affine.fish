#!/usr/bin/fish

set timestamp (date +%Y-%m-%d_%H-%M)
set backup_name "backup_$timestamp.sql.gz"
set local_path "$HOME/dane/backups/affine/"

cd $HOME/docker/affine

docker compose exec postgres sh -c 'pg_dump -U $POSTGRES_USER -d $POSTGRES_DB' | gzip > $backup_name


rsync -avz --info=progress2 ./$backup_name szpont:~/dane/backups/affine/
mv ./$backup_name $local_path$backup_name

echo "Zakończono: Backup $backup_name został wysłany na szpont i zapisany lokalnie."
