
Este README ya le dice a tu compañero **exactamente** los comandos que debe ejecutar. Copia y pega.

---

## 📋 3. `FORENSIC_REPORT.md` (esqueleto para llenar juntos)

Subir el esqueleto vacío ahora evita conflictos después. Así ambos saben qué campos faltan:

```markdown
# FORENSIC REPORT — Taller Docker Semana 13

## 👥 Integrantes
- Estudiante 1: [Nombre] — ID: [TU_ID]
- Estudiante 2: [Nombre] — ID: [ID_COMPAÑERO]

## 🔐 Tabla de Identidad
| Elemento | Comando | Salida |
| :--- | :--- | :--- |
| Hash de la imagen | `docker inspect --format='{{.Id}}' eco-air-backend:1.0.0` | *(pendiente)* |
| Variable OPERATOR_ID | `docker exec eco_air_active env \| grep OPERATOR_ID` | *(pendiente)* |
| Consumo final calibrado | `docker stats --no-stream eco_air_active` | *(pendiente)* |

## 🧪 Reto 2 — Evidencias
### 1. Desacoplamiento de capas