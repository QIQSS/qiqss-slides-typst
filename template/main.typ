#import "../lib.typ": *

#show: qiqss-theme.with(
  aspect-ratio: "16-9", // "16-9" or "4-3"
  language: "en", // "fr" by default
  footer: "conference", // "author", "institution" or "conference" (default)
  outline-title: [Outline], // Sets the title of outlines
  new-section-style: "outline", // "title", "outline" or none (default)
  section-numbering: "1.", // numbering format for sections
  config-info(
    title: [Presentation title],
    author: [Author Name],
    date: datetime.today().display(),
    authors: ([Author One], [Author Two], [Author Three]),
    institution: [Institution],
    conference: [Conference Lambda],
    logo: image("../assets/QIQSS_logo_v3.svg", height: 1em), // this is the default logo shown
  ),
  // The partner-logos are the logos other than the group's logo (university logo, IQ, financing institutions...)
  // partner-logos: (),
  // num-logos-per-row: 4, // Number of logos per rows for the partner-logos, default is 4
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

#show: appendix // freezes the last-page-number at the slide preceding this show rule

= Appendix section <touying:unoutlined> // The label removes the section from the outline
== Appendix slide

- #lorem(10)

