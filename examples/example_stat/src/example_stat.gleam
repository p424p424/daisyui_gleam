import daisyui/select
import daisyui/stat
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Stat")]),
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

fn icon(path_d: String) -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("fill", "none"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.class("inline-block h-8 w-8 stroke-current"),
    ],
    [
      svg.path([
        attribute.attribute("stroke-linecap", "round"),
        attribute.attribute("stroke-linejoin", "round"),
        attribute.attribute("stroke-width", "2"),
        attribute.attribute("d", path_d),
      ]),
    ],
  )
}

fn icon_heart() -> Element(msg) {
  icon(
    "M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z",
  )
}

fn icon_bolt() -> Element(msg) {
  icon("M13 10V3L4 14h7v7l9-11h-7z")
}

fn icon_info() -> Element(msg) {
  icon("M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z")
}

fn icon_sliders() -> Element(msg) {
  icon(
    "M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4",
  )
}

fn icon_inbox() -> Element(msg) {
  icon(
    "M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4",
  )
}

// ---------------------------------------------------------------------------
// Main content
// ---------------------------------------------------------------------------

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Basic", [
        stat.new()
        |> stat.shadow
        |> stat.items([
          stat.item()
          |> stat.title("Total Page Views")
          |> stat.value("89,400")
          |> stat.desc("21% more than last month")
          |> stat.item_build,
        ])
        |> stat.build,
      ]),
      section("With icons", [
        stat.new()
        |> stat.shadow
        |> stat.items([
          stat.item()
          |> stat.figure(
            html.div([attribute.class("text-primary")], [icon_heart()]),
          )
          |> stat.title("Total Likes")
          |> stat.value_el(
            html.div([attribute.class("stat-value text-primary")], [
              html.text("25.6K"),
            ]),
          )
          |> stat.desc("21% more than last month")
          |> stat.item_build,
          stat.item()
          |> stat.figure(
            html.div([attribute.class("text-secondary")], [icon_bolt()]),
          )
          |> stat.title("Page Views")
          |> stat.value_el(
            html.div([attribute.class("stat-value text-secondary")], [
              html.text("2.6M"),
            ]),
          )
          |> stat.desc("21% more than last month")
          |> stat.item_build,
        ])
        |> stat.build,
      ]),
      section("With figures", [
        stat.new()
        |> stat.shadow
        |> stat.items([
          stat.item()
          |> stat.figure(
            html.div([attribute.class("text-secondary")], [icon_info()]),
          )
          |> stat.title("Downloads")
          |> stat.value("31K")
          |> stat.desc("Jan 1st - Feb 1st")
          |> stat.item_build,
          stat.item()
          |> stat.figure(
            html.div([attribute.class("text-secondary")], [icon_sliders()]),
          )
          |> stat.title("New Users")
          |> stat.value("4,200")
          |> stat.desc("↗︎ 400 (22%)")
          |> stat.item_build,
          stat.item()
          |> stat.figure(
            html.div([attribute.class("text-secondary")], [icon_inbox()]),
          )
          |> stat.title("New Registers")
          |> stat.value("1,200")
          |> stat.desc("↘︎ 90 (14%)")
          |> stat.item_build,
        ])
        |> stat.build,
      ]),
      section("Centered items", [
        stat.new()
        |> stat.shadow
        |> stat.items([
          stat.item()
          |> stat.centered
          |> stat.title("Downloads")
          |> stat.value("31K")
          |> stat.desc("From January 1st to February 1st")
          |> stat.item_build,
          stat.item()
          |> stat.centered
          |> stat.title("Users")
          |> stat.value_el(
            html.div([attribute.class("stat-value text-secondary")], [
              html.text("4,200"),
            ]),
          )
          |> stat.desc_el(
            html.div([attribute.class("stat-desc text-secondary")], [
              html.text("↗︎ 40 (2%)"),
            ]),
          )
          |> stat.item_build,
          stat.item()
          |> stat.centered
          |> stat.title("New Registers")
          |> stat.value("1,200")
          |> stat.desc("↘︎ 90 (14%)")
          |> stat.item_build,
        ])
        |> stat.build,
      ]),
      section("Vertical", [
        stat.new()
        |> stat.vertical
        |> stat.shadow
        |> stat.items([
          stat.item() |> stat.title("Downloads") |> stat.value("31K") |> stat.desc("Jan 1st - Feb 1st") |> stat.item_build,
          stat.item() |> stat.title("New Users") |> stat.value("4,200") |> stat.desc("↗︎ 400 (22%)") |> stat.item_build,
          stat.item() |> stat.title("New Registers") |> stat.value("1,200") |> stat.desc("↘︎ 90 (14%)") |> stat.item_build,
        ])
        |> stat.build,
      ]),
      section("Responsive (vertical → horizontal at lg)", [
        stat.new()
        |> stat.vertical
        |> stat.shadow
        |> stat.attrs([attribute.class("lg:stats-horizontal")])
        |> stat.items([
          stat.item() |> stat.title("Downloads") |> stat.value("31K") |> stat.desc("Jan 1st - Feb 1st") |> stat.item_build,
          stat.item() |> stat.title("New Users") |> stat.value("4,200") |> stat.desc("↗︎ 400 (22%)") |> stat.item_build,
          stat.item() |> stat.title("New Registers") |> stat.value("1,200") |> stat.desc("↘︎ 90 (14%)") |> stat.item_build,
        ])
        |> stat.build,
      ]),
      section("With actions", [
        stat.new()
        |> stat.attrs([attribute.class("bg-base-100 border-base-300 border")])
        |> stat.items([
          stat.item()
          |> stat.title("Account balance")
          |> stat.value("$89,400")
          |> stat.actions(
            html.div([attribute.class("stat-actions")], [
              html.button([attribute.class("btn btn-xs btn-success")], [
                html.text("Add funds"),
              ]),
            ]),
          )
          |> stat.item_build,
          stat.item()
          |> stat.title("Current balance")
          |> stat.value("$89,400")
          |> stat.actions(
            html.div([attribute.class("stat-actions")], [
              html.button([attribute.class("btn btn-xs")], [
                html.text("Withdrawal"),
              ]),
              html.button([attribute.class("btn btn-xs")], [
                html.text("Deposit"),
              ]),
            ]),
          )
          |> stat.item_build,
        ])
        |> stat.build,
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
