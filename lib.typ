#import "@preview/touying:0.6.1": *

// Slide
//
// Slide formatting function. Is not normally used by itself, but is called when inserting a header of level 2.
// Configuration of the footer content is done in the qiqss-theme show rule with the "footer" argument.
#let slide(title: auto, ..args) = touying-slide-wrapper(self => {
  let header(self) = {
    set align(horizon)
    set text(size: 1.5em)
    show: pad.with(.5em)
    utils.display-current-heading(level: 2)
  }
  let footer(self) = {
    set align(bottom)
    set text(size: .75em)
    show: components.cell.with(fill: self.colors.neutral-light)
    set align(horizon)
    show: pad.with(.5em)
    let footer-content = if self.store.footer == "author" {
      self.info.author
    } else if self.store.footer == "institution" {
      self.info.institution
    } else if self.store.footer == "conference" and "conference" in self.info.keys() {
      self.info.conference
    } else { self.info.date }
    grid(
      columns: (1fr, 1fr, 1fr),
      align: (left, center, right),
      footer-content, self.info.title, context utils.slide-counter.display() + " / " + utils.last-slide-number,
    )
  }
  self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
      fill: white,
      header-ascent: 20%,
    ),
  )
  touying-slide(self: self, ..args)
})

// Title slide formatter
#let title-slide() = touying-slide-wrapper(self => {
  let header = {
    set align(top)
    show: pad.with(1em)
    image("assets/QIQSS_logo_v3.svg", height: 2.5em)
  }
  let footer = {
    set align(bottom + right)
    show: pad.with(right: 1em, rest: .5em)
    stack(
      dir: ltr,
      spacing: 1em,
      image("assets/institut-quantique-STD-degrade.svg", height: 2em),
      image("assets/UdeS_logo_h_rgb.svg", height: 2em),
    )
  }
  let body = [
    #v(1fr)
    #text(size: 1.8em, self.info.title)
    #v(.75em)
    #text(
      size: 1.1em,
      weight: "medium",
      if "authors" in self.info.keys() {
        grid(
          columns: (auto,) * calc.min(self.info.authors.len(), 4),
          column-gutter: 2em,
          row-gutter: 1em,
          ..self.info.authors,
        )
      } else { self.info.author },
    )
    #v(.75em)
    #if "conference" in self.info.keys() {
      self.info.conference
      v(.75em)
    }
    #utils.display-info-date(self)
    #v(.5fr)
  ]
  self = utils.merge-dicts(
    self,
    config-page(
      fill: self.colors.neutral-light,
      header: header,
      footer: footer,
    ),
    config-common(freeze-slide-counter: true),
  )
  touying-slide(self: self, body)
})

// New section title slides
#let new-section-slide(level) = touying-slide-wrapper(self => {
  let body = [
    #set align(center + horizon)
    #v(1fr)
    #text(
      size: 1.5em,
      utils.display-current-heading(level: 1),
    )
    #v(1fr)
  ]
  let footer = {
    show: components.cell.with(fill: self.colors.primary-darker)
  }
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(footer: footer, margin: (bottom: 50%), fill: self.colors.neutral-light),
  )
  touying-slide(self: self, body)
})

#let end-slide(body: none) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts()
  touying-slide(self: self, body)
})

#let qiqss-theme(
  aspect-ratio: "16-9",
  footer: "author",
  ..args,
  body,
) = {
  if footer not in ("author", "institution", "conference") {
    panic("Either author or institution")
  }
  set text(font: "IBM Plex Sans", size: 16pt)
  show math.equation: set text(font: "New Computer Modern Math")
  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (x: 1.5em, top: 4em, bottom: 1.5em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-colors(
      neutral-lightest: rgb("#f2f2f2"),
      neutral-light: rgb("#dadada"),
      neutral-darkest: rgb("#000000"),
      neutral-dark: rgb("#2d2d2d"),
      primary: rgb("#0c287b"),
      primary-darker: rgb("#091e5d"),
      secondary: rgb("#d07451"),
      tertiary: rgb("#00a759"),
    ),
    config-store(
      footer: footer,
    ),
    ..args,
  )

  body
}
