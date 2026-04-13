# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Qué es este proyecto

Microsesión clínica de 6 minutos sobre **rinoconjuntivitis alérgica** para las Sesiones Clínicas de MFyC del HUFJD (16 abril 2026). Autor: Dr. Juan Arenas Montiel, R1 MFyC.

## Arquitectura

- **`presentacion.html`** — Presentación Reveal.js 5.1.0 (cargado vía CDN). Contiene todo el CSS inline (custom properties, grid ARIA, tablas de receta, badges de grado de evidencia). `index.html` redirige aquí.
- **`guion.md`** — Guion del ponente: cada diapositiva con texto en pantalla + notas de ponente con tiempos. Es la fuente de verdad del contenido; la presentación HTML debe reflejar este guion.
- **`evidencia_uptodate.md`** — Síntesis estructurada de 3 artículos de UpToDate (farmacoterapia, clínica/diagnóstico, educación al paciente). Datos con citas a fuente y página.
- **`aria_2024_2025.md`** — Síntesis de las guías ARIA-EAACI 2024-2025 (Parte I: intranasales, Parte II: orales/oculares). 22 recomendaciones GRADE.
- **`referencias/`** — PDFs de artículos originales (ARIA Parts I-II, ICAR-AR 2023) + `resumen_fuentes.md` como índice.
- **`uptodate references/`** — PDFs de UpToDate descargados.

## Cómo visualizar la presentación

Abrir `presentacion.html` en un navegador o servir con cualquier servidor estático:

```bash
python3 -m http.server 8000
# Abrir http://localhost:8000
```

Requiere conexión a internet (Reveal.js se carga desde CDN `cdn.jsdelivr.net`).

## Convenciones de la presentación

- Reveal.js configurado a 1920x1080, transición `slide`, `slideNumber: 'c/t'`.
- Clases CSS semánticas: `.box-green` (leve), `.box-blue` (info/seguimiento), `.box-red` (urgencias/alertas), `.box-orange` (técnica/precaución), `.rx` / `.rx-urg` / `.errors` para tablas específicas.
- Badges de evidencia: `.badge-blue` con grado GRADE (1A, 2B, 2C).
- Los `fragment` de Reveal.js controlan la aparición progresiva de contenido.
- Las referencias van en `.footer-ref` (posición absoluta, esquina inferior izquierda).

## Contenido clínico — fuentes autorizadas

Cualquier modificación de contenido clínico debe basarse en las fuentes del proyecto:
1. UpToDate (Ellis AK, deShazo RD) — Mar/Feb 2026
2. ICAR-AR 2023 (Wise SK et al.) — Int Forum Allergy Rhinol
3. ARIA-EAACI 2024-2025 (Sousa-Pinto B, Bousquet J)
4. Red PALINOCAM — datos polínicos de Madrid

No inventar datos clínicos ni grados de evidencia. Si se necesita información adicional, buscar en PubMed o UpToDate.
