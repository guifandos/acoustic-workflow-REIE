# ============================================================
# De la SD a la tabla — Práctica guiada
# Reunión REIE · 26 de junio de 2026
#
# Ejecuta cada línea con Ctrl+Enter (o selecciona un bloque
# y pulsa Ctrl+Enter para correrlo entero).
# ============================================================


# ============================================================
# EJERCICIO 1
# Ejecutar el flujo completo y examinar la tabla resultante
# ============================================================

# Ejecuta el pipeline completo (tarda unos segundos):
targets::tar_make()

# Lee y abre la tabla final:
tabla <- read.csv("output/tabla_analisis.csv")
View(tabla)       # abre el visor de RStudio

# ¿Cuántas filas tiene?
nrow(tabla)       # esperado: 5

# ¿Qué columnas incluye?
names(tabla)

# ¿Qué grabación faltó y por qué?
# Mira el resumen de QC que apareció en consola arriba:
#   Archivos: 6  |  Duración anómala: 1  |  PASAN QC: 5 / 6


# ============================================================
# EJERCICIO 2
# Zona horaria incorrecta → discrepancia nombre vs cabecera
# ============================================================

# PASO 1 — Abre _targets.R (panel Files → clic en _targets.R)
#           Localiza la línea:
#             recorder_tz  <- "UTC"
#           Cámbiala a:
#             recorder_tz  <- "America/New_York"
#           Guarda el archivo (Ctrl+S).

# PASO 2 — Vuelve aquí y ejecuta:
targets::tar_make()

# Observa los avisos en consola:
#   DISCREPANCIA nombre vs cabecera en 20260501_060000.WAV ...
#   Discrepancia nombre/hdr: 6

# PASO 3 — Mira las columnas dt_name y dt_header de la tabla:
meta <- targets::tar_read(meta_qc)
meta[, c("filename", "dt_name", "dt_header", "name_vs_header_mismatch")]

# ── RESTAURACIÓN ────────────────────────────────────────────
# En _targets.R vuelve a:
#   recorder_tz  <- "UTC"
# Guarda y ejecuta:
targets::tar_make()
# El recuento de discrepancias debe volver a 0.
# ────────────────────────────────────────────────────────────


# ============================================================
# EJERCICIO 3
# Cambiar el umbral de QC → recálculo selectivo de targets
# ============================================================

# PASO 1 — Abre R/qc.R (panel Files → R → qc.R)
#           Localiza la línea:
#             qc_flag <- function(meta, expected_dur_s = NULL, tol_frac = 0.05) {
#           Cámbiala a:
#             qc_flag <- function(meta, expected_dur_s = NULL, tol_frac = 0.75) {
#           Guarda el archivo (Ctrl+S).

# PASO 2 — Vuelve aquí y ejecuta:
targets::tar_make()

# Observa en consola qué targets se recalculan (recalculated)
# y cuáles se reutilizan de la caché (skip).

# PASO 3 — ¿Cuántas filas tiene ahora la tabla?
tabla2 <- read.csv("output/tabla_analisis.csv")
nrow(tabla2)      # esperado: 6 (la grabación truncada ya no se descarta)

# ── RESTAURACIÓN ────────────────────────────────────────────
# En R/qc.R vuelve a:
#   qc_flag <- function(meta, expected_dur_s = NULL, tol_frac = 0.05) {
# Guarda y ejecuta:
targets::tar_make()
# El resultado debe volver a PASAN QC: 5 / 6.
# ────────────────────────────────────────────────────────────


# ============================================================
# EJERCICIO 4
# Un join que infla filas silenciosamente
# ============================================================

# PASO 1 — Abre _targets.R
#           Localiza la línea:
#             tar_target(sites_file, "data/sites.csv", format = "file"),
#           Cámbiala a:
#             tar_target(sites_file, "data/sites_duplicate.csv", format = "file"),
#           Guarda el archivo (Ctrl+S).

# PASO 2 — Vuelve aquí y ejecuta:
targets::tar_make()

# Observa los avisos:
#   Detected an unexpected many-to-many relationship ...
#   El join cambió el nº de filas (5 -> 7). Revisa claves duplicadas ...

# PASO 3 — ¿Cuántas filas tiene la tabla? ¿Qué grabador está duplicado?
tabla3 <- read.csv("output/tabla_analisis.csv")
nrow(tabla3)      # esperado: 7

View(tabla3)      # busca las filas duplicadas de AM02

# PASO 4 — ¿Cuál es la fila duplicada en sites_duplicate.csv?
sites_dup <- read.csv("data/sites_duplicate.csv")
sites_dup
sites_dup[duplicated(sites_dup$recorder_id), ]

# ── RESTAURACIÓN ────────────────────────────────────────────
# En _targets.R vuelve a:
#   tar_target(sites_file, "data/sites.csv", format = "file"),
# Guarda y ejecuta:
targets::tar_make()
# La tabla debe volver a 5 filas.
# ────────────────────────────────────────────────────────────
