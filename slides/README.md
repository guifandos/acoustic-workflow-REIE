# slides — Charla REIE

Presentación en **Quarto + revealjs**.

## Renderizar

```bash
quarto render slides.qmd      # genera slides.html
quarto preview slides.qmd     # vista en vivo con recarga
```

O abre `slides.qmd` en RStudio y pulsa **Render**.
Necesitas Quarto instalado (https://quarto.org) — no requiere R para renderizar,
pero sí para ejecutar los `tar_make()` de la demo.

## Dónde van los memes / imágenes

Los huecos están marcados en el `.qmd` con cajas a rayas (`.meme-placeholder`)
y con comentarios `🖼️`. Cuando tengas las imágenes:

1. Guárdalas en `slides/images/`.
2. Sustituye el bloque `::: {.meme-placeholder} ... :::` por:

   ```markdown
   ![](images/mi-meme.png){width="70%"}
   ```

Huecos previstos:
- **¿Te suena esto?** — meme del script `FINAL_v3_BUENO`.
- **Tu turno (2)** — meme de "todo está roto".
- **El left_join asesino** — meme del join que duplica filas.
- **El grafo del pipeline** — captura real de `tar_visnetwork()`.
- **warbleR** — captura del diagrama de su viñeta.
- **Recursos** — QR al repositorio.

## Cambiar a tema claro (proyector con mucha luz)

En el YAML, cambia `theme: [default, custom.scss]` por un tema claro de
revealjs (p. ej. `theme: [simple, custom.scss]`) y ajusta `$body-bg`/`$body-color`
en `custom.scss`. El tema oscuro luce más, pero en una sala muy iluminada el
claro se lee mejor.
