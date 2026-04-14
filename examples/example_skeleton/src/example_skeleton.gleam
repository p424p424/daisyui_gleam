import daisyui/select
import daisyui/skeleton
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
        html.text("Skeleton"),
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
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Basic square", [
        skeleton.box([attribute.class("h-32 w-32")]),
      ]),
      section("Circle with content", [
        html.div([attribute.class("flex w-52 flex-col gap-4")], [
          html.div([attribute.class("flex items-center gap-4")], [
            skeleton.box([attribute.class("h-16 w-16 shrink-0 rounded-full")]),
            html.div([attribute.class("flex flex-col gap-4")], [
              skeleton.box([attribute.class("h-4 w-20")]),
              skeleton.box([attribute.class("h-4 w-28")]),
            ]),
          ]),
          skeleton.box([attribute.class("h-32 w-full")]),
        ]),
      ]),
      section("Rectangle with content", [
        html.div([attribute.class("flex w-52 flex-col gap-4")], [
          skeleton.box([attribute.class("h-32 w-full")]),
          skeleton.box([attribute.class("h-4 w-28")]),
          skeleton.box([attribute.class("h-4 w-full")]),
          skeleton.box([attribute.class("h-4 w-full")]),
        ]),
      ]),
      section("skeleton-text — animated gradient text", [
        skeleton.text("AI is thinking harder..."),
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
