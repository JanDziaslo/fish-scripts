>[!IMPORTANT]
> Skrypt został zrobiony pod powłoke fish. Testowany na Debianie 13 (Trixie)
# affine.fish
## Prosty skrypt do backup'u bazy danych affine
### Funkcje
- Nazwa backupu po dacie i czasie stworzenia
- Robienie backup'u na zewnętrzne urządzenie za pomoca rsync
- Skrypt nie wymaga wyłączania affine dziala w tle niezależnie
### Wymagania
- rsync
- fish
- Affine postawiony za pomocą docker compose


# minecraft.fish
## Prosty skrypt do restartowania serwera minecraft
### Funkcje 
- Odliczanie minutę przed restartem serwera
- Informowanie graczy na serwerze o restarcie serwera
### Wymagania 
- fish
- serwer minecraft postawiony za pomocą docker compose
- rcon-cli