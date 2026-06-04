local css_injected = false

return {
  ['popart-gallery'] = function(args, kwargs, meta, raw_args)

    if not quarto.doc.is_format("html:js") then
      return pandoc.RawBlock("html", "<!-- popart-gallery: HTML output only -->")
    end

    if not css_injected then
      quarto.doc.add_html_dependency({
        name        = 'popart-gallery',
        version     = '1.0.0',
        stylesheets = { 'popart-gallery.css' }
      })
      css_injected = true
    end

    local gallery_meta = meta['popart-gallery']
    if not gallery_meta then
      quarto.log.warning("popart-gallery: no 'popart-gallery' key found in YAML front matter.")
      return pandoc.RawBlock("html", "<!-- popart-gallery: missing popart-gallery metadata -->")
    end

    local colors = {}
    if gallery_meta['colors'] then
      for _, item in ipairs(gallery_meta['colors']) do
        table.insert(colors, pandoc.utils.stringify(item))
      end
    end
    if #colors == 0 then
      colors = { "#e66739", "#A8DADC", "#457B9D" }
    end

    local items = {}
    if gallery_meta['items'] then
      for _, entry in ipairs(gallery_meta['items']) do
        local item = {
          src  = pandoc.utils.stringify(entry['src']  or ''),
          text = entry['text'] and pandoc.utils.stringify(entry['text']) or nil,
          link = entry['link'] and pandoc.utils.stringify(entry['link']) or nil,
        }
        if item.src ~= '' then
          table.insert(items, item)
        end
      end
    end
    if #items == 0 then
      quarto.log.warning("popart-gallery: no items specified in gallery metadata.")
      return pandoc.RawBlock("html", "<!-- popart-gallery: no items -->")
    end

    local parts = { '<div class="popart-gallery">' }
    for i, item in ipairs(items) do
      local color      = colors[((i - 1) % #colors) + 1]
      local text_html  = item.text
        and string.format('<span class="popart-text">%s</span>', item.text)
        or  ''
      local inner = string.format(
        '<div class="popart-block" style="background-color: %s;">%s</div>'
          .. '<img src="%s" alt="%s" loading="lazy">',
        color, text_html,
        item.src, item.text or string.format("Gallery image %d", i)
      )
      if item.link then
        inner = string.format('<a class="popart-link" href="%s">%s</a>', item.link, inner)
      end
      table.insert(parts, '<div class="popart-item">' .. inner .. '</div>')
    end
    table.insert(parts, '</div>')

    return pandoc.RawBlock("html", table.concat(parts, '\n'))
  end
}
