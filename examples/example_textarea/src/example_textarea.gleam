import daisyui/select
import daisyui/textarea
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
        html.text("Textarea"),
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
    [
      attribute.class(
        "pt-20 pb-10 flex flex-col items-center min-h-screen gap-8",
      ),
    ],
    [
      section("Basic", [
        textarea.new()
        |> textarea.attrs([attribute.placeholder("Bio")])
        |> textarea.build(),
      ]),
      section("Ghost (no background)", [
        textarea.new()
        |> textarea.ghost()
        |> textarea.attrs([attribute.placeholder("Bio")])
        |> textarea.build(),
      ]),
      section("With fieldset label", [
        html.fieldset([attribute.class("fieldset")], [
          html.legend([attribute.class("fieldset-legend")], [
            html.text("Your bio"),
          ]),
          textarea.new()
            |> textarea.attrs([
              attribute.placeholder("Bio"),
              attribute.class("h-24"),
            ])
            |> textarea.build(),
          html.div([attribute.class("label")], [html.text("Optional")]),
        ]),
      ]),
      section("Colors", [
        html.div([attribute.class("flex flex-col gap-2 w-full max-w-xs")], [
          textarea.new()
            |> textarea.primary
            |> textarea.attrs([attribute.placeholder("Primary")])
            |> textarea.build,
          textarea.new()
            |> textarea.secondary
            |> textarea.attrs([attribute.placeholder("Secondary")])
            |> textarea.build,
          textarea.new()
            |> textarea.accent
            |> textarea.attrs([attribute.placeholder("Accent")])
            |> textarea.build,
          textarea.new()
            |> textarea.neutral
            |> textarea.attrs([attribute.placeholder("Neutral")])
            |> textarea.build,
          textarea.new()
            |> textarea.info
            |> textarea.attrs([attribute.placeholder("Info")])
            |> textarea.build,
          textarea.new()
            |> textarea.success
            |> textarea.attrs([attribute.placeholder("Success")])
            |> textarea.build,
          textarea.new()
            |> textarea.warning
            |> textarea.attrs([attribute.placeholder("Warning")])
            |> textarea.build,
          textarea.new()
            |> textarea.error
            |> textarea.attrs([attribute.placeholder("Error")])
            |> textarea.build,
        ]),
      ]),
      section("Sizes", [
        html.div([attribute.class("flex flex-col gap-2 w-full max-w-xs")], [
          textarea.new()
            |> textarea.xs
            |> textarea.attrs([attribute.placeholder("xs")])
            |> textarea.build,
          textarea.new()
            |> textarea.sm
            |> textarea.attrs([attribute.placeholder("sm")])
            |> textarea.build,
          textarea.new()
            |> textarea.md
            |> textarea.attrs([attribute.placeholder("md")])
            |> textarea.build,
          textarea.new()
            |> textarea.lg()
            |> textarea.attrs([attribute.placeholder("lg")])
            |> textarea.build,
          textarea.new()
            |> textarea.xl
            |> textarea.attrs([attribute.placeholder("xl")])
            |> textarea.build,
        ]),
      ]),
      section("Disabled", [
        textarea.new()
        |> textarea.disabled
        |> textarea.attrs([attribute.placeholder("Bio")])
        |> textarea.build,
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
