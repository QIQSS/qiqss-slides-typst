#import "lib.typ": *

#show: qiqss-theme.with(
  aspect-ratio: "16-9",
  footer: "conference",
  // outline-title: [Outline],
  new-section-style: "title",
  config-info(
    title: [Presentation title],
    author: [Yannick Lapointe],
    date: datetime.today().display(),
    authors: ([Author One], [Author Two], [Author Three]),
    institution: [Institut Quantique],
    conference: [APS March Meeting 2026],
  ),
  logos: (
    image("Logos/CRSNG/CRSNG_IMPRESSION/svg/CRSNG_CMYK.svg", height: 2em),
    image("Logos/FRQ_vectoriel.svg", height: 2em),
    image("Logos/3iT_logo_h_rgb_hr.png", height: 2em),
    image("assets/institut-quantique-STD-degrade.svg", height: 2em),
    image("assets/UdeS_logo_h_rgb.svg", height: 2em),
  ),
  // num-logos-per-row: 4,
)

#title-slide()

#outline-slide()

= First section

== First slide

kajsfsdkjfl

// == Other slide



= Second section

== Second slide

ksghlksjgs

#end-slide[Thanks! Questions?]
