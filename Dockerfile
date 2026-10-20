# ==========================================
# ETAPA 1: BUILDER
# ==========================================
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

ARG STUDENT_ID
ENV OPERATOR_ID=${STUDENT_ID}

WORKDIR /build

# Copiar pom.xml primero para aprovechar el caché de capas
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copiar código fuente y empaquetar omitiendo pruebas
COPY src ./src
RUN mvn clean package -DskipTests -B

# ==========================================
# ETAPA 2: RUNTIME
# ==========================================
FROM eclipse-temurin:17-jre-alpine

# Crear grupo y usuario sin privilegios
RUN addgroup -S sensorgroup && \
    adduser -S -u 10001 -G sensorgroup sensor_user

WORKDIR /app

# Copiar solo el JAR generado
COPY --from=builder /build/target/*.jar app.jar

# Dar permisos al usuario
RUN chown -R sensor_user:sensorgroup /app

# Variables de entorno para la JVM
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom"
ENV OPERATOR_ID=${OPERATOR_ID}

# Cambiar al usuario seguro
USER sensor_user

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"] 