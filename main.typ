#import "lib.typ": *

#show: qiqss-theme.with(
  aspect-ratio: "16-9",
  footer: "conference",
  // outline-title: [Outline],
  config-info(
    title: [Presentation title],
    author: [Yannick Lapointe],
    date: datetime.today().display(),
    authors: ([Author One], [Author Two], [Author Three]),
    institution: [Institut Quantique],
    conference: [APS March Meeting 2026],
  ),
)

#title-slide()

#outline-slide(title: [Presentation outline])

= First section

== First slide

kajsfsdkjfl

= Second section

== Second slide

= kdjfds

= dhjfksjdf

= jkdsjfsl

= kdsjfkjs

ksghlksjgs

#end-slide(
  body: [Thanks! Questions?],
)
