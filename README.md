>[!IMPORTANT]
> Skrypt został zrobiony pod powłoke fish i tylko na niej był testowany
# Prosty skrypt do backup'u bazy danych affine
## Funkcje
- Nazwa backupu po dacie i czasie stworzenia
- Robienie backup'u na zewnętrzne urządzenie za pomoca rsync
- Skrypt nie wymaga wyłączania affine dziala w tle niezależnie
## Wymagania
- rsync
- fish
- Affine postawiony za pomocą docker compose