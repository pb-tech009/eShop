FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["Directory.Packages.props", "."]
COPY ["Directory.Build.props", "."]
COPY ["Directory.Build.targets", "."]
COPY ["nuget.config", "."]

COPY ["src/PaymentProcessor/PaymentProcessor.csproj", "src/PaymentProcessor/"]
COPY ["src/eShop.ServiceDefaults/eShop.ServiceDefaults.csproj", "src/eShop.ServiceDefaults/"]
COPY ["src/EventBusRabbitMQ/EventBusRabbitMQ.csproj", "src/EventBusRabbitMQ/"]
COPY ["src/EventBus/EventBus.csproj", "src/EventBus/"]

RUN dotnet restore "src/PaymentProcessor/PaymentProcessor.csproj"

COPY ["src/PaymentProcessor/", "src/PaymentProcessor/"]
COPY ["src/eShop.ServiceDefaults/", "src/eShop.ServiceDefaults/"]
COPY ["src/EventBusRabbitMQ/", "src/EventBusRabbitMQ/"]
COPY ["src/EventBus/", "src/EventBus/"]
COPY ["src/Shared/", "src/Shared/"]

RUN dotnet publish "src/PaymentProcessor/PaymentProcessor.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
USER $APP_UID
ENTRYPOINT ["dotnet", "PaymentProcessor.dll"]
