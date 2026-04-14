import daisyui/kbd
import daisyui/select
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Kbd")]),
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

fn key(label: String) -> Element(msg) {
  kbd.new(label) |> kbd.build
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      // Basic
      section("Basic", [kbd.new("K") |> kbd.build]),
      // Sizes
      section("Sizes", [
        html.div([attribute.class("flex flex-wrap items-center gap-2")], [
          kbd.new("Xsmall") |> kbd.xs |> kbd.build,
          kbd.new("Small") |> kbd.sm |> kbd.build,
          kbd.new("Medium") |> kbd.md |> kbd.build,
          kbd.new("Large") |> kbd.lg |> kbd.build,
          kbd.new("Xlarge") |> kbd.xl |> kbd.build,
        ]),
      ]),
      // In text
      section("In text", [
        html.p([attribute.class("flex items-center gap-1")], [
          html.text("Press"),
          kbd.new("F") |> kbd.sm |> kbd.build,
          html.text("to pay respects."),
        ]),
      ]),
      // Key combination
      section("Key combination", [
        html.div([attribute.class("flex items-center gap-1")], [
          key("ctrl"),
          html.text("+"),
          key("shift"),
          html.text("+"),
          key("del"),
        ]),
      ]),
      // Function keys
      section("Function keys", [
        html.div([attribute.class("flex gap-1")], [
          key("⌘"),
          key("⌥"),
          key("⇧"),
          key("⌃"),
        ]),
      ]),
      // Full keyboard
      section("Full keyboard", [
        html.div([attribute.class("flex flex-col items-center gap-1")], [
          html.div([attribute.class("flex gap-1")], [
            key("q"), key("w"), key("e"), key("r"), key("t"),
            key("y"), key("u"), key("i"), key("o"), key("p"),
          ]),
          html.div([attribute.class("flex gap-1")], [
            key("a"), key("s"), key("d"), key("f"), key("g"),
            key("h"), key("j"), key("k"), key("l"),
          ]),
          html.div([attribute.class("flex gap-1")], [
            key("z"), key("x"), key("c"), key("v"), key("b"),
            key("n"), key("m"), key("/"),
          ]),
        ]),
      ]),
      // Arrow keys
      section("Arrow keys", [
        html.div([attribute.class("flex flex-col items-center gap-1")], [
          html.div([attribute.class("flex justify-center")], [key("▲")]),
          html.div([attribute.class("flex justify-center gap-12")], [
            key("◀︎"),
            key("▶︎"),
          ]),
          html.div([attribute.class("flex justify-center")], [key("▼")]),
        ]),
      ]),
    ],
  )
}

fn section(label: String, children: List(Element(Msg))) -> Element(Msg) {
  html.div([attribute.class("w-full max-w-xl space-y-3 px-4")], [
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
