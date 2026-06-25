# _targets.R
# -------------------------------------------------------------------
# Pipeline reproducible del flujo ecoacústico (de la SD a la tabla).
# Ejecuta con:  targets::tar_make()
# Visualiza con: targets::tar_visnetwork()
#
# 'targets' recalcula SOLO lo que cambia. Si editas R/qc.R, recorre de ahí
# en adelante; lo anterior se reutiliza de caché. Eso es lo que hace que el
# pipeline sobreviva a 3 temporadas de campo y al relevo de becarios.
# -------------------------------------------------------------------

library(targets)
library(tarchetypes)  # para tar_files() y branching cómodo

# Cargar todas las funciones de R/
tar_source("R")

tar_option_set(
  packages = c("tuneR", "seewave", "data.table", "lubridate",
               "dplyr", "stringr")
)

# --- Parámetros del proyecto (edítalos para tu campaña) -------------
audio_dir          <- "data_raw"   # carpeta con los .wav (RAW, no se toca)
recorder_tz        <- "UTC"        # zona horaria con la que graba el aparato
expected_dur_s     <- 10           # duración nominal por archivo
expected_interval  <- 10           # minutos entre grabaciones programadas
# -------------------------------------------------------------------

list(
  # 1. Ingesta: localizar archivos de audio
  tar_target(audio_files, list_audio(audio_dir)),

  # 2. Metadatos: nombre + cabecera, con validación cruzada
  tar_target(meta_raw, parse_metadata(audio_files, tz = recorder_tz)),

  # 3. QC: marcar problemáticos y resumir
  tar_target(meta_qc, qc_flag(meta_raw, expected_dur_s = expected_dur_s)),
  tar_target(qc_report, qc_summary(meta_qc)),
  tar_target(gaps, qc_schedule_gaps(meta_qc, expected_interval)),

  # 4. Procesado (solo archivos que pasan QC)
  #    Descomenta el camino que uses:
  tar_target(good_files, meta_qc$file[meta_qc$qc_pass]),
  tar_target(indices, compute_indices_basic(good_files)),  # demo sin deps; usa compute_indices() con soundecology en real
  # tar_target(birdnet_csv, run_birdnet(audio_dir, "output/birdnet")),
  # tar_target(detections, read_birdnet_out(birdnet_csv)),

  # 5. Diseño de muestreo (una fila por grabador/despliegue)
  tar_target(sites_file, "data/sites.csv", format = "file"),
  tar_target(sites, read.csv(sites_file, stringsAsFactors = FALSE)),

  # 6. Consolidación final -> tabla tidy lista para modelar
  tar_target(
    final_table,
    consolidate(indices, meta_qc, sites,
                by_results = "file", by_sites = "recorder_id")
  ),
  tar_target(
    final_csv,
    {
      out <- "output/tabla_analisis.csv"
      write.csv(final_table, out, row.names = FALSE)
      out
    },
    format = "file"
  )
)
