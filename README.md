#  Eco-Air-Backend: Contenerización y Seguridad (Taller Semana 13)

Este repositorio contiene la solución al taller de Docker para el backend `eco-air-backend` (Spring Boot). El proyecto ha sido encapsulado en una imagen de producción ligera, segura y con cuotas estrictas de hardware utilizando las mejores prácticas de DevOps.

##  Autor
- **Estudiante:** William Inzandara
- **Identificador:** 850342

##  Estructura del Repositorio
El proyecto cumple con la estructura exigida, incluyendo los siguientes archivos clave:
- `Dockerfile`: Construcción multietapa (Builder y Runtime) y configuración del usuario no privilegiado.
- `.dockerignore`: Exclusión de archivos innecesarios para mantener el contexto de construcción ligero.
- `audit_session.log`: Registro crudo de terminal (generado con PowerShell) con todas las pruebas forenses.
- `FORENSIC_REPORT.md`: Informe detallado con las tablas de evidencias, hashes y análisis de resultados.
- `src/` y `pom.xml`: Código fuente de la aplicación Java.

##  Características de Seguridad Implementadas
1. **Multi-stage Build:** Se separa el entorno de compilación (Maven) del entorno de ejecución (JRE Alpine), reduciendo el tamaño de la imagen final y la superficie de ataque.
2. **Aislamiento de Privilegios:** La aplicación no se ejecuta como `root`. Se creó el usuario `sensor_user` (UID 10001) asignado al grupo `sensorgroup`.
3. **Inmutabilidad de Runtime:** El usuario no tiene permisos de escritura en directorios críticos del sistema (ej. `/etc`), mitigando la inyección de scripts maliciosos.
4. **Ergonomía de JVM:** Configuración de variables de entorno (`-XX:+UseContainerSupport`, `-XX:MaxRAMPercentage=75.0`) para un rendimiento óptimo dentro del contenedor.

##  Cómo construir y ejecutar

### 1. Construir la imagen
Para inyectar el ID del operador en tiempo de construcción, ejecuta:
```bash
docker build --build-arg STUDENT_ID=850342 -t eco-air-backend:1.0.0 .**
