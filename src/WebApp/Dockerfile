FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["Directory.Packages.props", "."]
COPY ["Directory.Build.props", "."]
COPY ["Directory.Build.targets", "."]
COPY ["nuget.config", "."]

COPY ["src/WebApp/WebApp.csproj", "src/WebApp/"]
COPY ["src/WebAppComponents/WebAppComponents.csproj", "src/WebAppComponents/"]
COPY ["src/eShop.ServiceDefaults/eShop.ServiceDefaults.csproj", "src/eShop.ServiceDefaults/"]
COPY ["src/EventBusRabbitMQ/EventBusRabbitMQ.csproj", "src/EventBusRabbitMQ/"]
COPY ["src/EventBus/EventBus.csproj", "src/EventBus/"]
COPY ["src/Basket.API/Proto/basket.proto", "src/Basket.API/Proto/"]

RUN dotnet restore "src/WebApp/WebApp.csproj"

COPY ["src/WebApp/", "src/WebApp/"]
COPY ["src/WebAppComponents/", "src/WebAppComponents/"]
COPY ["src/eShop.ServiceDefaults/", "src/eShop.ServiceDefaults/"]
COPY ["src/EventBusRabbitMQ/", "src/EventBusRabbitMQ/"]
COPY ["src/EventBus/", "src/EventBus/"]
COPY ["src/Shared/", "src/Shared/"]

RUN dotnet publish "src/WebApp/WebApp.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
USER $APP_UID
ENTRYPOINT ["dotnet", "WebApp.dll"]
