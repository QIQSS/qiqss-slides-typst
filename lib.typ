#import "@preview/touying:0.6.1": *
#import "@preview/pinit:0.2.2": *


// Annotating
#let annotate(pin, pos: bottom + right, body-pos: right, body) = context {
  let body-width = measure(body).width
  pinit-point-from(
    pin,
    pin-dx: 0em,
    pin-dy: if pos.y == bottom { 0.5em } else { -1.1em },
    body-dx: if body-pos.x == left { -body-width } else if body-pos.x == right { 0em } else { -body-width / 2 },
    body-dy: if pos.y == bottom { .4em } else { -1.1em },
    offset-dx: if pos.x == left { -2em } else if pos.x == right { 2em } else { 0em },
    offset-dy: if pos.y == bottom { 2.6em } else { -3em },
    body,
  )
}


// Colors
#let colors = (
  qiqss-blue: rgb("#0c287b"),
  udes-green: rgb("#00a759"),
)


// Displays the specified image() of logos in a grid
#let display-logos(logos, num-per-row) = {
  show: pad.with(right: 1em, rest: .5em)
  set align(bottom + right)
  let stacks = ()
  for chunk in logos.chunks(num-per-row) {
    stacks.push(
      stack(
        dir: rtl,
        spacing: 1em,
        ..chunk,
      ),
    )
  }
  stack(
    dir: btt,
    spacing: 1em,
    ..stacks,
  )
}


// Slide
//
// Slide formatting function. Is not normally used by itself, but is called when inserting a header of level 2.
// Configuration of the footer content is done in the qiqss-theme show rule with the "footer" argument
#let slide(title: auto, ..args) = touying-slide-wrapper(self => {
  let header(self) = {
    set align(horizon)
    set text(size: 1.5em)
    show: pad.with(.7em)
    grid(
      align: (left, right),
      columns: (1fr, 1fr),
      utils.display-current-heading(
        level: 2,
      ),
      if self.info.logo != none {
        self.info.logo
      } else {
        image("assets/QIQSS_logo_v3.svg", height: 1em)
      },
    )
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
      footer-content,
      utils.display-current-heading(level: 1),
      context utils.slide-counter.display() + " / " + utils.last-slide-number,
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
//
// The information presented on the title slide is specified using the
// config-info dictionnary in the qiqss-theme function.
#let title-slide() = touying-slide-wrapper(self => {
  let header = {
    set align(top)
    show: pad.with(1em)
    if self.info.logo != none {
      scale(250%, self.info.logo, reflow: true)
    } else {
      image("assets/QIQSS_logo_v3.svg", height: 2.5em)
    }
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
    #v(.75fr)
    #place(bottom + right, display-logos(self.store.partner-logos, self.store.num-logos-per-row))
  ]
  self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      margin: (top: 5em, left: 2.5em, right: 0em, bottom: 0em),
    ),
    config-common(freeze-slide-counter: true),
  )
  touying-slide(self: self, body)
})


// Outline slide
//
// Adds a slide showing the outline of the sections of the presentation
#let outline-slide() = touying-slide-wrapper(self => {
  let header(self) = {
    set align(horizon)
    set text(size: 1.5em)
    show: pad.with(.7em)
    grid(
      align: (left, right),
      columns: (1fr, 1fr),
      utils.call-or-display(self, self.store.outline-title),
      if self.info.logo != none {
        self.info.logo
      } else {
        image("assets/QIQSS_logo_v3.svg", height: 1em)
      },
    )
  }
  set align(horizon)
  self = utils.merge-dicts(
    self,
    config-page(
      fill: self.colors.neutral-light,
      header: header,
      header-ascent: 20%,
    ),
    config-common(
      freeze-slide-counter: true,
    ),
  )
  touying-slide(
    self: self,
    components.adaptive-columns(
      text(
        weight: "medium",
        size: 1.2em,
        outline(depth: 1, title: none),
      ),
    ),
  )
})


// New section slide
//
// There are 3 options :
// 1. The progressive outline showing the current slide
// 2. A simple slide with the title of the section
// 3. No slide
//
// This option is specified by the new-section-style argument of the qiqss-theme function.
#let new-section-slide(level) = touying-slide-wrapper(self => {
  if self.store.new-section-style == "outline" {
    let header(self) = {
      set align(horizon)
      set text(size: 1.5em)
      show: pad.with(.7em)
      grid(
        align: (left, right),
        columns: (1fr, 1fr),
        utils.call-or-display(self, self.store.outline-title),
        if self.info.logo != none {
          self.info.logo
        } else {
          image("assets/QIQSS_logo_v3.svg", height: 1em)
        },
      )
    }
    set align(horizon)
    self = utils.merge-dicts(
      self,
      config-page(
        fill: self.colors.neutral-light,
        header: header,
        header-ascent: 20%,
      ),
      config-common(
        freeze-slide-counter: true,
      ),
    )
    touying-slide(
      self: self,
      components.adaptive-columns(
        text(
          weight: "medium",
          size: 1.2em,
          components.custom-progressive-outline(
            depth: 1,
            alpha: 30%,
            indent: (0em,),
            vspace: (.5em,),
            numbered: (true,),
          ),
        ),
      ),
    )
  } else if self.store.new-section-style == "title" {
    let body = [
      #set align(center + horizon)
      #show: pad.with(x: 20%)

      #stack(
        dir: ttb,
        spacing: 1em,
        text(size: 1.5em, utils.display-current-heading(level: 1)),
        block(
          components.progress-bar(
            self.colors.primary,
            self.colors.primary-light,
            height: 3pt,
          ),
        ),
      )
    ]
    self = utils.merge-dicts(
      self,
      config-common(freeze-slide-counter: true),
      config-page(
        fill: self.colors.neutral-light,
        margin: (bottom: 5em),
      ),
    )
    touying-slide(self: self, body)
  }
})


// End of presentation slide
//
// End slide with some body. The logos are the one specified in the config-store(logos: ()) argument.
#let end-slide(body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      fill: white,
      margin: 0em,
    ),
  )
  touying-slide(
    self: self,
    {
      set align(center)
      text(fill: white, size: 1.5em, body)
      place(
        top,
        block(
          fill: gradient.linear(
            (colors.qiqss-blue, 0%),
            (colors.qiqss-blue, 10%),
            (colors.qiqss-blue.lighten(50%), 100%),
            angle: -45deg,
          ),
          radius: (bottom: 1em),
          width: 100%,
          height: 50%,
          {
            set align(horizon)
            text(fill: white, size: 1.4em, body)
          },
        ),
      )
      place(bottom + right, display-logos(self.store.partner-logos, self.store.num-logos-per-row))
    },
  )
})


// QIQSS Theme
//
// - aspect-ratio (string): The aspect ratio of the slides. Either "4-3" or "16-9". Defailt is "16-9".
//
// - language (string): Language for the text ("en", "fr", etc.).
//
// - footer (string): Content of the footer. Either the "conference", "author" or "institution". Default is "institution".
//
// - outline-title (content | string): Title for the outline slides. Used for the outline-slide() function and the new-section-slide() with the "outline" option.
//
// - new-section-style (str | none): New section slide type. Either "outline", "title" or none. Default is none.
//
// - partner-logos (array): Array of images (logos) to add to the title slide and end slide.
//
// - num-logos-per-row (int): Number of logos per row on the title slide and end slide.
//
// - section-numbering (string): Section numbering format.
//
// - args: Config dictionaries and other arguments for the touying-slides function.
#let qiqss-theme(
  aspect-ratio: "16-9",
  language: "fr",
  footer: "conference",
  outline-title: "Presentation outline",
  new-section-style: none,
  partner-logos: (),
  num-logos-per-row: 4,
  section-numbering: "1.",
  ..args,
  body,
) = {
  if footer not in ("author", "institution", "conference") {
    panic("Either 'author', 'institution' or 'conference'")
  }
  if new-section-style not in ("outline", "title", none) {
    panic("Either 'outline', 'title' or none")
  }
  set text(font: "IBM Plex Sans", size: 16pt, lang: language)
  show math.equation: set text(font: "New Computer Modern Math")
  show heading.where(level: 1): set heading(numbering: section-numbering)
  show outline.entry: it => {
    let loc = it.element.location()
    let num = context counter(heading).at(loc).at(0)
    [#v(.5em)#num.#h(.3em)#it.body()]
  }
  show footnote.entry: set text(size: .75em)
  set footnote.entry(separator: none, indent: 0em)
  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (x: 2.5em, top: 5em, bottom: 1.5em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: if new-section-style != none { new-section-slide },
    ),
    config-colors(
      neutral-lightest: rgb("#f2f2f2"),
      neutral-light: rgb("#dadada"),
      neutral-darkest: rgb("#000000"),
      neutral-dark: rgb("#2d2d2d"),
      primary: colors.qiqss-blue,
      primary-darker: rgb("#091e5d"),
      primary-light: colors.qiqss-blue.lighten(50%),
      secondary: rgb("#d07451"),
      tertiary: rgb("#00a759"),
    ),
    config-store(
      footer: footer,
      outline-title: outline-title,
      new-section-style: new-section-style,
      partner-logos: partner-logos,
      num-logos-per-row: num-logos-per-row,
    ),
    ..args,
  )

  body
}
