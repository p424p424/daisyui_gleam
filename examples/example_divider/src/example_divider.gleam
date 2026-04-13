import daisyui/divider
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
        html.text("Divider"),
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

fn card(label: String) -> Element(Msg) {
  html.div(
    [attribute.class("card bg-base-300 rounded-box grid h-20 place-items-center")],
    [html.text(label)],
  )
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-16 flex items-center justify-center min-h-screen")],
    [
      html.div([attribute.class("w-full max-w-xl space-y-10 p-4")], [
        // Vertical (default) — no label
        section("Vertical, no label", [
          html.div([attribute.class("flex w-full flex-col")], [
            card("Content above"),
            divider.new() |> divider.build,
            card("Content below"),
          ]),
        ]),
        // Vertical with label
        section("Vertical with label", [
          html.div([attribute.class("flex w-full flex-col")], [
            card("Content above"),
            divider.new() |> divider.text("OR") |> divider.build,
            card("Content below"),
          ]),
        ]),
        // Colours
        section("Colours", [
          html.div([attribute.class("flex w-full flex-col gap-0")], [
            divider.new() |> divider.neutral |> divider.text("Neutral") |> divider.build,
            divider.new() |> divider.primary |> divider.text("Primary") |> divider.build,
            divider.new() |> divider.secondary |> divider.text("Secondary") |> divider.build,
            divider.new() |> divider.accent |> divider.text("Accent") |> divider.build,
            divider.new() |> divider.info |> divider.text("Info") |> divider.build,
            divider.new() |> divider.success |> divider.text("Success") |> divider.build,
            divider.new() |> divider.warning |> divider.text("Warning") |> divider.build,
            divider.new() |> divider.error |> divider.text("Error") |> divider.build,
          ]),
        ]),
        // Placement
        section("Label placement", [
          html.div([attribute.class("flex w-full flex-col")], [
            divider.new() |> divider.placement_start |> divider.text("Start") |> divider.build,
            divider.new() |> divider.text("Centre (default)") |> divider.build,
            divider.new() |> divider.placement_end |> divider.text("End") |> divider.build,
          ]),
        ]),
        // Horizontal
        section("Horizontal (flex row)", [
          html.div([attribute.class("flex w-full h-40")], [
            html.div(
              [attribute.class("card bg-base-300 rounded-box grid flex-1 place-items-center")],
              [html.text("Left")],
            ),
            divider.new()
              |> divider.horizontal
              |> divider.text("OR")
              |> divider.build,
            html.div(
              [attribute.class("card bg-base-300 rounded-box grid flex-1 place-items-center")],
              [html.text("Right")],
            ),
          ]),
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
    ..children
  ])
}
