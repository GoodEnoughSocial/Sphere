#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5001

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Sphere.Accounts.API/Sphere.Accounts.API/Sphere.Accounts.API.csproj", "Sphere.Accounts.API/Sphere.Accounts.API/"]
COPY ["Sphere.Shared/Sphere.Shared/Sphere.Shared.csproj", "Sphere.Shared/Sphere.Shared/"]
RUN dotnet restore "Sphere.Accounts.API/Sphere.Accounts.API/Sphere.Accounts.API.csproj"
COPY . .
WORKDIR "/src/Sphere.Accounts.API/Sphere.Accounts.API"
RUN dotnet build "Sphere.Accounts.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Sphere.Accounts.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Sphere.Accounts.API.dll"]