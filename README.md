# De la SD a la tabla — flujo reproducible en R para ecoacústica

Material de la práctica de la reunión **REIE 2026**
(Guillermo Fandos · Universidad Complutense de Madrid). Coge unas grabaciones tal y
como salen de la tarjeta SD y, con un solo comando, las convierte en una **tabla
ordenada y lista para analizar**.

> **Idea central:** R no hace *todo*. La detección y clasificación de especies la
> hacen modelos en Python (**BirdNET**) o paquetes de R (**warbleR**); R brilla como
> **capa de orquestación**: metadatos, control de calidad, unión de salidas y
> reproducibilidad.

## 1. Descargar el material

**Sin experiencia en GitHub / Git — descarga directa:**

1. Pulsa el botón verde **`Code ▾`** (arriba a la derecha) y elige **«Download ZIP»**.
2. Descomprime el archivo. Se crea la carpeta `acoustic-workflow-REIE-main`.

**Con Git — clónalo:**

```bash
git clone https://github.com/guifandos/acoustic-workflow-REIE.git
```

## 2. Ejecutar la práctica

1. Instala **R** (≥ 4.2, <https://cran.r-project.org>) y, recomendado, **RStudio**.
2. En la consola de R, instala los paquetes (solo una vez):

   ```r
   install.packages(c("targets", "tarchetypes", "tuneR", "seewave",
                      "data.table", "lubridate", "dplyr", "stringr"))
   ```

3. Abre la carpeta del proyecto como directorio de trabajo y ejecuta:

   ```r
   targets::tar_make()
   ```

   Aparecerá `output/tabla_analisis.csv`: la tabla lista para modelar.

> **Guía completa paso a paso** (desde cero, pensada para principiantes en R, con la
> instalación y los ejercicios): **`GUIA_ALUMNO.docx`** (o `GUIA_ALUMNO.md`).

## 3. Estructura del repositorio

```
acoustic-workflow-REIE/
├── _targets.R         # el pipeline reproducible (orquesta todo)
├── practica.R         # script de los ejercicios guiados
├── R/                 # funciones, una por etapa (parse, qc, indices, consolidate)
├── data_raw/          # grabaciones de ejemplo (RAW, no se tocan)
├── data/sites.csv     # diseño de muestreo (una fila por grabador)
├── output/            # aquí aparece la tabla generada
├── slides/            # presentación (compartida por separado)
├── docs/recursos.md   # herramientas abiertas (warbleR, BirdNET, soundecology…)
└── GUIA_ALUMNO.*      # guía de la práctica
```

`targets` recalcula solo lo que cambia y `data_raw/` es de solo lectura: eso es lo
que hace el flujo reproducible y sostenible entre temporadas de campo.
