# Recursos abiertos que ya cubren este flujo

No partimos de cero. Estas herramientas y materiales abiertos resuelven gran
parte del camino de la SD a la tabla.

## Manejo de audio y análisis de señal (R)

- **warbleR** — flujo estandarizado para análisis de estructura de señales
  acústicas en R; se apoya en `seewave` y `tuneR`, permite procesamiento por
  lotes y produce espectrogramas para verificar y organizar datos. Tiene varias
  viñetas con ejemplos de cómo organizar el flujo.
  https://marce10.github.io/warbleR/  (artículo: Araya-Salas & Smith-Vidaurre,
  MEE 2017, doi:10.1111/2041-210X.12624)
- **Rraven** — intercambio de datos entre R y Raven (Cornell); útil para
  importar/exportar tablas de selección.
- **ohun** — detección automática optimizada de señales (alternativa moderna a
  la detección de warbleR).
- **seewave** — incluye `audiomoth()` y `songmeter()` para **decodificar la
  fecha/hora desde el nombre** del archivo (formato hex antiguo y
  `YYYYMMDD_HHMMSS` actual).

## Metadatos de grabadores

- **sonicscrewdriver** (CRAN) — `audiomoth_config()` lee el CONFIG.TXT de la SD;
  `audiomoth_wave()` parsea la metadata embebida en el campo *Comment* del WAV
  (hora, temperatura, batería, ganancia...). Es la opción nativa en R.
  https://cran.r-project.org/web/packages/sonicscrewdriver/
- **GUANO** — estándar abierto para metadata embebida en WAV, ampliamente
  reconocido; conviene conocerlo aunque AudioMoth no lo use por defecto.
- (Python) **metamoth** y **aru_metadata_parser** (Kitzes Lab) — parsean
  metadata de AudioMoth, Song Meter, Swift y OwlSense; útiles si tu pipeline
  cruza a Python.

## Clasificación de especies

- **NSNSDAcoustics** (National Park Service) — paquete R que **envuelve
  BirdNET** desde RStudio: `birdnet_analyzer()` para correr el modelo,
  `birdnet_format()` + `birdnet_verify()` para organizar y verificar miles de
  detecciones, y funciones de visualización (heatmaps temporales con horas
  realmente muestreadas). Soporta salida CSV de BirdNET Analyzer v2.
  https://github.com/nationalparkservice/NSNSDAcoustics
  - Guía de instalación de BirdNET + RStudio (Windows):
    https://cbalantic.github.io/Install-BirdNET-Windows-RStudio/
  - Ejemplo de uso real a gran escala (239k detecciones, 30 sitios, BirdNET vía
    NSNSDAcoustics): dataset urbano de Gotemburgo, *Scientific Data* 2025,
    doi:10.1038/s41597-025-05481-z

## Índices acústicos

- **soundecology** (R) — ACI, ADI, AEI, NDSI, índice bioacústico.
- **scikit-maad** (Python) — conjunto de índices más amplio y mantenido; su
  tutorial muestra cómo **parsear la fecha desde el nombre** (`date_parser`,
  modo `SM4` para Song Meter; hex para AudioMoth).
  https://scikit-maad.github.io/

## Reproducibilidad

- **targets** — orquesta el pipeline y recalcula solo lo que cambia.
  https://books.ropensci.org/targets/
- **renv** — fija versiones de paquetes (`renv.lock`).

---

### Lecturas críticas recomendadas para la charla
- Pérez-Granados (2023, *Ibis*): BirdNET — aplicaciones, rendimiento y
  *pitfalls*. Buen contrapunto para no vender BirdNET como caja mágica.
- Thompson et al. (2025, *Ibis*): marco de post-procesado para evaluar la
  exactitud de las identificaciones de BirdNET y la composición de comunidades.
