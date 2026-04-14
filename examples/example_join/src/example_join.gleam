import daisyui/join
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Join")]),
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
      // Horizontal (default)
      section("Horizontal (default)", [
        join.new()
          |> join.children([
            html.button([attribute.class("btn join-item")], [
              html.text("Button"),
            ]),
            html.button([attribute.class("btn join-item")], [
              html.text("Button"),
            ]),
            html.button([attribute.class("btn join-item")], [
              html.text("Button"),
            ]),
          ])
          |> join.build,
      ]),
      // Vertical
      section("Vertical", [
        join.new()
          |> join.vertical
          |> join.children([
            html.button([attribute.class("btn join-item")], [
              html.text("Button"),
            ]),
            html.button([attribute.class("btn join-item")], [
              html.text("Button"),
            ]),
            html.button([attribute.class("btn join-item")], [
              html.text("Button"),
            ]),
          ])
          |> join.build,
      ]),
      // Responsive
      section("Responsive (vertical sm, horizontal lg)", [
        join.new()
          |> join.vertical
          |> join.attrs([attribute.class("lg:join-horizontal")])
          |> join.children([
            html.button([attribute.class("btn join-item")], [
              html.text("Button"),
            ]),
            html.button([attribute.class("btn join-item")], [
              html.text("Button"),
            ]),
            html.button([attribute.class("btn join-item")], [
              html.text("Button"),
            ]),
          ])
          |> join.build,
      ]),
      // Input + select + button with indicator
      section("Input + select + button (with indicator badge)", [
        join.new()
          |> join.children([
            html.div([], [
              html.div([], [
                html.input([
                  attribute.class("input join-item"),
                  attribute.placeholder("Search"),
                ]),
              ]),
            ]),
            html.select([attribute.class("select join-item")], [
              html.option(
                [attribute.disabled(True), attribute.attribute("selected", "")],
                "Filter",
              ),
              html.option([], "Sci-fi"),
              html.option([], "Drama"),
              html.option([], "Action"),
            ]),
            html.div([attribute.class("indicator")], [
              html.span([attribute.class("indicator-item badge badge-secondary")], [
                html.text("new"),
              ]),
              html.button([attribute.class("btn join-item")], [
                html.text("Search"),
              ]),
            ]),
          ])
          |> join.build,
      ]),
      // Custom border radius
      section("Custom border radius", [
        join.new()
          |> join.children([
            html.input([
              attribute.class("input join-item"),
              attribute.placeholder("Email"),
            ]),
            html.button(
              [attribute.class("btn btn-primary join-item rounded-r-full")],
              [html.text("Subscribe")],
            ),
          ])
          |> join.build,
      ]),
      // Radio inputs with btn style
      section("Radio inputs with btn style", [
        join.new()
          |> join.children([
            html.input([
              attribute.class("join-item btn"),
              attribute.type_("radio"),
              attribute.name("options"),
              attribute.attribute("aria-label", "Radio 1"),
            ]),
            html.input([
              attribute.class("join-item btn"),
              attribute.type_("radio"),
              attribute.name("options"),
              attribute.attribute("aria-label", "Radio 2"),
            ]),
            html.input([
              attribute.class("join-item btn"),
              attribute.type_("radio"),
              attribute.name("options"),
              attribute.attribute("aria-label", "Radio 3"),
            ]),
          ])
          |> join.build,
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
