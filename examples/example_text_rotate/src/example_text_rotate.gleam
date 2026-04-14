import daisyui/select
import daisyui/text_rotate
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub type Model {
  Model(theme: String)
}

pub type Msg {
  UserChangedTheme(String)
}

pub fn main() {
  let app = lustre.simple(fn(_) { Model(theme: "light") }, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn update(_model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedTheme(t) -> Model(theme: t)
  }
}

fn view(model: Model) -> Element(Msg) {
  html.div(
    [
      attribute.attribute("data-theme", model.theme),
      attribute.class("min-h-screen bg-base-200"),
    ],
    [page_header(model.theme), main_content()],
  )
}

fn page_header(current_theme: String) -> Element(Msg) {
  html.header(
    [
      attribute.class(
        "fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 h-16 bg-base-100 shadow",
      ),
    ],
    [
      html.h1([attribute.class("text-lg font-semibold")], [
        html.text("Text Rotate"),
      ]),
      theme_select(current_theme),
    ],
  )
}

fn theme_select(current: String) -> Element(Msg) {
  select.new()
  |> select.sm
  |> select.attrs([attribute.value(current), event.on_input(UserChangedTheme)])
  |> select.children([
    html.option([attribute.value("light")], "Light"),
    html.option([attribute.value("dark")], "Dark"),
    html.option([attribute.value("cupcake")], "Cupcake"),
    html.option([attribute.value("corporate")], "Corporate"),
    html.option([attribute.value("synthwave")], "Synthwave"),
    html.option([attribute.value("retro")], "Retro"),
    html.option([attribute.value("cyberpunk")], "Cyberpunk"),
    html.option([attribute.value("valentine")], "Valentine"),
    html.option([attribute.value("aqua")], "Aqua"),
    html.option([attribute.value("dracula")], "Dracula"),
  ])
  |> select.build
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-12")],
    [
      section("Basic — 3 words, 10 s", [
        text_rotate.new()
          |> text_rotate.items([
            text_rotate.item("ONE"),
            text_rotate.item("TWO"),
            text_rotate.item("THREE"),
          ])
          |> text_rotate.build,
      ]),
      section("6 words, big font, centred", [
        text_rotate.new()
          |> text_rotate.attrs([attribute.class("text-7xl")])
          |> text_rotate.inner_attrs([attribute.class("justify-items-center")])
          |> text_rotate.items([
            text_rotate.item("DESIGN"),
            text_rotate.item("DEVELOP"),
            text_rotate.item("DEPLOY"),
            text_rotate.item("SCALE"),
            text_rotate.item("MAINTAIN"),
            text_rotate.item("REPEAT"),
          ])
          |> text_rotate.build,
      ]),
      section("Inline in a sentence — coloured words", [
        html.span([attribute.class("text-xl")], [
          html.text("Providing AI Agents for "),
          text_rotate.new()
            |> text_rotate.items([
              text_rotate.item_el(
                [attribute.class("bg-teal-400 text-teal-800 px-2")],
                [html.text("Designers")],
              ),
              text_rotate.item_el(
                [attribute.class("bg-red-400 text-red-800 px-2")],
                [html.text("Developers")],
              ),
              text_rotate.item_el(
                [attribute.class("bg-blue-400 text-blue-800 px-2")],
                [html.text("Managers")],
              ),
            ])
            |> text_rotate.build,
        ]),
      ]),
      section("Custom duration — 6 s, big font, centred", [
        text_rotate.new()
          |> text_rotate.attrs([attribute.class("text-7xl duration-6000")])
          |> text_rotate.inner_attrs([attribute.class("justify-items-center")])
          |> text_rotate.items([
            text_rotate.item("BLAZING"),
            text_rotate.item_el(
              [attribute.class("font-bold italic px-2")],
              [html.text("FAST ▶︎▶︎")],
            ),
          ])
          |> text_rotate.build,
      ]),
      section("Custom line height — leading-[2]", [
        text_rotate.new()
          |> text_rotate.attrs([attribute.class("text-7xl leading-[2]")])
          |> text_rotate.inner_attrs([attribute.class("justify-items-center")])
          |> text_rotate.items([
            text_rotate.item("📐 DESIGN"),
            text_rotate.item("⌨️ DEVELOP"),
            text_rotate.item("🌎 DEPLOY"),
            text_rotate.item("🌱 SCALE"),
            text_rotate.item("🔧 MAINTAIN"),
            text_rotate.item("♻️ REPEAT"),
          ])
          |> text_rotate.build,
      ]),
    ],
  )
}

fn section(label: String, children: List(Element(Msg))) -> Element(Msg) {
  html.div([attribute.class("w-full max-w-3xl space-y-3 px-4")], [
    html.p(
      [
        attribute.class(
          "text-sm font-semibold opacity-60 uppercase tracking-wide",
        ),
      ],
      [html.text(label)],
    ),
    ..children
  ])
}
