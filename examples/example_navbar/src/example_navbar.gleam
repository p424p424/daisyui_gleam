import daisyui/navbar
import daisyui/select
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Navbar")]),
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

// ---------------------------------------------------------------------------
// Icons
// ---------------------------------------------------------------------------

fn icon_menu() -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class("h-5 w-5"),
      attribute.attribute("fill", "none"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("stroke", "currentColor"),
    ],
    [
      svg.path([
        attribute.attribute("stroke-linecap", "round"),
        attribute.attribute("stroke-linejoin", "round"),
        attribute.attribute("stroke-width", "2"),
        attribute.attribute("d", "M4 6h16M4 12h16M4 18h16"),
      ]),
    ],
  )
}

fn icon_dots() -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class("inline-block h-5 w-5 stroke-current"),
      attribute.attribute("fill", "none"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.path([
        attribute.attribute("stroke-linecap", "round"),
        attribute.attribute("stroke-linejoin", "round"),
        attribute.attribute("stroke-width", "2"),
        attribute.attribute(
          "d",
          "M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z",
        ),
      ]),
    ],
  )
}

fn icon_search() -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class("h-5 w-5"),
      attribute.attribute("fill", "none"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("stroke", "currentColor"),
    ],
    [
      svg.path([
        attribute.attribute("stroke-linecap", "round"),
        attribute.attribute("stroke-linejoin", "round"),
        attribute.attribute("stroke-width", "2"),
        attribute.attribute("d", "M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"),
      ]),
    ],
  )
}

// ---------------------------------------------------------------------------
// Main content
// ---------------------------------------------------------------------------

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Title only", [
        navbar.new()
        |> navbar.bg("bg-base-100")
        |> navbar.attrs([attribute.class("shadow-sm")])
        |> navbar.children([
          html.a([attribute.class("btn btn-ghost text-xl")], [
            html.text("daisyUI"),
          ]),
        ])
        |> navbar.build,
      ]),
      section("Title and icon", [
        navbar.new()
        |> navbar.bg("bg-base-100")
        |> navbar.attrs([attribute.class("shadow-sm")])
        |> navbar.children([
          html.div([attribute.class("flex-1")], [
            html.a([attribute.class("btn btn-ghost text-xl")], [
              html.text("daisyUI"),
            ]),
          ]),
          html.div([attribute.class("flex-none")], [
            html.button([attribute.class("btn btn-square btn-ghost")], [
              icon_dots(),
            ]),
          ]),
        ])
        |> navbar.build,
      ]),
      section("Icon at start and end", [
        navbar.new()
        |> navbar.bg("bg-base-100")
        |> navbar.attrs([attribute.class("shadow-sm")])
        |> navbar.children([
          html.div([attribute.class("flex-none")], [
            html.button([attribute.class("btn btn-square btn-ghost")], [
              icon_menu(),
            ]),
          ]),
          html.div([attribute.class("flex-1")], [
            html.a([attribute.class("btn btn-ghost text-xl")], [
              html.text("daisyUI"),
            ]),
          ]),
          html.div([attribute.class("flex-none")], [
            html.button([attribute.class("btn btn-square btn-ghost")], [
              icon_dots(),
            ]),
          ]),
        ])
        |> navbar.build,
      ]),
      section("With menu and submenu", [
        navbar.new()
        |> navbar.bg("bg-base-100")
        |> navbar.attrs([attribute.class("shadow-sm")])
        |> navbar.children([
          html.div([attribute.class("flex-1")], [
            html.a([attribute.class("btn btn-ghost text-xl")], [
              html.text("daisyUI"),
            ]),
          ]),
          html.div([attribute.class("flex-none")], [
            html.ul([attribute.class("menu menu-horizontal px-1")], [
              html.li([], [html.a([], [html.text("Link")])]),
              html.li([], [
                html.details([], [
                  html.summary([], [html.text("Parent")]),
                  html.ul([attribute.class("bg-base-100 rounded-t-none p-2")], [
                    html.li([], [html.a([], [html.text("Link 1")])]),
                    html.li([], [html.a([], [html.text("Link 2")])]),
                  ]),
                ]),
              ]),
            ]),
          ]),
        ])
        |> navbar.build,
      ]),
      section("Dropdown, center logo, icons (navbar-start/center/end)", [
        navbar.new()
        |> navbar.bg("bg-base-100")
        |> navbar.attrs([attribute.class("shadow-sm")])
        |> navbar.children([
          navbar.start([
            html.div([attribute.class("dropdown")], [
              html.div(
                [
                  attribute.attribute("tabindex", "0"),
                  attribute.role("button"),
                  attribute.class("btn btn-ghost btn-circle"),
                ],
                [icon_menu()],
              ),
              html.ul(
                [
                  attribute.attribute("tabindex", "-1"),
                  attribute.class(
                    "menu menu-sm dropdown-content bg-base-100 rounded-box z-1 mt-3 w-52 p-2 shadow",
                  ),
                ],
                [
                  html.li([], [html.a([], [html.text("Homepage")])]),
                  html.li([], [html.a([], [html.text("Portfolio")])]),
                  html.li([], [html.a([], [html.text("About")])]),
                ],
              ),
            ]),
          ]),
          navbar.center([
            html.a([attribute.class("btn btn-ghost text-xl")], [
              html.text("daisyUI"),
            ]),
          ]),
          navbar.end([
            html.button([attribute.class("btn btn-ghost btn-circle")], [
              icon_search(),
            ]),
          ]),
        ])
        |> navbar.build,
      ]),
      section("Colors", [
        html.div([attribute.class("flex flex-col gap-2 w-full")], [
          navbar.new()
          |> navbar.bg("bg-neutral")
          |> navbar.color("text-neutral-content")
          |> navbar.children([
            html.button([attribute.class("btn btn-ghost text-xl")], [
              html.text("Neutral"),
            ]),
          ])
          |> navbar.build,
          navbar.new()
          |> navbar.bg("bg-base-300")
          |> navbar.children([
            html.button([attribute.class("btn btn-ghost text-xl")], [
              html.text("Base 300"),
            ]),
          ])
          |> navbar.build,
          navbar.new()
          |> navbar.bg("bg-primary")
          |> navbar.color("text-primary-content")
          |> navbar.children([
            html.button([attribute.class("btn btn-ghost text-xl")], [
              html.text("Primary"),
            ]),
          ])
          |> navbar.build,
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
