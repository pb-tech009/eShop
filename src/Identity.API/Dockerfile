FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG TARGETARCH
WORKDIR /src

COPY ["Directory.Packages.props", "."]
COPY ["Directory.Build.props", "."]
COPY ["Directory.Build.targets", "."]
COPY ["nuget.config", "."]

COPY ["src/Identity.API/Identity.API.csproj", "src/Identity.API/"]
COPY ["src/eShop.ServiceDefaults/eShop.ServiceDefaults.csproj", "src/eShop.ServiceDefaults/"]

RUN dotnet restore "src/Identity.API/Identity.API.csproj"

COPY ["src/Identity.API/", "src/Identity.API/"]
COPY ["src/eShop.ServiceDefaults/", "src/eShop.ServiceDefaults/"]
COPY ["src/Shared/", "src/Shared/"]

RUN dotnet publish "src/Identity.API/Identity.API.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
USER $APP_UID
ENTRYPOINT ["dotnet", "Identity.API.dll"]
