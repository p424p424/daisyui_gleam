import daisyui/dock
import daisyui/select
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg
import lustre/event

pub type Model {
  Model(theme: String, active_tab: String)
}

pub type Msg {
  UserChangedTheme(String)
  UserChangedTab(String)
}

pub fn main() {
  let app =
    lustre.simple(
      fn(_) { Model(theme: "light", active_tab: "home") },
      update,
      view,
    )
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedTheme(t) -> Model(..model, theme: t)
    UserChangedTab(tab) -> Model(..model, active_tab: tab)
  }
}

fn view(model: Model) -> Element(Msg) {
  html.div(
    [
      attribute.attribute("data-theme", model.theme),
      attribute.class("min-h-screen bg-base-200"),
    ],
    [page_header(model.theme), main_content(model), dock_nav(model.active_tab)],
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Dock")]),
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

fn main_content(model: Model) -> Element(Msg) {
  html.main(
    [
      attribute.class(
        "pt-16 pb-24 flex items-center justify-center min-h-screen",
      ),
    ],
    [
      html.div([attribute.class("w-full max-w-sm space-y-6 p-4")], [
        html.div(
          [attribute.class("card bg-base-100 shadow p-6 text-center space-y-2")],
          [
            html.p([attribute.class("text-4xl")], [
              html.text(tab_icon(model.active_tab)),
            ]),
            html.p([attribute.class("font-semibold text-lg")], [
              html.text(tab_title(model.active_tab)),
            ]),
            html.p([attribute.class("text-sm opacity-60")], [
              html.text("Active tab: " <> model.active_tab),
            ]),
          ],
        ),
        html.p(
          [attribute.class("text-xs text-center opacity-40")],
          [html.text("Tap an item in the dock below to switch tabs.")],
        ),
        // Size variants preview
        html.div([attribute.class("space-y-3")], [
          html.p(
            [attribute.class("text-sm font-semibold opacity-60 uppercase tracking-wide")],
            [html.text("Size variants")],
          ),
          size_preview("xs", dock.xs),
          size_preview("sm", dock.sm),
          size_preview("md (default)", dock.md),
          size_preview("lg", dock.lg),
          size_preview("xl", dock.xl),
        ]),
      ]),
    ],
  )
}

fn dock_nav(active_tab: String) -> Element(Msg) {
  dock.new()
    |> dock.items([
      dock.item_new()
        |> dock.item_attrs([event.on_click(UserChangedTab("home"))])
        |> dock.item_children([icon_home()])
        |> dock.item_label("Home")
        |> with_active(active_tab == "home")
        |> dock.item_build,
      dock.item_new()
        |> dock.item_attrs([event.on_click(UserChangedTab("inbox"))])
        |> dock.item_children([icon_inbox()])
        |> dock.item_label("Inbox")
        |> with_active(active_tab == "inbox")
        |> dock.item_build,
      dock.item_new()
        |> dock.item_attrs([event.on_click(UserChangedTab("settings"))])
        |> dock.item_children([icon_settings()])
        |> dock.item_label("Settings")
        |> with_active(active_tab == "settings")
        |> dock.item_build,
    ])
    |> dock.build
}

fn with_active(item: dock.DockItem(Msg), active: Bool) -> dock.DockItem(Msg) {
  case active {
    True -> dock.item_active(item)
    False -> item
  }
}

fn size_preview(label: String, size_fn: fn(dock.Dock(Msg)) -> dock.Dock(Msg)) -> Element(Msg) {
  html.div([attribute.class("flex items-center gap-3")], [
    html.span([attribute.class("text-xs opacity-60 w-24 shrink-0")], [
      html.text(label),
    ]),
    html.div([attribute.class("relative flex-1 h-16 bg-base-100 rounded-lg overflow-hidden")], [
      dock.new()
        |> size_fn
        |> dock.items([
          dock.item_new() |> dock.item_children([icon_home()]) |> dock.item_build,
          dock.item_new()
            |> dock.item_active
            |> dock.item_children([icon_inbox()])
            |> dock.item_build,
          dock.item_new()
            |> dock.item_children([icon_settings()])
            |> dock.item_build,
        ])
        |> dock.attrs([attribute.class("absolute inset-x-0 bottom-0")])
        |> dock.build,
    ]),
  ])
}

fn tab_icon(tab: String) -> String {
  case tab {
    "home" -> "🏠"
    "inbox" -> "📥"
    "settings" -> "⚙️"
    _ -> "?"
  }
}

fn tab_title(tab: String) -> String {
  case tab {
    "home" -> "Home"
    "inbox" -> "Inbox"
    "settings" -> "Settings"
    _ -> "Unknown"
  }
}

// ---------------------------------------------------------------------------
// Icons (inline SVG)
// ---------------------------------------------------------------------------

fn icon_home() -> Element(Msg) {
  svg.svg(
    [
      attribute.class("size-[1.2em]"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "none"),
      attribute.attribute("stroke", "currentColor"),
      attribute.attribute("stroke-width", "2"),
      attribute.attribute("stroke-linecap", "square"),
      attribute.attribute("stroke-linejoin", "miter"),
    ],
    [
      svg.polyline(
        [attribute.attribute("points", "1 11 12 2 23 11")],
        [],
      ),
      svg.path(
        [
          attribute.attribute(
            "d",
            "m5,13v7c0,1.105.895,2,2,2h10c1.105,0,2-.895,2-2v-7",
          ),
        ],
        [],
      ),
      svg.line(
        [
          attribute.attribute("x1", "12"),
          attribute.attribute("y1", "22"),
          attribute.attribute("x2", "12"),
          attribute.attribute("y2", "18"),
        ],
        [],
      ),
    ],
  )
}

fn icon_inbox() -> Element(Msg) {
  svg.svg(
    [
      attribute.class("size-[1.2em]"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "none"),
      attribute.attribute("stroke", "currentColor"),
      attribute.attribute("stroke-width", "2"),
      attribute.attribute("stroke-linecap", "square"),
      attribute.attribute("stroke-linejoin", "miter"),
    ],
    [
      svg.polyline(
        [attribute.attribute("points", "3 14 9 14 9 17 15 17 15 14 21 14")],
        [],
      ),
      svg.rect(
        [
          attribute.attribute("x", "3"),
          attribute.attribute("y", "3"),
          attribute.attribute("width", "18"),
          attribute.attribute("height", "18"),
          attribute.attribute("rx", "2"),
          attribute.attribute("ry", "2"),
        ],
        [],
      ),
    ],
  )
}

fn icon_settings() -> Element(Msg) {
  svg.svg(
    [
      attribute.class("size-[1.2em]"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "none"),
      attribute.attribute("stroke", "currentColor"),
      attribute.attribute("stroke-width", "2"),
      attribute.attribute("stroke-linecap", "square"),
      attribute.attribute("stroke-linejoin", "miter"),
    ],
    [
      svg.circle(
        [
          attribute.attribute("cx", "12"),
          attribute.attribute("cy", "12"),
          attribute.attribute("r", "3"),
        ],
        [],
      ),
      svg.path(
        [
          attribute.attribute(
            "d",
            "m22,13.25v-2.5l-2.318-.966c-.167-.581-.395-1.135-.682-1.654l.954-2.318-1.768-1.768-2.318.954c-.518-.287-1.073-.515-1.654-.682l-.966-2.318h-2.5l-.966,2.318c-.581.167-1.135.395-1.654.682l-2.318-.954-1.768,1.768.954,2.318c-.287.518-.515,1.073-.682,1.654l-2.318.966v2.5l2.318.966c.167.581.395,1.135.682,1.654l-.954,2.318,1.768,1.768,2.318-.954c.518.287,1.073.515,1.654.682l.966,2.318h2.5l.966-2.318c.581-.167,1.135-.395,1.654-.682l2.318.954,1.768-1.768-.954-2.318c.287-.518.515-1.073.682-1.654l2.318-.966Z",
          ),
        ],
        [],
      ),
    ],
  )
}
