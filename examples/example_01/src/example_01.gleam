import daisyui/accordion
import daisyui/text
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn main() {
  let app = lustre.element(view())
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn view() -> Element(Nil) {
  html.div(
    [
      attribute.attribute("data-theme", "light"),
      attribute.class(
        "min-h-screen bg-base-200 flex items-center justify-center",
      ),
    ],
    [
      html.div(
        [
          attribute.class(
            "w-full max-w-lg bg-base-100 rounded-2xl shadow-xl p-8",
          ),
        ],
        [
          faq_text(),
          is_daisyui_working(),
        ],
      ),
    ],
  )
}

fn faq_text() -> Element(Nil) {
  text.new()
  |> text.xl2()
  |> text.bold()
  |> text.warning()
  |> text.text("FAQ")
  |> text.attrs([attribute.class("mb-6 font-sans")])
  |> text.black()
  |> text.h1()
  |> text.build()
}

fn is_daisyui_working() -> Element(Nil) {
  accordion.new()
  |> accordion.attrs([
    attribute.class("border border-base-300 rounded-xl"),
  ])
  |> accordion.arrow()
  |> accordion.title(attrs: [], children: [
    text.new()
    |> text.span()
    |> text.semibold()
    |> text.base_content()
    |> text.text("Is DaisyUI working?")
    |> text.build(),
  ])
  |> accordion.content(attrs: [], children: [
    text.new()
    |> text.p()
    |> text.error()
    |> text.text(
      "Yes! DaisyUI is working correctly alongside Tailwind v4 and Lustre.",
    )
    |> text.build(),
  ])
  |> accordion.build()
}
