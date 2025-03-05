# MyCitiesChallenge
Reto en iOS (Swift + UIKit) para descargar y mostrar ~200,000 ciudades, con filtrado por prefijo, favoritos persistentes, y mapa integrado.

# Buscador de Ciudades iOS

## Descripción General

Este proyecto es una aplicación iOS desarrollada en Swift y UIKit que permite buscar ciudades de una lista de aproximadamente 200,000 ciudades obtenidas de un archivo JSON. Las ciudades se pueden filtrar por prefijo (sin distinción entre mayúsculas y minúsculas) y se muestran en orden alfabético por nombre de ciudad y país. Los usuarios pueden marcar ciudades como favoritas, y estas preferencias se almacenan localmente. Además, la aplicación incluye una vista de mapa que muestra las coordenadas de la ciudad seleccionada.

## Requisitos

-   iOS 15.0+
-   Xcode 13.0+
-   Swift 5.5+
-   UIKit
-   Arquitectura VIPER (View, Interactor, Presenter, Entity, Router, Worker)
-   No se utilizan librerías de terceros

## Instalación y Ejecución

1.  Clona el repositorio: `git clone <URL_del_repositorio>`
2.  Abre el proyecto en Xcode: `open BuscadorCiudades.xcodeproj`
3.  Ejecuta la aplicación en un simulador o dispositivo iOS: `Cmd + R`

## Arquitectura (VIPER con UIKit)

El proyecto sigue la arquitectura VIPER (View, Interactor, Presenter, Entity, Router, Worker) para separar las responsabilidades y mejorar la mantenibilidad del código.

-   **View**: Muestra la interfaz de usuario y gestiona las interacciones del usuario.
-   **Interactor**: Contiene la lógica de negocio específica para cada caso de uso.
-   **Presenter**: Actúa como intermediario entre la View y el Interactor, gestionando la lógica de presentación.
-   **Entity**: Representa los modelos de datos de la aplicación.
-   **Router**: Gestiona la navegación entre las diferentes vistas.
-   **Worker**: Realiza tareas de acceso a datos y operaciones de red.

La navegación entre las vistas se gestiona mediante el Router, y la lógica de negocio se implementa en los Interactors.

## Características Principales

-   Descarga de datos de ciudades desde un archivo JSON local.
-   Filtrado de ciudades por prefijo (sin distinción entre mayúsculas y minúsculas).
-   Ordenamiento alfabético de ciudades por nombre y país.
-   Marcado de ciudades como favoritas y persistencia local de estas preferencias.
-   Visualización de coordenadas de ciudades en un mapa.
-   Sin dependencias a librerías de terceros.

## Pruebas

El proyecto incluye pruebas unitarias y pruebas de interfaz de usuario (UI) para asegurar la calidad del código.

-   Pruebas unitarias: Verifican la lógica de negocio y las funciones individuales.
-   Pruebas de UI: Prueban la interacción del usuario con la interfaz.

Para ejecutar las pruebas, abre el proyecto en Xcode y presiona `Cmd + U`.

## Contacto

Autor: Alejandro Acosta
Email: [isaiin.dev@gmail.com](mailto:isaiin.dev@gmail.com)
LinkedIn: [https://www.linkedin.com/in/isaiin-dev/](https://www.linkedin.com/in/isaiin-dev/)
