import daisyui/menu
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Menu")]),
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

fn card(children: List(Element(msg))) -> Element(msg) {
  html.div(
    [attribute.class("bg-base-100 rounded-box shadow-md w-56")],
    children,
  )
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Basic", [
        card([
          menu.new()
          |> menu.children([
            html.li([], [html.a([], [html.text("Home")])]),
            html.li([], [html.a([], [html.text("About")])]),
            html.li([], [html.a([], [html.text("Contact")])]),
          ])
          |> menu.build,
        ]),
      ]),
      section("With title", [
        card([
          menu.new()
          |> menu.children([
            html.li([attribute.class("menu-title")], [html.text("Navigation")]),
            html.li([], [html.a([], [html.text("Home")])]),
            html.li([], [html.a([], [html.text("About")])]),
            html.li([attribute.class("menu-title")], [html.text("Settings")]),
            html.li([], [html.a([], [html.text("Account")])]),
            html.li([], [html.a([], [html.text("Privacy")])]),
          ])
          |> menu.build,
        ]),
      ]),
      section("Active and disabled", [
        card([
          menu.new()
          |> menu.children([
            html.li([], [
              html.a([attribute.class("menu-active")], [html.text("Active item")]),
            ]),
            html.li([], [html.a([], [html.text("Normal item")])]),
            html.li([attribute.class("menu-disabled")], [
              html.a([], [html.text("Disabled item")]),
            ]),
          ])
          |> menu.build,
        ]),
      ]),
      section("Submenu (collapsible)", [
        card([
          menu.new()
          |> menu.children([
            html.li([], [html.a([], [html.text("Home")])]),
            html.li([], [
              html.details([], [
                html.summary([], [html.text("Parent")]),
                html.ul([], [
                  html.li([], [html.a([], [html.text("Child 1")])]),
                  html.li([], [html.a([], [html.text("Child 2")])]),
                  html.li([], [html.a([], [html.text("Child 3")])]),
                ]),
              ]),
            ]),
            html.li([], [html.a([], [html.text("Contact")])]),
          ])
          |> menu.build,
        ]),
      ]),
      section("Sizes", [
        html.div([attribute.class("flex flex-wrap gap-4 items-start")], [
          html.div([attribute.class("flex flex-col gap-1")], [
            html.p([attribute.class("text-xs opacity-60")], [html.text("xs")]),
            card([
              menu.new()
              |> menu.xs
              |> menu.children([
                html.li([], [html.a([], [html.text("Item 1")])]),
                html.li([], [html.a([], [html.text("Item 2")])]),
              ])
              |> menu.build,
            ]),
          ]),
          html.div([attribute.class("flex flex-col gap-1")], [
            html.p([attribute.class("text-xs opacity-60")], [html.text("sm")]),
            card([
              menu.new()
              |> menu.sm
              |> menu.children([
                html.li([], [html.a([], [html.text("Item 1")])]),
                html.li([], [html.a([], [html.text("Item 2")])]),
              ])
              |> menu.build,
            ]),
          ]),
          html.div([attribute.class("flex flex-col gap-1")], [
            html.p([attribute.class("text-xs opacity-60")], [html.text("md")]),
            card([
              menu.new()
              |> menu.md
              |> menu.children([
                html.li([], [html.a([], [html.text("Item 1")])]),
                html.li([], [html.a([], [html.text("Item 2")])]),
              ])
              |> menu.build,
            ]),
          ]),
          html.div([attribute.class("flex flex-col gap-1")], [
            html.p([attribute.class("text-xs opacity-60")], [html.text("lg")]),
            card([
              menu.new()
              |> menu.lg
              |> menu.children([
                html.li([], [html.a([], [html.text("Item 1")])]),
                html.li([], [html.a([], [html.text("Item 2")])]),
              ])
              |> menu.build,
            ]),
          ]),
        ]),
      ]),
      section("Horizontal", [
        html.div([attribute.class("bg-base-100 rounded-box shadow-md")], [
          menu.new()
          |> menu.horizontal
          |> menu.children([
            html.li([], [html.a([], [html.text("Home")])]),
            html.li([], [html.a([], [html.text("About")])]),
            html.li([], [html.a([], [html.text("Blog")])]),
            html.li([], [html.a([], [html.text("Contact")])]),
          ])
          |> menu.build,
        ]),
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
