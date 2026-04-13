import daisyui/drawer
import daisyui/select
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg
import lustre/event

pub type Demo {
  DemoBasic
  DemoNavbar
  DemoResponsive
  DemoEnd
}

pub type Model {
  Model(theme: String, demo: Demo)
}

pub type Msg {
  UserChangedTheme(String)
  UserChangedDemo(Demo)
}

pub fn main() {
  let app =
    lustre.simple(
      fn(_) { Model(theme: "light", demo: DemoBasic) },
      update,
      view,
    )
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedTheme(t) -> Model(..model, theme: t)
    UserChangedDemo(d) -> Model(..model, demo: d)
  }
}

fn view(model: Model) -> Element(Msg) {
  html.div(
    [attribute.attribute("data-theme", model.theme)],
    [current_demo(model)],
  )
}

fn current_demo(model: Model) -> Element(Msg) {
  case model.demo {
    DemoBasic -> demo_basic(model)
    DemoNavbar -> demo_navbar(model)
    DemoResponsive -> demo_responsive(model)
    DemoEnd -> demo_end(model)
  }
}

// ---------------------------------------------------------------------------
// Demo: Basic drawer
// ---------------------------------------------------------------------------

fn demo_basic(model: Model) -> Element(Msg) {
  drawer.new("drawer-basic")
  |> drawer.content([
    html.div(
      [attribute.class("min-h-screen bg-base-200 flex flex-col")],
      [
        demo_topbar(model, "Basic drawer"),
        html.main(
          [attribute.class("flex-1 flex items-center justify-center p-8")],
          [
            html.div([attribute.class("text-center space-y-4")], [
              html.p([attribute.class("opacity-60 text-sm")], [
                html.text("The drawer slides in from the left."),
              ]),
              html.label(
                [
                  attribute.for("drawer-basic"),
                  attribute.class("btn btn-primary drawer-button"),
                ],
                [html.text("Open drawer")],
              ),
            ]),
          ],
        ),
      ],
    ),
  ])
  |> drawer.sidebar([sidebar_menu("drawer-basic")])
  |> drawer.build
}

// ---------------------------------------------------------------------------
// Demo: Navbar + drawer
// ---------------------------------------------------------------------------

fn demo_navbar(model: Model) -> Element(Msg) {
  drawer.new("drawer-navbar")
  |> drawer.content_attrs([attribute.class("flex flex-col")])
  |> drawer.content([
    html.div(
      [attribute.class("navbar bg-base-300 w-full")],
      [
        html.div([attribute.class("flex-none")], [
          html.label(
            [
              attribute.for("drawer-navbar"),
              attribute.attribute("aria-label", "open sidebar"),
              attribute.class("btn btn-square btn-ghost"),
            ],
            [hamburger_icon()],
          ),
        ]),
        html.div([attribute.class("mx-2 flex-1 px-2 font-semibold")], [
          html.text("Navbar + Drawer"),
        ]),
        demo_tab_menu(model),
        theme_select_inline(model.theme),
      ],
    ),
    html.main(
      [attribute.class("flex-1 bg-base-200 flex items-center justify-center p-8 min-h-[calc(100vh-4rem)]")],
      [
        html.p([attribute.class("opacity-60 text-sm")], [
          html.text("Hamburger menu opens the drawer on any screen size."),
        ]),
      ],
    ),
  ])
  |> drawer.sidebar([sidebar_menu("drawer-navbar")])
  |> drawer.build
}

// ---------------------------------------------------------------------------
// Demo: Responsive drawer (lg:drawer-open)
// ---------------------------------------------------------------------------

fn demo_responsive(model: Model) -> Element(Msg) {
  drawer.new("drawer-responsive")
  |> drawer.responsive_open("lg")
  |> drawer.content_attrs([attribute.class("flex flex-col")])
  |> drawer.content([
    html.div(
      [attribute.class("navbar bg-base-300 w-full lg:hidden")],
      [
        html.div([attribute.class("flex-none")], [
          html.label(
            [
              attribute.for("drawer-responsive"),
              attribute.attribute("aria-label", "open sidebar"),
              attribute.class("btn btn-square btn-ghost"),
            ],
            [hamburger_icon()],
          ),
        ]),
        html.div([attribute.class("flex-1 px-2 font-semibold")], [
          html.text("Responsive Drawer"),
        ]),
      ],
    ),
    html.main(
      [attribute.class("flex-1 bg-base-200 flex flex-col items-center justify-center p-8 min-h-screen gap-4")],
      [
        html.p([attribute.class("font-semibold")], [
          html.text("Responsive: sidebar always visible on lg+"),
        ]),
        html.p([attribute.class("opacity-60 text-sm text-center max-w-xs")], [
          html.text(
            "Resize the window. On large screens the sidebar is always shown. On small screens use the hamburger menu.",
          ),
        ]),
        html.label(
          [
            attribute.for("drawer-responsive"),
            attribute.class("btn drawer-button lg:hidden"),
          ],
          [html.text("Open drawer")],
        ),
        html.div([attribute.class("pt-4")], [demo_tab_menu(model)]),
        theme_select_inline(model.theme),
      ],
    ),
  ])
  |> drawer.sidebar([sidebar_menu("drawer-responsive")])
  |> drawer.build
}

// ---------------------------------------------------------------------------
// Demo: End drawer (right side)
// ---------------------------------------------------------------------------

fn demo_end(model: Model) -> Element(Msg) {
  drawer.new("drawer-end")
  |> drawer.end
  |> drawer.content([
    html.div(
      [attribute.class("min-h-screen bg-base-200 flex flex-col")],
      [
        demo_topbar(model, "End drawer (right side)"),
        html.main(
          [attribute.class("flex-1 flex items-center justify-center p-8")],
          [
            html.div([attribute.class("text-center space-y-4")], [
              html.p([attribute.class("opacity-60 text-sm")], [
                html.text("This drawer slides in from the right."),
              ]),
              html.label(
                [
                  attribute.for("drawer-end"),
                  attribute.class("btn btn-primary drawer-button"),
                ],
                [html.text("Open drawer")],
              ),
            ]),
          ],
        ),
      ],
    ),
  ])
  |> drawer.sidebar([sidebar_menu("drawer-end")])
  |> drawer.build
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

fn demo_topbar(model: Model, title: String) -> Element(Msg) {
  html.header(
    [
      attribute.class(
        "flex items-center justify-between px-6 h-16 bg-base-100 shadow z-10",
      ),
    ],
    [
      html.div([attribute.class("flex items-center gap-4")], [
        html.h1([attribute.class("text-lg font-semibold")], [html.text(title)]),
        demo_tab_menu(model),
      ]),
      theme_select_inline(model.theme),
    ],
  )
}

fn demo_tab_menu(model: Model) -> Element(Msg) {
  html.div([attribute.class("flex gap-1")], [
    tab_btn("Basic", model.demo == DemoBasic, UserChangedDemo(DemoBasic)),
    tab_btn("Navbar", model.demo == DemoNavbar, UserChangedDemo(DemoNavbar)),
    tab_btn(
      "Responsive",
      model.demo == DemoResponsive,
      UserChangedDemo(DemoResponsive),
    ),
    tab_btn("End", model.demo == DemoEnd, UserChangedDemo(DemoEnd)),
  ])
}

fn tab_btn(label: String, active: Bool, msg: Msg) -> Element(Msg) {
  let cls = case active {
    True -> "btn btn-xs btn-primary"
    False -> "btn btn-xs btn-ghost"
  }
  html.button([attribute.class(cls), event.on_click(msg)], [html.text(label)])
}

fn theme_select_inline(current: String) -> Element(Msg) {
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

fn sidebar_menu(drawer_id: String) -> Element(Msg) {
  html.ul(
    [attribute.class("menu bg-base-200 min-h-full w-80 p-4 space-y-1")],
    [
      html.li([attribute.class("menu-title")], [html.text("Navigation")]),
      html.li([], [html.a([], [html.text("Home")])]),
      html.li([], [html.a([], [html.text("About")])]),
      html.li([], [html.a([], [html.text("Portfolio")])]),
      html.li([], [html.a([], [html.text("Contact")])]),
      html.li([attribute.class("menu-title mt-4")], [html.text("Account")]),
      html.li([], [html.a([], [html.text("Profile")])]),
      html.li([], [html.a([], [html.text("Settings")])]),
      html.li([], [
        html.label(
          [attribute.for(drawer_id), attribute.class("btn btn-sm btn-ghost justify-start mt-4")],
          [html.text("← Close sidebar")],
        ),
      ]),
    ],
  )
}

fn hamburger_icon() -> Element(Msg) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("fill", "none"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.class("inline-block h-6 w-6 stroke-current"),
    ],
    [
      svg.path(
        [
          attribute.attribute("stroke-linecap", "round"),
          attribute.attribute("stroke-linejoin", "round"),
          attribute.attribute("stroke-width", "2"),
          attribute.attribute("d", "M4 6h16M4 12h16M4 18h16"),
        ],
        [],
      ),
    ],
  )
}
