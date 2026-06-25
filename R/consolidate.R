# R/consolidate.R
# -------------------------------------------------------------------
# Etapa 5 del flujo: unir todo en una tabla tidy lista para modelar.
#
# AQUÍ está el error didáctico estrella de la charla: un join mal hecho
# que DUPLICA filas e infla las detecciones. Une SIEMPRE comprobando que
# el número de filas es el que esperas.
# -------------------------------------------------------------------

#' Unir detecciones/índices con metadatos y diseño de muestreo
#'
#' @param results    salida de procesado (índices o detecciones de BirdNET)
#' @param meta        tabla de metadatos (parse_metadata + qc_flag)
#' @param sites       diseño de muestreo: una fila por (grabador, despliegue),
#'                    con coordenadas, hábitat, esfuerzo, etc.
#' @param by_results  clave para unir results <-> meta (por defecto "file")
#' @param by_sites    clave para unir meta <-> sites (p. ej. "recorder_id")
#' @return data.frame tidy
consolidate <- function(results, meta, sites,
                        by_results = "file", by_sites = "recorder_id") {
  stopifnot(requireNamespace("dplyr", quietly = TRUE))

  n_in <- nrow(results)

  out <- results |>
    dplyr::left_join(meta, by = by_results) |>
    dplyr::left_join(sites, by = by_sites)

  # Guardarraíl anti-duplicado: si crecen las filas, el join multiplicó.
  if (nrow(out) != n_in) {
    warning(sprintf(
      "El join cambió el nº de filas (%d -> %d). Revisa claves duplicadas en 'sites' o 'meta'.",
      n_in, nrow(out)
    ))
  }
  out
}

#' Comprobar que una clave es única en una tabla (úsalo ANTES de unir)
assert_unique_key <- function(df, key) {
  dup <- sum(duplicated(df[[key]]))
  if (dup > 0L) {
    stop(sprintf("La clave '%s' tiene %d valores duplicados; el join inflará filas.",
                 key, dup))
  }
  invisible(TRUE)
}
