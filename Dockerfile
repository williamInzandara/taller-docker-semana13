
# ETAPA 1: BUILDER
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

ARG STUDENT_ID
ENV OPERATOR_ID=${STUDENT_ID}

WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests -B


# ETAPA 2: RUNTIME
FROM eclipse-temurin:17-jre-alpine

ARG STUDENT_ID
ENV OPERATOR_ID=${STUDENT_ID}

RUN addgroup -S sensorgroup && \
    adduser -S -u 10001 -G sensorgroup sensor_user

WORKDIR /app

COPY --from=builder /build/target/*.jar app.jar

RUN chown -R sensor_user:sensorgroup /app

ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom"

USER sensor_user

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]  