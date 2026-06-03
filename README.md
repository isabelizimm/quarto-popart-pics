# quarto-popart-pics

A Quarto shortcode extension for pop-art style masonry photo galleries. Each image gets a colored rectangle shadow that jumps to the foreground on hover.

## Installing

```bash
quarto add isabelizimm/quarto-popart-pics
```

## Using

Add a `gallery` key to your document YAML front matter with two lists — colors and image paths:

```yaml
---
title: "My Gallery"
format: html
gallery:
  colors:
    - "#E63946"
    - "#A8DADC"
    - "#457B9D"
  images:
    - photos/img1.jpg
    - photos/img2.jpg
    - photos/img3.jpg
---
```

Then place the shortcode anywhere in your document body:

```
{{< popart-gallery >}}
```

Colors cycle automatically if there are more images than colors. You can use any valid CSS color value (hex, named colors, `rgb()`, etc.).

## Layout

- 3-column masonry on desktop, 2-column on tablet, 1-column on mobile
- Images fill their column width and retain aspect ratio
- No JavaScript required — pure CSS hover effect
