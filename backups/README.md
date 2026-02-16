>[!IMPORTANT]
> Tutaj znajdują się skrypty do robienia backup'ów

# affine.fish
## Prosty skrypt do backup'u bazy danych affine
### Funkcje
- Nazwa backupu po dacie i czasie stworzenia
- Robienie backup'u na zewnętrzne urządzenie za pomoca rsync
- Skrypt nie wymaga wyłączania affine dziala w tle niezależnie
### Wymagania
- Rsync
- Fish
- Affine postawiony za pomocą docker compose

# bookstack.fish
## Prosty skrypt do backup'u instacji bookstack
### Funkcje
- Tworzy dwa pliki archiwum
	+ *sql.gz - Zawiera kopie zapasową bazy danych MariaDB
	+ *tar.gz - Zawiera kluczowe pliki kontenera z instancja Bookstack
- Kopiuje utworzone backup'y do dwóch rożnych miejsc
- Usuwa kopie zapasowe starsze niz dana liczba dni (domyślnie 30 dni)
- Listuje wszytkie pliki w obydwóch zadeklorowanych scieżkach
### Wymagania
- Fish 
- Docker
- Plik z zadeklorowanymi zmiennymi (Domyślnie: ~/.config/fish/conf.d/bookstack-backup.fish )

