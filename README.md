# Eco-Air-Backend: Contenerización y Seguridad 🌍⚙️

[![Java](https://img.shields.io/badge/Java-17%2B-orange?style=flat-square&logo=openjdk)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-brightgreen?style=flat-square&logo=springboot)](https://spring.io/)
[![Docker](https://img.shields.io/badge/Docker-Production%20Ready-blue?style=flat-square&logo=docker)](https://www.docker.com/)

Solución al taller de contenerización y seguridad en Docker para el backend de **Eco-Air-Backend** (Spring Boot). Este proyecto ha sido encapsulado siguiendo estrictos estándares de DevOps, implementando imágenes ligeras, aislamiento de privilegios y cuotas de hardware para entornos de producción.

---

## 👥 Autores

* **William Inzandara** (ID: 850342)
* **Khaled Benavides** (ID: 885768)

---

## 📂 Estructura del Repositorio

El repositorio está organizado de la siguiente manera para garantizar trazabilidad y cumplimiento técnico:

```text
.
├── src/                    # Código fuente de la aplicación Spring Boot
├── pom.xml                 # Configuración de dependencias Maven
├── Dockerfile              # Definición de construcción multietapa y seguridad
├── .dockerignore           # Exclusiones para optimizar el contexto de Docker
├── audit_session.log       # Registro crudo de terminal (PowerShell) con pruebas forenses
└── FORENSIC_REPORT.md      # Informe detallado con tablas de evidencias, hashes y análisis
