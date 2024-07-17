# Crear WebAPI con Docker


## Creamos la Web API


1. Creamos la aplicacion con el siguiente comando 

        dotnet new webapi -o MyWebAPIDemo

2. No ubicamos en el directorio del proyecto
 
        cd MyWebAPIDemo

3. Compilar aplicación WebAPI

        dotnet build
4. Ejecutando aplicación WebAPI

        dotnet run



## Creamos el archivo dockerfile

Para este demo el archivo debe estar a nivel del archivo csproj

1. Para crear Imagen Base para Producción
    ```docker
    FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
    WORKDIR /app
    EXPOSE 80
    ```
2. Crea Imagen Base para Construcción
    ```docker
    FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
    WORKDIR /src
    COPY *.csproj .
    RUN dotnet restore
    ```
3. Construcción de la Aplicación
    ```docker
    COPY . .
    WORKDIR "/src/."
    RUN dotnet build  -c Release -o /app/build
   ```
4. Publicación de la Aplicación
    ```docker
    FROM build AS publish
    RUN dotnet publish -c Release -o /app/publish
    ```
5. Construcción de la Imagen Final
    ```docker
    FROM base AS final
    WORKDIR /app
    COPY --from=publish /app/publish .
    ENTRYPOINT ["dotnet", "MyWebAPIDemo.dll"]
    ```

El archivo final queda como el siguiente:
```docker
# MyWebAPIDemo
#Imagen Base para Producción
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

#Imagen Base para Construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY *.csproj .
RUN dotnet restore 

#Construcción de la Aplicación
COPY . .
WORKDIR "/src/."
RUN dotnet build  -c Release -o /app/build

#Publicación de la Aplicación
FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

#Construcción de la Imagen Final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyWebAPIDemo.dll"]

```

## Construir y ejecutar la imagen Docker

1. Nos ubicamos a nivel del archivo Dockerfile

    ```powershell
    cd MyWebAPIDemo
    ```

2. Construir la Imagen:
    ```powershell
    docker build -t mywebapidemo .
    ```

3. Ejecutar el Contenedor:
    ```powershell
    docker run -it -p 5051:8080 --name mywebapidemo_container mywebapidemo
    ```

## Verificar la Aplicación

1. Abrir en el Navegador y Navega a <http://localhost:5051> para ver si tu aplicación se está ejecutando

2. Revisar Logs. Si hay problemas, revisa los logs del contenedor
    ```
    docker logs mywebapidemo_container
    ```
