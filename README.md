<h1 align="center"> UBBMap🚶 </h1>


**Tabla de contenido**   
* [Descripción](#descripcion)
* [Tecnologías utilizadas](#tec-util)
* [Caracteristicas](#caract)
* [Aprendizaje](#aprendizaje)
* [Posibles Mejoras](#mejora)
* [Dirigiendo el proyecto](#instrucciones)
* [Demostración](#img)
## 📋 Descripción<a name="descripcion"></a>
   El siguiente proyecto consiste en una aplicación móvil que entrega rutas sobre cómo llegar posee variadas características, entre ellas se encuentra su funcionalidad principal que consiste en mostrar un mapa interactivo de la Universidad del Bío-Bío y sus distintos Campus a los usuarios. El público objetivo son estudiantes y docentes de la universidad, permitiéndoles ubicar lugares dentro del campus y encontrar rutas para llegar a su destino.

## ✔️ Tecnologías usadas<a name="tec-util"></a>

* <b>Lenguaje de programación:</b>
  * ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

* <b>Frameworks y bibliotecas:</b>
  * ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
    
* <b>Bases de datos:</b>
  * ![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
    
* <b>Control de versiones:</b>
  * ![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)
    
* <b>Herramientas de desarrollo:</b>
  * ![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)
  * ![Android Studio](https://img.shields.io/badge/Android%20Studio-3DDC84.svg?style=for-the-badge&logo=android-studio&logoColor=white)
    
* <b>APIs y servicios de terceros:</b>
  * <img src="https://cdn.icon-icons.com/icons2/2699/PNG/512/mapbox_logo_icon_169975.png" alt="MapboxSDK" width="100">
  * <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Google_Maps_Logo_2020.svg/2275px-Google_Maps_Logo_2020.svg.png" alt="GoogleMapsSDK" width="100">
  * <img src="https://openweathermap.org/themes/openweathermap/assets/img/logo_white_cropped.png" alt="OpenWeatherMap" width="100">

## 💻 Características<a name="caract"></a>

### 1. Autenticación de Usuario
- Permite a los usuarios iniciar sesión de manera segura utilizando Firebase Authentication.

### 2. Registro de Usuario
- Permite a los usuarios crear nuevas cuentas en la aplicación.

### 3. Recuperación de Cuenta
- Proporciona a los usuarios la opción de restablecer su contraseña en caso de olvido.

### 4. Visualización de Mapas
- Utiliza Mapbox y Google Maps SDK para mostrar mapas interactivos en la aplicación.

### 5. Búsqueda de Destinos
- Permite a los usuarios buscar destinos a través de una barra de búsqueda.

### 6. Selección de Destinos con Marcador Manual
- Los usuarios pueden seleccionar destinos manualmente utilizando un marcador en el mapa.

### 7. Visualización de Clima
- Muestra información meteorológica actualizada utilizando la API de OpenWeatherMap.

### 8. Botones de Uso Específico
- Incluye botones específicos para acciones como mostrar/ocultar marcadores de desfibriladores, conocer la ubicación del usuario y activar el seguimiento de usuario.


## 📚 Aprendizaje<a name="aprendizaje"></a>


Durante el desarrollo de este proyecto, he aprendido varias lecciones y adquirido nuevas habilidades. Algunos de los aspectos más destacados incluyen:

- **Aprendizaje de Flutter y Dart:** Este proyecto me brindó la oportunidad de sumergirme en el desarrollo de aplicaciones móviles utilizando Flutter y el lenguaje de programación Dart. Aprendí sobre widgets, state management, y cómo construir interfaces de usuario interactivas y receptivas.

- **Integración con Firebase:** Aprendí a integrar Firebase en mi aplicación para manejar la autenticación de usuarios y la base de datos en tiempo real. Esto me permitió implementar características como el inicio de sesión seguro y la recuperación de contraseñas, además proporcionar las ubicaciones registradas a lo usuarios para que pudiesen acceder a su destino.

- **Uso de APIs externas:** Integré APIs externas, como OpenWeatherMap, para obtener datos meteorológicos en tiempo real, Mapbox y Google Maps SDK para mostrar mapas interactivos. Aprendí a trabajar con estas APIs y a manejar las respuestas de manera efectiva.

- **Diseño de Experiencia de Usuario:** Me esforcé por crear una experiencia de usuario intuitiva y atractiva. Aprendí sobre principios de diseño de UX/UI y cómo aplicarlos para mejorar la usabilidad y la satisfacción del usuario.

En resumen, el desarrollo de este proyecto me proporcionó una valiosa experiencia práctica y me permitió mejorar mis habilidades en desarrollo de aplicaciones móviles, integración de APIs, gestión de proyectos y diseño de experiencia de usuario.


## ✨ Posibles Mejoras<a name="mejora"></a>

1. **Ubicación del Botón de Emergencia:** Agregar un botón específico para mostrar la ubicación del botón de emergencia dentro de la universidad, proporcionando información vital en caso de emergencias.

2. **Pronóstico del Tiempo Detallado:** Integrar un pronóstico del tiempo detallado que incluya información sobre las próximas horas, ayudando a los usuarios a planificar sus actividades con mayor precisión.
   
3.  **Integración con Otras Plataformas:** Explorar la posibilidad de expandir la aplicación a otras plataformas, como iOS, para llegar a una audiencia más amplia de usuarios.


## 🚦 Dirigiendo el proyecto<a name="instrucciones"></a>

### Requisitos previos

Antes de comenzar con la instalación y ejecución del proyecto, asegúrate de tener los siguientes requisitos previos:

1. **Flutter SDK:** Es necesario tener Flutter SDK instalado en tu sistema. Puedes seguir las instrucciones de instalación en la [documentación oficial de Flutter](https://flutter.dev/docs/get-started/install).

2. **Editor de código:** Se recomienda tener un editor de código instalado y configurado para trabajar con Flutter. Algunas opciones populares incluyen:
   - [Visual Studio Code](https://code.visualstudio.com/)
   - [Android Studio](https://developer.android.com/studio) (con el complemento Flutter)
   - [IntelliJ IDEA](https://www.jetbrains.com/idea/) (con el complemento Flutter)

3. **Dispositivo móvil o Emulador:** Necesitarás un dispositivo móvil con modo de depuración USB activado o un emulador Android configurado y funcionando en tu sistema. Puedes seguir las instrucciones para configurar un emulador en la [documentación de Flutter](https://flutter.dev/docs/get-started/install/windows#set-up-the-android-emulator).

4. **Conexión a Internet:** Asegúrate de tener una conexión a Internet activa para descargar las dependencias del proyecto y cualquier actualización necesaria durante el proceso de instalación.

5. **Clonar el repositorio:** Clona el repositorio de GitHub del proyecto utilizando Git. Puedes ejecutar el siguiente comando en tu terminal:
<br>`git clone https://github.com/IvanParada/ubb.git`

6. **Instalar dependencias:** Después de clonar el repositorio, instala las dependencias del proyecto utilizando el administrador de paquetes de Dart, <b>pub</b>. Puedes ejecutar el siguiente comando en el directorio raíz del proyecto:
<br>`flutter pub get`

7. **Ejecutar el proyecto:** Una vez instaladas las dependencias, puedes ejecutar el proyecto en un emulador o dispositivo físico utilizando el siguiente comando:
<br>`flutter run`


Asegúrate de cumplir con todos estos requisitos previos antes de proceder con la instalación y ejecución del proyecto. Si encuentras algún problema durante el proceso, consulta la documentación oficial de Flutter o busca ayuda en la comunidad de desarrollo de Flutter.


## 📱 Demostración<a name="img"></a>

🔒 <b>Autenticación de usuario</b>

<div style="display:flex;">
    <img src="https://github.com/IvanParada/ubb/assets/118088453/1a797394-7451-4c4d-b176-6f4bac09aafa" alt="Iniciar Sesión" style="width:200px; margin-right:10px;">
    <img src="https://github.com/IvanParada/ubb/assets/118088453/52b8c0a4-d308-45ca-855c-a7c9d7d48c45" alt="Registrarse" style="width:200px; margin-right:10px;">
    <img src="https://github.com/IvanParada/ubb/assets/118088453/836abc24-944d-4d39-8d96-8057b81c4479" alt="Recuperar cuenta" style="width:200px;">
</div>


📱<b>Screens App</b>

<div style="display:flex;">
    <img src="https://github.com/IvanParada/ubb/assets/118088453/b5c3cca3-ecff-4a74-a91b-88d02c460e20" alt="Inicio" style="width:200px; margin-right:10px;">
    <img src="https://github.com/IvanParada/ubb/assets/118088453/da812494-288b-4033-8218-4f173bda2270" alt="Mapas" style="width:200px; margin-right:10px;">
    <img src="https://github.com/IvanParada/ubb/assets/118088453/e6210685-f55e-4575-912b-8a4b5f48f05b" alt="Ajustes" style="width:200px;">
</div>


🗺️ <b>Mapa</b>

<div style="display:flex;">
    <img src="https://github.com/IvanParada/ubb/assets/118088453/1d6c07ca-fe95-4de1-af7d-788f279efc18" alt="Inicio" style="width:200px; margin-right:10px;">
    <img src="https://github.com/IvanParada/ubb/assets/118088453/54e04245-c6b5-4491-b8dd-cc565b70e3a1" alt="Mapas" style="width:200px; margin-right:10px;">
    <img src="https://github.com/IvanParada/ubb/assets/118088453/3c116b2d-8b86-4d1e-8d1c-2d24dfab4efb" alt="Ajustes" style="width:200px;">
    <img src="https://github.com/IvanParada/ubb/assets/118088453/229b3529-ee29-4ce4-9a7d-33811d4e6e02" alt="Ajustes" style="width:200px;">
</div>

