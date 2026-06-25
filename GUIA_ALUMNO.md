---
title: "Flujo de trabajo reproducible en R para ecoacústica"
subtitle: "Guía de prácticas autocontenida — de la tarjeta SD a la tabla de análisis"
author: "Guillermo Fandos · Universidad Complutense de Madrid"
date: "Reunión REIE · 26 de junio de 2026"
lang: es
---

# Presentación y objetivos

Esta guía conduce, paso a paso y sin dar nada por supuesto, la realización de una
práctica de tratamiento de datos en ecoacústica con el lenguaje R. Está pensada
para personas **sin experiencia previa en R**: se explica desde la instalación del
programa hasta la ejecución completa del flujo de trabajo.

El objetivo de la práctica es transformar unas grabaciones de audio, tal y como se
descargan de la tarjeta de memoria de un grabador, en una **tabla de datos ordenada
y lista para el análisis**, empleando un flujo de trabajo *reproducible*: cualquier
persona que repita los mismos pasos obtiene exactamente el mismo resultado.

Al finalizar, el estudiante será capaz de:

- Obtener los materiales de la práctica e instalar el entorno de trabajo (R y RStudio).
- Ejecutar, mediante una única instrucción, un flujo que convierte grabaciones sin
  procesar en una tabla depurada.
- Reconocer las tres fuentes de error más frecuentes en estos proyectos: la
  nomenclatura de los archivos, la validación de los metadatos y la unión de tablas.
- Comprender el papel del paquete `targets` como capa de orquestación y garantía de
  reproducibilidad.

La sección 4 contiene tres ejercicios guiados de tipo *ejecutar y alterar*: primero
se comprueba el funcionamiento correcto y, después, se introduce un error
controlado para entender la función de cada componente.

> **Cómo usar esta guía.** Realícense los apartados en orden. Las instrucciones que
> aparecen en recuadros con tipografía de máquina de escribir, como
> `targets::tar_make()`, deben escribirse (o copiarse y pegarse) en R tal cual.

# Obtención de los materiales

Los materiales de la práctica están alojados en un repositorio público de GitHub:

<https://github.com/guifandos/acoustic-workflow-REIE>

Existen dos formas de descargarlos. Si no se ha trabajado nunca con GitHub,
utilícese la **Opción A**.

## Opción A — Descarga directa en formato ZIP (recomendada)

1. Ábrase la dirección anterior en un navegador.
2. Púlsese el botón verde **«Code»**, situado en la parte superior derecha del
   listado de archivos.
3. En el menú desplegable, elíjase **«Download ZIP»**.
4. Guárdese el archivo (por ejemplo, en la carpeta *Descargas*) y descomprímase. Se
   creará una carpeta llamada **`acoustic-workflow-REIE-main`**.
5. Por comodidad, muévase esa carpeta a una ubicación estable, como
   *Documentos*, y —si se desea— renómbrese a `acoustic-workflow-REIE` (sin el sufijo
   `-main`). Esta carpeta es el **directorio del proyecto**; su nombre y ubicación
   se necesitarán más adelante.

## Opción B — Clonado con Git

Si el sistema dispone de Git, puede obtenerse el repositorio desde una terminal con:

```bash
git clone https://github.com/guifandos/acoustic-workflow-REIE.git
```

Esta orden crea la carpeta `acoustic-workflow-REIE` con todos los materiales.

# Instalación del entorno

La práctica requiere el programa R y, de forma recomendada, el entorno integrado
RStudio. Ambos son gratuitos. Si ya están instalados, puede pasarse directamente al
apartado 3.4 (instalación de los paquetes).

## Paso 1 — Instalación de R

1. Ábrase la página oficial de descarga: <https://cran.r-project.org>.
2. Selecciónese el sistema operativo correspondiente: **«Download R for Windows»**,
   **«… for macOS»** o **«… for Linux»**.
3. En Windows, púlsese **«base»** y, a continuación, el enlace de descarga del
   instalador. En macOS, descárguese el archivo `.pkg` que corresponda al equipo.
4. Ejecútese el instalador y acéptense las opciones por defecto.

## Paso 2 — Instalación de RStudio

1. Ábrase <https://posit.co/download/rstudio-desktop/>.
2. Descárguese **RStudio Desktop** (versión gratuita) para el sistema operativo
   correspondiente.
3. Ejecútese el instalador con las opciones por defecto.

## Paso 3 — Primer arranque de RStudio

Ábrase RStudio (no es necesario abrir R por separado; RStudio lo utiliza
internamente). La ventana se divide en varios paneles; el más importante para esta
práctica es la **Consola** (*Console*), normalmente situada a la izquierda, donde se
escriben las instrucciones de R.

## Paso 4 — Instalación de los paquetes de R

Un *paquete* es un conjunto de funciones adicionales. Cópiese la siguiente
instrucción en la Consola de RStudio y púlsese Intro. La instalación tarda unos
minutos y solo es necesario realizarla una vez:

```r
install.packages(c("targets", "tarchetypes", "tuneR", "seewave",
                   "data.table", "lubridate", "dplyr", "stringr"))
```

La función de cada grupo de paquetes se resume en el Cuadro 1.

**Cuadro 1.** Paquetes requeridos y su función.

| Paquete | Función |
|---|---|
| `targets`, `tarchetypes` | Orquestación del flujo; recálculo selectivo de lo modificado |
| `tuneR`, `seewave` | Lectura de archivos de audio y cálculo de índices acústicos |
| `data.table`, `lubridate`, `dplyr`, `stringr` | Manejo de fechas, tablas y cadenas de texto |

Los paquetes `sonicscrewdriver` y `soundecology` son opcionales y no resultan
necesarios para esta práctica.

# Puesta en marcha

**Primer paso: situar el directorio de trabajo.** R necesita saber en qué carpeta se
encuentran los materiales. Este es el error más frecuente, por lo que conviene
prestar atención.

En RStudio, utilícese el menú *Session → Set Working Directory → Choose Directory…*
y selecciónese la carpeta del proyecto descargada en el apartado 2 (aquella que
contiene el archivo `_targets.R`).

Para comprobar que la ubicación es correcta, escríbase en la Consola:

```r
getwd()        # su resultado debe terminar en la carpeta del proyecto
list.files()   # debe mostrar _targets.R, R, data_raw, slides, etc.
```

Si `list.files()` muestra esos nombres, todo está en orden.

**Segundo paso: ejecutar el flujo completo.** Escríbase en la Consola:

```r
targets::tar_make()
```

Se observará la ejecución sucesiva de las etapas del flujo y un resumen del control
de calidad. Al finalizar, la tabla de resultados se genera en el archivo
`output/tabla_analisis.csv`. Dicha tabla contiene cinco filas —una por cada
grabación que supera el control de calidad— con la fecha, el grabador, los índices
acústicos y los datos del emplazamiento (coordenadas y hábitat) ya integrados. Esa
tabla es el objetivo de la práctica.

# Procedimiento: ejercicios guiados

Tras cada ejercicio debe deshacerse la modificación introducida y volver a ejecutar
`targets::tar_make()`, de modo que el siguiente ejercicio parta del estado original.

## Ejercicio 1. Ejecución del flujo y examen de la tabla resultante

**Procedimiento.**

```r
targets::tar_make()
tabla <- read.csv("output/tabla_analisis.csv")
View(tabla)        # en RStudio; alternativamente, head(tabla)
```

**Resultados esperados.** El resumen del control de calidad indica `Archivos: 6`,
`Duración anómala: 1` y `PASAN QC: 5 / 6`. La tabla contiene cinco filas, y no seis:
la grabación `…062000_TRUNCADA.WAV` del grabador AM02, de tres segundos en lugar de
los diez esperados, ha sido descartada. Cada fila integra tres ámbitos de
información: la señal de audio (`rms`, `spectral_entropy`), los metadatos
(`datetime`, `recorder_id`, `duration_s`) y el diseño de muestreo (`site`,
`habitat`, `lat`, `lon`).

**Discusión.** Una única instrucción reproduce la totalidad del flujo, desde los
archivos sin procesar hasta una tabla ordenada. El control de calidad ha excluido
la grabación defectuosa sin intervención manual.

## Ejercicio 2. Alteración de la zona horaria y detección de discrepancias

El flujo obtiene la fecha y la hora de cada grabación de dos fuentes independientes
—el nombre del archivo (`20260501_060000.WAV`) y la cabecera interna del archivo
WAV— y verifica su concordancia. En este ejercicio se provoca una discrepancia
deliberada.

**Procedimiento.**

1. Ábrase el archivo `_targets.R` (desde el panel *Files* de RStudio) y localícese
   la línea `recorder_tz <- "UTC"`.
2. Sustitúyase su valor por una zona horaria distinta:

```r
recorder_tz        <- "America/New_York"
```

3. Guárdese el archivo (Ctrl+S) y ejecútese de nuevo `targets::tar_make()`.

**Resultados esperados.** Se generan seis avisos del tipo
`DISCREPANCIA nombre vs cabecera en 20260501_060000.WAV`, y el resumen indica
`Discrepancia nombre/hdr: 6`. Las columnas `dt_name` y `dt_header` muestran
aparentemente la misma hora ("06:00:00") y, sin embargo, el aviso se activa: las
06:00 en la zona de Nueva York y las 06:00 en UTC son instantes distintos,
separados por varias horas.

**Discusión.** Una zona horaria mal configurada altera todas las marcas temporales
sin producir ningún error explícito. La validación cruzada entre el nombre y la
cabecera permite detectar el problema de inmediato.

*Restauración.* Devuélvase `recorder_tz <- "UTC"`, guárdese y ejecútese
`targets::tar_make()`; la discrepancia debe volver a cero.

## Ejercicio 3. Modificación de un umbral de control de calidad

Este ejercicio ilustra el recálculo selectivo de `targets`: al modificar un
elemento, solo se recalcula lo que depende de él.

**Procedimiento.**

1. Ábrase el archivo `R/qc.R` y localícese la función `qc_flag()`, cuyo primer
   parámetro define el umbral de tolerancia de duración (`tol_frac = 0.05`).
2. Auméntese la tolerancia hasta el 75 %:

```r
qc_flag <- function(meta, expected_dur_s = NULL, tol_frac = 0.75) {
```

3. Guárdese y ejecútese `targets::tar_make()`.

**Resultados esperados.** En la consola se distingue qué objetivos se recalculan y
cuáles se reutilizan de la caché (`skip`). El objetivo `meta_raw` —la lectura de los
metadatos, la etapa más costosa— se reutiliza sin volver a ejecutarse. El resultado
cambia: el control de calidad pasa a `PASAN QC: 6 / 6` y la tabla contiene seis
filas, pues la grabación truncada ha dejado de descartarse.

**Discusión.** Se extraen dos conclusiones: `targets` recalcula únicamente las
etapas posteriores a la modificación, lo que ahorra tiempo de cómputo en proyectos
reales; y los umbrales del control de calidad determinan qué datos se incorporan al
análisis.

*Restauración.* Devuélvase `tol_frac = 0.05`, guárdese y ejecútese
`targets::tar_make()`; el resultado debe volver a `PASAN QC: 5 / 6`.

# Resolución de problemas frecuentes

El Cuadro 2 recoge las incidencias más habituales y su solución.

**Cuadro 2.** Incidencias frecuentes y soluciones.

| Síntoma | Causa probable | Solución |
|---|---|---|
| `Error: there is no package called '…'` | Paquetes no instalados | Ejecutar la instrucción de instalación del apartado 3.4 |
| `cannot open file '_targets.R'`; no se encuentran los archivos | Directorio de trabajo incorrecto | Verificar con `getwd()` y corregir con *Set Working Directory* |
| El ejercicio 2 no produce avisos | El archivo no se guardó, o no se reejecutó el flujo | Guardar y ejecutar `targets::tar_invalidate(meta_raw); targets::tar_make()` |
| Aviso `Instala 'sonicscrewdriver'…` | Paquete opcional ausente | Comportamiento normal; el flujo finaliza correctamente |
| Fechas con valor `NA` | Zona horaria mal escrita | Emplear nombres válidos de la base IANA; consultar `OlsonNames()` |
| Error de `callr` o «nombre de archivo demasiado largo» (Windows con OneDrive) | Ruta de usuario con caracteres especiales | Ejecutar `Sys.setenv(HOME = Sys.getenv("USERPROFILE"))` antes de `tar_make()` |

# Recursos y para saber más

Las siguientes herramientas de código abierto resuelven gran parte de este flujo y
permiten ampliar la práctica:

- **warbleR**, **Rraven** y **ohun**: análisis de la estructura de señales acústicas
  en R (tablas de selección, espectrogramas por lotes, medidas acústicas).
- **NSNSDAcoustics**: ejecución del clasificador BirdNET desde R.
- **sonicscrewdriver**: lectura de los metadatos internos de los grabadores AudioMoth.
- **soundecology** (R) y **scikit-maad** (Python): cálculo de índices acústicos.
- **targets** y **renv**: orquestación y fijación de versiones para la reproducibilidad.

# Idea principal

R no realiza la totalidad del análisis. La detección y clasificación de especies
corresponde a modelos especializados, habitualmente implementados en Python. R
destaca como capa de orquestación: gestión de metadatos, control de calidad,
integración de resultados y reproducibilidad. El principal obstáculo en estos
proyectos no reside en el análisis sofisticado, sino en las etapas previas —la
nomenclatura, los metadatos y la organización de los datos—, que son precisamente
el objeto de esta práctica.
