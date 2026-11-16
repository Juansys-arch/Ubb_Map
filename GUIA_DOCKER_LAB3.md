# Guía de Laboratorio 3: Docker, Backend y Generación de APK
**Asignatura:** Taller de Desarrollo  
**Profesor:** Diego Salazar Jara  
**Puntaje Total:** 30 pts (Exigencia 51%)

---

## 📋 Resumen de Criterios de Evaluación

| Criterio | Puntaje | Estado |
|---|---|---|
| **Generación y funcionamiento de APK** | 10 pts | Listo para compilar con `flutter build apk` |
| **Despliegue de Backend / BD con Docker** | 10 pts | Configurado con `docker-compose.yaml` y `Dockerfile` |
| **Conocimiento de la configuración** | 10 pts | Respuestas y explicaciones detalladas abajo |

---

## 🚀 PASO 1: Levantar el Backend y la Base de Datos con Docker (10 pts)

### 1. Asegúrate de tener Docker Desktop abierto
Abre la aplicación **Docker Desktop** en tu computadora con Windows y espera a que el ícono en la esquina inferior izquierda esté en verde (*Engine running*).

### 2. Abrir la terminal en la raíz del proyecto
Abre PowerShell o la terminal en la carpeta principal:
`c:\Users\vicen\OneDrive\Desktop\Ubb_Map`

### 3. Levantar los contenedores
Ejecuta el siguiente comando:
```bash
docker compose up -d --build
```
* **¿Qué hace este comando?**
  * `up`: Lee el archivo `docker-compose.yaml`, descarga la imagen de MongoDB, compila tu API REST con su `Dockerfile` y enciende ambos contenedores en una red privada virtual (`ubb_network`).
  * `-d` (*detached*): Los ejecuta en segundo plano para que tu terminal quede libre.
  * `--build`: Fuerza a construir la imagen de tu API para incluir cualquier cambio de código reciente.

### 4. Verificar que todo esté corriendo
Ejecuta:
```bash
docker compose ps
```
Verás dos servicios activos:
* `ubb_mongo_db` (estado `healthy` en el puerto `27017`)
* `ubb_api_backend` (estado `running` en el puerto `3000`)

### 5. Probar la API en tu navegador
Abre tu navegador web y entra a:
👉 **http://localhost:3000/api/health**

Verás una respuesta JSON como esta confirmando que la API y la BD están vivas:
```json
{
  "status": "ok",
  "message": "API REST UBB Map funcionando correctamente",
  "database": "conectada",
  "timestamp": "2026-11-15T..."
}
```

También puedes ver los lugares precargados en:  
👉 **http://localhost:3000/api/places/ccp**

---

## 📱 PASO 2: Generar y Probar el archivo APK (10 pts)

### 1. Configuración de red de la App Móvil
En el archivo [`environments/.env`](environments/.env) ya quedó configurada la URL para conectar al emulador:
```env
API_URL=http://10.0.2.2:3000/api
```
> **Nota:** En emuladores Android, `10.0.2.2` es la dirección especial para comunicarse con el `localhost` de tu computadora. Si pruebas con un celular físico conectado a tu Wi-Fi, cambia `10.0.2.2` por la IP local de tu PC (la que te da el comando `ipconfig`, ej: `http://192.168.1.50:3000/api`).

### 2. Compilar el APK de Flutter
En tu terminal ejecuta:
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### 3. Ubicación del archivo APK generado
Una vez finalizada la compilación, el APK queda exactamente en:
```text
build/app/outputs/flutter-apk/app-release.apk
```

### 4. Instalar y probar en el emulador
* Abre tu emulador de Android en Android Studio o VS Code.
* Arrastra el archivo `app-release.apk` con el mouse directamente sobre la pantalla del emulador para que se instale.
* Abre la app UBB Map y verifica que cargue el mapa, edificios y eventos desde el backend de Docker.

---

## 🧠 PASO 3: Guion de Explicación para el Profesor (10 pts)

El profesor te pedirá explicar la estructura de los archivos utilizados. Aquí tienes las respuestas exactas:

### 1. Explicación del `Dockerfile` ([Backend/Dockerfile](Backend/Dockerfile)):
* **`FROM node:20-alpine`:** Define la imagen base ligera de Linux con Node.js 20.
* **`WORKDIR /app`:** Crea y define la carpeta de trabajo interna dentro del contenedor.
* **`COPY package*.json ./`:** Copia solo los manifiestos de dependencias primero para aprovechar el sistema de caché por capas de Docker (si no cambiamos dependencias, no vuelve a descargar paquetes).
* **`RUN npm install`:** Instala todas las librerías necesarias (Express, Mongoose, etc.).
* **`COPY . .`:** Copia el resto del código del backend (`server.js`, `models.js`).
* **`EXPOSE 3000`:** Declara que el contenedor escuchará en el puerto 3000.
* **`CMD ["npm", "start"]`:** Comando que arranca el servidor (`node server.js`).

### 2. Explicación del `docker-compose.yaml` ([docker-compose.yaml](docker-compose.yaml)):
* **`services`:** Declara los dos contenedores de nuestra arquitectura: `db` (MongoDB) y `api` (Backend Express).
* **`ports`:** Mapea el puerto del Host con el del Contenedor (`3000:3000`). Permite que la app móvil acceda al servidor desde fuera del contenedor.
* **`volumes` (`mongo_data:/data/db`):** Crea un Named Volume para persistencia. Si el contenedor se apaga o se borra, los datos de la base de datos no se pierden.
* **`networks` (`ubb_network`):** Red interna virtual con driver `bridge`. Permite que la API se conecte a la base de datos usando el nombre `db` gracias al servidor DNS interno de Docker, sin necesitar IPs fijas.
* **`healthcheck` y `depends_on` con `condition: service_healthy`:** Asegura que la API no arranque antes de que MongoDB esté 100% listo para recibir conexiones.

### 3. Explicación del empaquetado del APK:
* Al ejecutar `flutter build apk --release`, Flutter compila el código Dart en binarios nativos optimizados para la arquitectura ARM/x86 (Ahead-Of-Time / AOT).
* Se empaquetan los assets, íconos, temas y el motor gráfico de Flutter dentro de un archivo `.apk` firmado en modo release ubicado en `build/app/outputs/flutter-apk/app-release.apk`.

---

## 🛠️ Comandos útiles de Docker para la presentación

| Acción | Comando |
|---|---|
| Levantar todo en segundo plano y compilar | `docker compose up -d --build` |
| Ver estado y salud de los contenedores | `docker compose ps` |
| Ver logs del backend en tiempo real | `docker compose logs -f api` |
| Detener los contenedores | `docker compose down` |
| Detener y borrar volúmenes de datos | `docker compose down -v` |

