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

# Copy project files for WebhookClient
COPY ["src/WebhookClient/WebhookClient.csproj", "src/WebhookClient/"]
COPY ["src/WebAppComponents/WebAppComponents.csproj", "src/WebAppComponents/"]
COPY ["src/eShop.ServiceDefaults/eShop.ServiceDefaults.csproj", "src/eShop.ServiceDefaults/"]

# Restore
RUN dotnet restore "src/WebhookClient/WebhookClient.csproj"

# Copy source code
COPY . .

# Build and Publish
WORKDIR "/src/src/WebhookClient"
RUN dotnet publish "WebhookClient.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
COPY --from=build /app/publish .
USER $APP_UID
ENTRYPOINT ["dotnet", "WebhookClient.dll"]
