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

# Copy project files for WebApp and its complex dependencies
COPY ["src/WebApp/WebApp.csproj", "src/WebApp/"]
COPY ["src/WebAppComponents/WebAppComponents.csproj", "src/WebAppComponents/"]
COPY ["src/eShop.ServiceDefaults/eShop.ServiceDefaults.csproj", "src/eShop.ServiceDefaults/"]
COPY ["src/EventBusRabbitMQ/EventBusRabbitMQ.csproj", "src/EventBusRabbitMQ/"]
COPY ["src/EventBus/EventBus.csproj", "src/EventBus/"]

# Copy Proto files (needed for restore/build)
COPY ["src/Basket.API/Proto/", "src/Basket.API/Proto/"]

# Restore
RUN dotnet restore "src/WebApp/WebApp.csproj"

# Copy source code
COPY . .

# Build and Publish
WORKDIR "/src/src/WebApp"
RUN dotnet publish "WebApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
COPY --from=build /app/publish .
USER $APP_UID
ENTRYPOINT ["dotnet", "WebApp.dll"]
