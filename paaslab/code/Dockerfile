#FROM mcr.microsoft.com/dotnet/aspnet:2.2 AS base   # Note: there is no 2.2 tag
FROM mcr.microsoft.com/dotnet/aspnet:2.1 AS base   
#FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

WORKDIR /app
COPY . .
ENTRYPOINT ["dotnet", "tailspintoysweb.dll"]
