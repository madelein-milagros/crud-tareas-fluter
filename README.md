# 📝 App de Gestión de Tareas (CRUD con Flutter & Firebase)

Una aplicación moderna y reactiva desarrollada en Flutter para la gestión de tareas. Utiliza Cloud Firestore como backend para sincronización de datos en tiempo real y Material Design 3 para una interfaz de usuario atractiva y dinámica.

## 👥 Integrantes
- Milagros Ramos ([@madelein-milagros](https://github.com/madelein-milagros))
- Mayela Ticona ([@Mayela3018](https://github.com/Mayela3018))

## ✨ Características Principales

* **CRUD Completo:** Crea, lee, actualiza y elimina tareas en tiempo real.
* **Dashboard de Progreso:** Visualiza tu porcentaje de tareas completadas de manera interactiva.
* **Sistema de Prioridades:** Clasifica las tareas en prioridad Alta (Rojo), Media (Naranja) y Baja (Verde).
* **Filtros Locales Inteligentes:** Filtra tus tareas por estado (Todas, Pendientes, Completadas) al instante.
* **Búsqueda Rápida:** Encuentra tareas específicas usando la barra de búsqueda superior.
* **Tema Personalizado:** Paleta de colores consistente basada en tonos magenta y borgoña (#E5097F).

## 🛠️ Tecnologías Utilizadas

* [Flutter](https://flutter.dev/) - Framework de UI
* [Dart](https://dart.dev/) - Lenguaje de programación
* [Firebase Core](https://firebase.google.com/docs/flutter/setup) - Inicialización del backend
* [Cloud Firestore](https://firebase.google.com/docs/firestore) - Base de datos NoSQL en tiempo real

## 🚀 Pasos para ejecutar el proyecto localmente

Sigue estos pasos para clonar y correr la aplicación en tu entorno local (ya sea en emulador Android, Web o Windows):

### 1. Clonar el repositorio
```bash
git clone https://github.com/madelein-milagros/crud-tareas-fluter.git
cd flutter_application_1
```

### 2. Instalar dependencias
Asegúrate de tener Flutter instalado y ejecuta:
```bash
flutter pub get
```

### 3. Configurar Firebase (¡Importante!)
Por motivos de seguridad, el archivo que contiene las claves de conexión a Firebase (`lib/firebase_options.dart`) **no está incluido** en este repositorio. Debes generar el tuyo propio conectándolo a tu proyecto de Firebase.

1. Instala Firebase CLI y haz login con tu cuenta de Google:
   ```bash
   firebase login
   ```
2. Instala FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
3. Configura tu proyecto (reemplaza `tu-proyecto-id` con el ID de tu proyecto en Firebase):
   ```bash
   flutterfire configure --project=tu-proyecto-id
   ```
   *Esto generará automáticamente el archivo `lib/firebase_options.dart` necesario para que la app funcione.*

### 4. Ejecutar la aplicación
Para correr la app en Chrome (Web) o en tu dispositivo conectado:
```bash
flutter run -d chrome
```
*(Puedes reemplazar `chrome` por el ID de tu dispositivo o emulador)*

---
**Desarrollado para evaluación académica.**