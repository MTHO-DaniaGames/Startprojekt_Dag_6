FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /source
COPY NuGet.Config ./NuGet.Config
COPY src/Bogkatalog.Api/ ./Bogkatalog.Api/
RUN dotnet publish Bogkatalog.Api/Bogkatalog.Api.csproj \
    -c Release -o /publish --configfile NuGet.Config

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
COPY --from=build /publish/ ./
USER $APP_UID
ENTRYPOINT ["dotnet", "Bogkatalog.Api.dll"]
