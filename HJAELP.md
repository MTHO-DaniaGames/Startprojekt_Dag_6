# Hjælp · Dag 6

- **docker findes ikke:** Kontrollér Docker Desktop-installation. Åbn en ny terminal eller genstart Visual Studio efter installationen.
- **Cannot connect / pipe / daemon:** Start Docker Desktop og vent på motoren. docker info --format '{{.OSType}}' skal give linux. Windows containers kan ikke køre dagens Linux-images.
- **Dockerfile mangler / COPY fejler:** Terminalen skal stå i repoets rod med Dockerfile og src. Build context er den sidste prik i docker build-kommandoen.
- **Port 5200 er optaget:** Stop den lokale Bogkatalog.Api eller en tidligere øvelsescontainer. docker ps viser kørende containere. Afslut kun en proces eller container, I har identificeret.
- **Navnet bog-api er optaget:** docker ps -a viser også stoppede containere. Brug docker start bog-api ved almindelig genstart. Ved ændring af portmapping bruges docker stop bog-api og derefter docker rm bog-api før en ny docker run. Stop ikke ukendte containere.
- **Containeren afslutter straks:** Se docker ps -a og docker logs bog-api. Ret årsagen, før I fortsætter. Et build uden fejl er ikke bevis for, at API'et kører.
- **/health virker, men Web fejler:** Kontrollér BooksApi:BaseUrl og genstart Web efter rettelsen. Hent igen skal hente gennem API'et. Browserens Network-panel viser ikke Web-serverens egne HttpClient-kald.
- **API-root / giver 404:** Brug /health eller /api/books. Der er ingen hjemmeside på API'ets root.
- **Logs viser 8080, men pc'en bruger 5200:** Det er forventet. Containerporten er 8080; docker ps viser den publicerede host-port. Ved 5300-testen er det stadig 8080 inde i containeren.
- **Nye bøger er væk efter stop/start:** Det er forventet. Processens RAM nulstilles ved genstart; lagring i database er næste dags emne.
- **Pull eller restore fejler:** Kontrollér netværksadgang til Microsoft Container Registry og NuGet. Skolens proxy eller installationsrettigheder kan kræve lokal hjælp. Del ikke adgangskoder eller tokens i terminaloutput.

## Valgfri gul øvelse: To API-processer
Mens bog-api kører på 5200, kan I oprette en ekstra container med et andet navn og en anden host-port:
```powershell
docker run -d --name bog-api-ekstra -p 127.0.0.1:5400:8080 bogkatalog-api:dag6
```
Begge bruger samme image og containerport 8080, men er adskilte processer. Opret en bog gennem 5200. Hent listerne fra 5200 og 5400: den ekstra container har sin egen liste. Det viser behovet for fælles lagring, hvis flere API-processer skal dele data. Fjern kun den ekstra øvelsescontainer bagefter:
```powershell
docker stop bog-api-ekstra
docker rm bog-api-ekstra
```
