FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["Directory.Packages.props", "."]
COPY ["Directory.Build.props", "."]
COPY ["Directory.Build.targets", "."]
COPY ["nuget.config", "."]

COPY ["src/Basket.API/Basket.API.csproj", "src/Basket.API/"]
COPY ["src/eShop.ServiceDefaults/eShop.ServiceDefaults.csproj", "src/eShop.ServiceDefaults/"]
COPY ["src/EventBusRabbitMQ/EventBusRabbitMQ.csproj", "src/EventBusRabbitMQ/"]
COPY ["src/EventBus/EventBus.csproj", "src/EventBus/"]

RUN dotnet restore "src/Basket.API/Basket.API.csproj"

COPY ["src/Basket.API/", "src/Basket.API/"]
COPY ["src/eShop.ServiceDefaults/", "src/eShop.ServiceDefaults/"]
COPY ["src/EventBusRabbitMQ/", "src/EventBusRabbitMQ/"]
COPY ["src/EventBus/", "src/EventBus/"]
COPY ["src/Shared/", "src/Shared/"]

RUN dotnet publish "src/Basket.API/Basket.API.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
USER $APP_UID
ENTRYPOINT ["dotnet", "Basket.API.dll"]
