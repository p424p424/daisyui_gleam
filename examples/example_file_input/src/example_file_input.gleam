import daisyui/fieldset
import daisyui/file_input
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
        html.text("File Input"),
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
    [attribute.class("pt-20 pb-10 flex justify-center min-h-screen")],
    [
      html.div([attribute.class("w-full max-w-xl space-y-10 p-4")], [
        // Basic
        section("Basic", [
          file_input.new() |> file_input.build,
        ]),
        // Ghost
        section("Ghost", [
          file_input.new() |> file_input.ghost |> file_input.build,
        ]),
        // With fieldset and label
        section("With fieldset and label", [
          fieldset.new()
            |> fieldset.legend("Pick a file")
            |> fieldset.children([
              file_input.new() |> file_input.build,
              html.label([attribute.class("label")], [
                html.text("Max size 2MB"),
              ]),
            ])
            |> fieldset.build,
        ]),
        // Sizes
        section("Sizes", [
          html.div([attribute.class("flex flex-col gap-2")], [
            html.div([attribute.class("flex items-center gap-3")], [
              html.span([attribute.class("text-xs opacity-60 w-6")], [html.text("xs")]),
              file_input.new() |> file_input.xs |> file_input.build,
            ]),
            html.div([attribute.class("flex items-center gap-3")], [
              html.span([attribute.class("text-xs opacity-60 w-6")], [html.text("sm")]),
              file_input.new() |> file_input.sm |> file_input.build,
            ]),
            html.div([attribute.class("flex items-center gap-3")], [
              html.span([attribute.class("text-xs opacity-60 w-6")], [html.text("md")]),
              file_input.new() |> file_input.md |> file_input.build,
            ]),
            html.div([attribute.class("flex items-center gap-3")], [
              html.span([attribute.class("text-xs opacity-60 w-6")], [html.text("lg")]),
              file_input.new() |> file_input.lg |> file_input.build,
            ]),
            html.div([attribute.class("flex items-center gap-3")], [
              html.span([attribute.class("text-xs opacity-60 w-6")], [html.text("xl")]),
              file_input.new() |> file_input.xl |> file_input.build,
            ]),
          ]),
        ]),
        // Colours
        section("Colours", [
          html.div([attribute.class("flex flex-col gap-2")], [
            file_input.new() |> file_input.neutral |> file_input.build,
            file_input.new() |> file_input.primary |> file_input.build,
            file_input.new() |> file_input.secondary |> file_input.build,
            file_input.new() |> file_input.accent |> file_input.build,
            file_input.new() |> file_input.info |> file_input.build,
            file_input.new() |> file_input.success |> file_input.build,
            file_input.new() |> file_input.warning |> file_input.build,
            file_input.new() |> file_input.error |> file_input.build,
          ]),
        ]),
        // Disabled
        section("Disabled", [
          file_input.new() |> file_input.disabled |> file_input.build,
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
