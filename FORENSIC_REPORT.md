# FORENSIC REPORT — Taller Docker Semana 13

Integrantes
- Estudiante: William Inzandara — ID UCC: 850342

Tabla de Identidad
| Elemento | Comando Ejecutado | Salida Obtenida |

| **Hash de la imagen** | `docker inspect --format='{{.Id}}' eco-air-backend:1.0.0` | `sha256:39f1b97604714921100b6f381e8e37e34ed3608b39fbf4a6e675893c750e3dab` |
| **Variable OPERATOR_ID** | `docker exec eco_air_active env \| Select-String "OPERATOR_ID"` | `OPERATOR_ID=850342` |
| **Consumo final (512MB)** | `docker stats --no-stream eco_air_active` | `MEM USAGE: 90.92MiB / 512MiB (17.76%) \| CPU: 0.64% \| PIDS: 30` |

## Reto 2 — Auditoría Forense y Vulnerabilidades

1. Verificación del Desacoplamiento de Capas (Auditoría de Artefactos)
Para comprobar que la imagen final no contiene herramientas de desarrollo ni código fuente, se ejecutaron inspecciones internas al contenedor.
Comando: `docker exec eco_air_active which mvn`
Resultado: *(Salida vacía)*. Queda demostrado que Maven no existe en el runtime final.

Comando: `docker exec eco_air_active sh -c 'find / -name "*.java" 2>/dev/null'`
Resultado: *(Salida vacía)*. Queda demostrado que el código fuente no fue copiado a la imagen de producción, cumpliendo con el aislamiento del Multi-stage build.

2. Inspección del Proceso del Host (Aislamiento de Privilegios)
Comando: `docker top eco_air_active -o pid,user,comm`
Resultado:

PID                 USER                COMMAND
941                 10001               java
Análisis: La evidencia demuestra que el proceso de Java no se ejecuta como root (UID 0), sino bajo el UID 10001 (correspondiente al usuario sensor_user). Esto mitiga el riesgo de que un atacante comprometa el contenedor y obtenga control administrativo del host.

3. Test de Penetración: Inmutabilidad de Runtime
Comando: docker exec eco_air_active touch /etc/crontab_fake
Resultado:

text
touch: cannot touch '/etc/crontab_fake': Permission denied
Análisis: El intento de escritura de un script malicioso en un directorio crítico del sistema fue denegado exitosamente. Esto confirma que los permisos del sistema de archivos están correctamente restringidos para el usuario sin privilegios.

## Reto 3 — Calibración de cgroups y Captura del Asesino OOM
1. Inducción del Colapso por Memoria (OOMKilled)
Se sometió el contenedor a una asfixia de memoria asignándole límites inferiores a los requeridos por la JVM.
Comando: docker inspect eco_air_crash --format='Status: {{.State.Status}} | ExitCode: {{.State.ExitCode}} | OOMKilled: {{.State.OOMKilled}}'
Resultado:

text
Status: exited | ExitCode: 137 | OOMKilled: true
Análisis: Con límites de 42MB y 48MB, el kernel de Linux activó el OOM Killer y terminó el proceso. El código de salida 137 (128 + 9 SIGKILL) es la firma inequívoca de que la aplicación intentó consumir más memoria de la permitida y fue eliminada para proteger la estabilidad del host.

2. Calibración del Límite Operativo Mínimo
Se realizaron pruebas iterativas para hallar el umbral mínimo exacto en el que la aplicación inicia y se mantiene estable.

Tabla de Calibración:

Límite Asignado (-m)	Estado	¿OOMKilled?	Observaciones
42m	Exited (137)	True	Falla por asfixia.
48m	Exited (137)	True	Falla por asfixia.
128m	Running	False	Punto más bajo exitoso (Consumo: 68.72%)
255m	Running	False	Consumo: 33.84%
256m	Running	False	Estable.
384m	Running	False	Estable.
512m	Running	False	Holgado (Consumo: 17.76%).
Conclusión: La aplicación Spring Boot necesita aproximadamente 88 MB solo para inicializar la JVM y el framework. Por lo tanto, el umbral operativo mínimo real se encuentra entre los 49 MB y los 127 MB. Establecer un límite de 128 MB es el punto de corte óptimo para producción, ya que deja un pequeño margen de seguridad.

3. Evidencia de Arranque Rápido (Logs)
Comando: docker logs --timestamps eco_air_active | Select-String "Started EcoAirApplication"
Salida (para el límite de 128m):

text
2026-10-21T10:48:30.747761849Z 2026-10-21T10:48:30.747Z  INFO 1 --- [eco-air-backend ] [           main] ecoair.EcoAirApplication                 : Started EcoAirApplication in 1.688 seconds (process running for 2.239)
Análisis: La aplicación arranca en 1.688 segundos, cumpliendo sobradamente con la restricción de arrancar en menos de 15 segundos.

4. Profiling de Memoria en Caliente (Docker Stats)
Consigna: Tabla resultante para el límite mínimo exitoso (128m).

CONTAINER ID	NAME	CPU %	MEM USAGE / LIMIT	MEM %	NET I/O	BLOCK I/O	PIDS
c16455ebf9a7	eco_air_active	0.24%	87.96MiB / 128MiB	68.72%	872B / 126B	34.9MB / 77.8kB	30
Consigna: Tabla resultante para el límite holgado (512m).

CONTAINER ID	NAME	CPU %	MEM USAGE / LIMIT	MEM %	NET I/O	BLOCK I/O	PIDS
0ad39eaf340e	eco_air_active	0.64%	90.92MiB / 512MiB	17.76%	872B / 126B	35MB / 65.5kB	30

