# Dag 6 · Kør bog-API'et i Docker

## Dagens mål
Kør det kendte API i en Linux-container og brug det fra Web, der fortsat kører i Visual Studio. Undersøg image, container, porte, stop/start og logs. Compose og database kommer på dag 7.

## Før I begynder
- Visual Studio med .NET 10 og Docker Desktop skal være installeret. Start Docker Desktop, og brug Linux containers. Vent, til motoren er klar. Installation og eventuel genstart bør være ordnet før undervisningen; følg skolens installationsvejledning.
- Hent hele dagens repo. Åbn Bogkatalog.slnx i Visual Studio.
- C#-koden er den fungerende Web/API-løsning fra dag 4. Ingen af TCP/UDP-labsene skal bruges. Nye bøger ligger i API-processens hukommelse.
- Start kun Bogkatalog.Web fra Visual Studio. Stop enhver lokal Bogkatalog.Api, så den ikke bruger host-port 5200. Docker skal starte API'et.

## Byg og start
Åbn terminalen i Visual Studio og stå i repoets rod, hvor Dockerfile, NuGet.Config og src ligger. PowerShell kan bruges; hver kommando er én linje. Den sidste prik i build-kommandoen betyder denne mappe.

```powershell
docker info --format '{{.OSType}}'
docker build -t bogkatalog-api:dag6 .
docker run -d --name bog-api -p 127.0.0.1:5200:8080 bogkatalog-api:dag6
docker ps
```

Forvent linux fra første kommando. Ved fejl må I ikke fortsætte som om build eller start lykkedes. Se HJAELP.md. Første build henter Microsofts SDK- og runtime-images fra internettet og kan tage tid.

## Afprøv API og Web
Åbn Netvaerk/Dag06.http i Visual Studio. Send A0 og A1; forvent 200 og henholdsvis status ok og to startbøger ved frisk start. Send B1 én gang; forvent 201, id og Location. Send A1 igen, og se den nye bog. Brug id'et fra svaret ved enkeltopslag.

Start Bogkatalog.Web via projektets Debug → Start Without Debugging. Web åbnes på http://localhost:5100; BooksApi:BaseUrl i src/Bogkatalog.Web/appsettings.json er http://localhost:5200/. Brug Hent igen og opret en bog. API-containeren og Web kører som hver sin proces.

## Logs og stop/start
```powershell
docker logs --tail 30 bog-api
docker stop bog-api
docker start bog-api
```

Mens API'et er stoppet: klik Hent igen i Web. Forvent en læsbar fejl; den tidligere liste kan blive stående som sidst hentede data. Efter docker start vælges Hent igen. De to startbøger genskabes, fordi API-processen startes på ny. Dette sker også ved genstart af samme container. Brug docker start til den eksisterende container; docker run opretter en ny.

## Flyt kun host-porten
Stop og fjern dagens container, og opret den på ny. Kommandoerne vedrører kun bog-api; brug ikke globale oprydningskommandoer.

```powershell
docker stop bog-api
docker rm bog-api
docker run -d --name bog-api -p 127.0.0.1:5300:8080 bogkatalog-api:dag6
```

Containeren lytter fortsat på 8080. Ret @baseUrl i Netvaerk/Dag06.http til http://localhost:5300, og send A0. Forvent 200. Web bruger stadig 5200 og viser fejl ved Hent igen. Stop Web, ret BooksApi:BaseUrl til http://localhost:5300/, og start Web igen. Nu kan Web hente boglisten. Der bygges ikke et nyt image ved dette portskift.

## Gendan og afslut
```powershell
docker stop bog-api
docker rm bog-api
docker run -d --name bog-api -p 127.0.0.1:5200:8080 bogkatalog-api:dag6
```
Gendan @baseUrl til http://localhost:5200 og Webs BooksApi:BaseUrl til http://localhost:5200/. Genstart Web og kontrollér /health, boglisten og POST. Stop Web og bog-api efter brug. Behold image og den stoppede container, så I kan bruge docker start bog-api senere. Et image bevarer ikke bøger, som kun ligger i processens RAM.

## Repository og Docker
Dockerfile er forberedt. I læser den og bruger den; I skal ikke skrive den fra bunden. .dockerignore udelader blandt andet bin, obj og .git. EXPOSE beskriver containerporten, men publicerer den ikke på pc'en. Linux-containerens port styres her af ASPNETCORE_HTTP_PORTS; launchSettings.json bruges ved lokal start fra Visual Studio, ikke ved Dockerfile-starten.

HJAELP.md giver fejlfinding. Netvaerk/Dag06.http er dagens API-kontrol. Skabelonerne fra tidligere dage er ikke nødvendige, da C#-koden allerede er færdig.
