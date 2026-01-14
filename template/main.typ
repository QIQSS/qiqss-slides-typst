#import "../lib.typ": *

#show: qiqss-theme.with(
  aspect-ratio: "16-9",
  footer: "conference",
  outline-title: [Outline],
  new-section-style: "outline",
  config-info(
    title: [Presentation title],
    author: [Author Name],
    date: datetime.today().display(),
    authors: ([Author One], [Author Two], [Author Three]),
    institution: [Institution],
    conference: [Conference Lambda],
  ),
  partner-logos: (
    image("../assets/UdeS_logo_h_rgb.svg", height: 2em),
    image("../assets/institut-quantique-STD-degrade.svg", height: 2em),
  ),
  // num-logos-per-row: 4,
)

#title-slide()

#outline-slide()

= First section

== First slide

- This is some content on the first slide.

= Second section

== Second slide

- This is some other content on the second slide.

#end-slide[Thanks! Questions?]
