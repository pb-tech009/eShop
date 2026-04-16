# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy essential solution-wide configs
COPY ["Directory.Packages.props", "."]
COPY ["Directory.Build.props", "."]
COPY ["global.json", "."]
COPY ["nuget.config", "."]

# Copy Shared source folder
COPY ["src/Shared/", "src/Shared/"]

# Copy project files for Ordering.API and its dependencies
COPY ["src/Ordering.API/Ordering.API.csproj", "src/Ordering.API/"]
COPY ["src/Ordering.Domain/Ordering.Domain.csproj", "src/Ordering.Domain/"]
COPY ["src/Ordering.Infrastructure/Ordering.Infrastructure.csproj", "src/Ordering.Infrastructure/"]
COPY ["src/eShop.ServiceDefaults/eShop.ServiceDefaults.csproj", "src/eShop.ServiceDefaults/"]
COPY ["src/EventBusRabbitMQ/EventBusRabbitMQ.csproj", "src/EventBusRabbitMQ/"]
COPY ["src/EventBus/EventBus.csproj", "src/EventBus/"]
COPY ["src/IntegrationEventLogEF/IntegrationEventLogEF.csproj", "src/IntegrationEventLogEF/"]

# Restore
RUN dotnet restore "src/Ordering.API/Ordering.API.csproj"

# Copy source code
COPY . .

# Build and Publish
WORKDIR "/src/src/Ordering.API"
RUN dotnet publish "Ordering.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
COPY --from=build /app/publish .
USER $APP_UID
ENTRYPOINT ["dotnet", "Ordering.API.dll"]
