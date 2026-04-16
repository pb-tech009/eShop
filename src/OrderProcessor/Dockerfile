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

# Copy project files for OrderProcessor
COPY ["src/OrderProcessor/OrderProcessor.csproj", "src/OrderProcessor/"]
COPY ["src/Ordering.Domain/Ordering.Domain.csproj", "src/Ordering.Domain/"]
COPY ["src/Ordering.Infrastructure/Ordering.Infrastructure.csproj", "src/Ordering.Infrastructure/"]
COPY ["src/eShop.ServiceDefaults/eShop.ServiceDefaults.csproj", "src/eShop.ServiceDefaults/"]
COPY ["src/EventBusRabbitMQ/EventBusRabbitMQ.csproj", "src/EventBusRabbitMQ/"]
COPY ["src/EventBus/EventBus.csproj", "src/EventBus/"]

# Restore
RUN dotnet restore "src/OrderProcessor/OrderProcessor.csproj"

# Copy source code
COPY . .

# Build and Publish
WORKDIR "/src/src/OrderProcessor"
RUN dotnet publish "OrderProcessor.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
USER $APP_UID
ENTRYPOINT ["dotnet", "OrderProcessor.dll"]
