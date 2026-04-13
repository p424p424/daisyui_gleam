import daisyui/countdown
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

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedTheme(t) -> Model(..model, theme: t)
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
        html.text("Countdown"),
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
    [attribute.class("pt-16 flex items-center justify-center min-h-screen")],
    [
      html.div([attribute.class("w-full max-w-xl space-y-10 p-4")], [
        // Single value
        section("Single value", [
          countdown.new(59)
            |> countdown.attrs([attribute.class("font-mono text-5xl")])
            |> countdown.build,
        ]),
        // Min digits
        section("Min digits", [
          html.div([attribute.class("flex items-center gap-4")], [
            html.div([attribute.class("flex flex-col items-center gap-1")], [
              countdown.new(5)
                |> countdown.attrs([attribute.class("font-mono text-5xl")])
                |> countdown.build,
              html.span([attribute.class("text-xs opacity-60")], [
                html.text("default"),
              ]),
            ]),
            html.div([attribute.class("flex flex-col items-center gap-1")], [
              countdown.new(5)
                |> countdown.min_digits(2)
                |> countdown.attrs([attribute.class("font-mono text-5xl")])
                |> countdown.build,
              html.span([attribute.class("text-xs opacity-60")], [
                html.text("min 2 digits"),
              ]),
            ]),
            html.div([attribute.class("flex flex-col items-center gap-1")], [
              countdown.new(5)
                |> countdown.min_digits(3)
                |> countdown.attrs([attribute.class("font-mono text-5xl")])
                |> countdown.build,
              html.span([attribute.class("text-xs opacity-60")], [
                html.text("min 3 digits"),
              ]),
            ]),
          ]),
        ]),
        // Clock layout — HH:MM:SS
        section("Clock layout", [
          html.div(
            [attribute.class("flex items-end gap-2 font-mono text-4xl")],
            [
              digit_with_label(10, "hours"),
              html.span([attribute.class("pb-5 opacity-40")], [html.text(":")]),
              digit_with_label(24, "min"),
              html.span([attribute.class("pb-5 opacity-40")], [html.text(":")]),
              digit_with_label(59, "sec"),
            ],
          ),
        ]),
        // Large value (3 digits)
        section("Three-digit value", [
          countdown.new(999)
            |> countdown.attrs([attribute.class("font-mono text-5xl")])
            |> countdown.build,
        ]),
      ]),
    ],
  )
}

fn section(label: String, children: List(Element(Msg))) -> Element(Msg) {
  html.div([attribute.class("space-y-3")], [
    html.p(
      [attribute.class("text-sm font-semibold opacity-60 uppercase tracking-wide")],
      [html.text(label)],
    ),
    html.div([attribute.class("flex items-center gap-4")], children),
  ])
}

fn digit_with_label(value: Int, label: String) -> Element(Msg) {
  html.div([attribute.class("flex flex-col items-center gap-1")], [
    countdown.new(value)
      |> countdown.min_digits(2)
      |> countdown.build,
    html.span([attribute.class("text-xs opacity-60")], [html.text(label)]),
  ])
}
