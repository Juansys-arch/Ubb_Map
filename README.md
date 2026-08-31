<h1 align="center">CampUBB 🚶♿</h1>

<p align="center">
  <strong>Aplicación móvil colaborativa para el mapeo interactivo, accesibilidad universal y gestión de servicios del campus de la Universidad del Bío-Bío.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Firebase-%23039BE5.svg?style=for-the-badge&logo=firebase&logoColor=white" alt="Firebase">
  <img src="https://img.shields.io/badge/Estado-En%20Refactorización-orange?style=for-the-badge" alt="Estado">
</p>

---

## 📌 Tabla de Contenido
- [Sobre el Proyecto](#-sobre-el-proyecto)
- [Estado Actual del Repositorio](#-estado-actual-del-repositorio)
- [Nuevas Características y Pilares (CampUBB)](#-nuevas-características-y-pilares-campubb)
- [Tecnologías Utilizadas](#-tecnologías-utilizadas)
- [Configuración y Ejecución Local](#-configuración-y-ejecución-local)
- [Equipo de Desarrollo](#-equipo-de-desarrollo)
- [Referencias y Agradecimientos](#-referencias-y-agradecimientos)

---

## 📋 Sobre el Proyecto

**CampUBB** es un proyecto de titulación de la carrera de *Ingeniería en Ejecución en Computación e Informática* de la **Universidad del Bío-Bío**. Nace como la evolución y refactorización modular de la base histórica **UBBMap**, con el objetivo de centralizar la experiencia de navegación universitaria e incorporar capas de accesibilidad universal, reporte ciudadano e integración académica.

### ⚠️ Estado Actual del Repositorio
> **Nota de desarrollo:** Este repositorio contiene la base de código heredada del proyecto *UBBMap*. Actualmente la aplicación se encuentra **fuera de servicio / no operativa** debido a dependencias desactualizadas, cambios en APIs externas y refactorización arquitectónica en progreso hacia **CampUBB**.

---

## 🚀 Nuevas Características y Pilares (CampUBB)

A diferencia de la versión base, CampUBB amplía el alcance con los siguientes módulos clave:

* ♿ **Motor de Rutas Accesibles:** Cálculo de trayectos optimizados para personas con movilidad reducida, considerando rampas, pendientes y accesos universales.
* 👥 **Módulo de Reporte Colaborativo (Crowdsourcing):** Mecanismo en tiempo real para que la comunidad reporte incidencias en servicios básicos (baños fuera de servicio, dispensadores de agua, enchufes, impresoras).
* 🎓 **Capa de Mapeo Académico Integrado:** Vinculación de salas con bases académicas institucionales para consultar horarios y docentes asignados a cada espacio.
* 🕒 **Capa Dinámica de Servicios y Eventos:** Visualización de horarios de atención de casinos, cafeterías, gimnasios, zonas de estacionamiento y ciclovías.
* 🗺️ **Mapeo Interactivo Multisede:** Navegación en campus Concepción y Chillán.

---

## 🛠️ Tecnologías Utilizadas

* **Lenguaje:** [Dart](https://dart.dev/)
* **Framework:** [Flutter](https://flutter.dev/)
* **Backend y Autenticación:** [Firebase Authentication](https://firebase.google.com/) & Cloud Firestore
* **Servicios de Mapas y Rutas:** [Mapbox API](https://docs.mapbox.com/) / [Google Maps SDK](https://developers.google.com/maps) / [OpenStreetMap](https://www.openstreetmap.org/)
* **Datos Meteorológicos:** [OpenWeatherMap API](https://openweathermap.org/)
* **Control de Versiones:** Git & GitHub

---

## 🚦 Configuración y Ejecución Local

### Requisitos Previos
* **Flutter SDK:** Instalado y configurado en el PATH.
* **Editor:** Visual Studio Code o Android Studio con el plugin de Flutter.
* **Emulador o Dispositivo Físico:** Con depuración USB activada.

### Pasos de Instalación

```bash
# 1. Clonar este repositorio
git clone [https://github.com/TU_USUARIO/TU_REPOSITORIO.git](https://github.com/TU_USUARIO/TU_REPOSITORIO.git)

# 2. Entrar a la carpeta del proyecto
cd CampUBB

# 3. Descargar paquetes y dependencias
flutter pub get

# 4. Configurar variables de entorno
# Copiar las plantillas en /environments/.env con las credenciales correspondientes

# 5. Ejecutar la aplicación
flutter run
