import daisyui/select
import daisyui/timeline
import gleam/list
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
      html.h1([attribute.class("text-lg font-semibold")], [
        html.text("Timeline"),
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

// SVG check-circle icon used throughout examples
fn check_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 20 20"),
      attribute.attribute("fill", "currentColor"),
      attribute.class("h-5 w-5"),
    ],
    [
      svg.path([
        attribute.attribute("fill-rule", "evenodd"),
        attribute.attribute(
          "d",
          "M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z",
        ),
        attribute.attribute("clip-rule", "evenodd"),
      ]),
    ],
  )
}

fn check_icon_primary() -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 20 20"),
      attribute.attribute("fill", "currentColor"),
      attribute.class("h-5 w-5 text-primary"),
    ],
    [
      svg.path([
        attribute.attribute("fill-rule", "evenodd"),
        attribute.attribute(
          "d",
          "M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z",
        ),
        attribute.attribute("clip-rule", "evenodd"),
      ]),
    ],
  )
}

fn apple_items_both(_name: String) -> List(Element(msg)) {
  [
    #("1984", "First Macintosh computer"),
    #("1998", "iMac"),
    #("2001", "iPod"),
    #("2007", "iPhone"),
    #("2015", "Apple Watch"),
  ]
  |> list.index_map(fn(pair, idx) {
    let is_first = idx == 0
    let is_last = idx == 4
    let #(year, label) = pair
    timeline.item()
      |> fn(i) {
        case is_first {
          True -> i
          False -> timeline.item_hr_before(i, [])
        }
      }
      |> timeline.item_start([html.text(year)])
      |> timeline.item_middle(check_icon())
      |> timeline.item_end_box([html.text(label)])
      |> fn(i) {
        case is_last {
          True -> i
          False -> timeline.item_hr_after(i, [])
        }
      }
      |> timeline.item_build
  })
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Horizontal — both sides + icon", [
        timeline.new()
          |> timeline.items(apple_items_both("horiz"))
          |> timeline.build,
      ]),
      section("Horizontal — end (bottom) side only", [
        timeline.new()
          |> timeline.items(
            list.index_map(
              [
                "First Macintosh",
                "iMac",
                "iPod",
                "iPhone",
                "Apple Watch",
              ],
              fn(label, idx) {
                let is_first = idx == 0
                let is_last = idx == 4
                timeline.item()
                  |> fn(i) {
                    case is_first {
                      True -> i
                      False -> timeline.item_hr_before(i, [])
                    }
                  }
                  |> timeline.item_middle(check_icon())
                  |> timeline.item_end_box([html.text(label)])
                  |> fn(i) {
                    case is_last {
                      True -> i
                      False -> timeline.item_hr_after(i, [])
                    }
                  }
                  |> timeline.item_build
              },
            ),
          )
          |> timeline.build,
      ]),
      section("Horizontal — colorful lines", [
        timeline.new()
          |> timeline.items([
            timeline.item()
              |> timeline.item_start_box([html.text("First Macintosh")])
              |> timeline.item_middle(check_icon_primary())
              |> timeline.item_hr_after([attribute.class("bg-primary")])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([attribute.class("bg-primary")])
              |> timeline.item_middle(check_icon_primary())
              |> timeline.item_end_box([html.text("iMac")])
              |> timeline.item_hr_after([attribute.class("bg-primary")])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([attribute.class("bg-primary")])
              |> timeline.item_start_box([html.text("iPod")])
              |> timeline.item_middle(check_icon_primary())
              |> timeline.item_hr_after([])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([])
              |> timeline.item_middle(check_icon())
              |> timeline.item_end_box([html.text("iPhone")])
              |> timeline.item_hr_after([])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([])
              |> timeline.item_start_box([html.text("Apple Watch")])
              |> timeline.item_middle(check_icon())
              |> timeline.item_build,
          ])
          |> timeline.build,
      ]),
      section("Horizontal — no icons", [
        timeline.new()
          |> timeline.items([
            timeline.item()
              |> timeline.item_start_box([html.text("First Macintosh")])
              |> timeline.item_hr_after([])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([])
              |> timeline.item_end_box([html.text("iMac")])
              |> timeline.item_hr_after([])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([])
              |> timeline.item_start_box([html.text("iPod")])
              |> timeline.item_hr_after([])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([])
              |> timeline.item_end_box([html.text("iPhone")])
              |> timeline.item_hr_after([])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([])
              |> timeline.item_start_box([html.text("Apple Watch")])
              |> timeline.item_build,
          ])
          |> timeline.build,
      ]),
      section("Vertical — both sides + icon", [
        timeline.new()
          |> timeline.vertical
          |> timeline.items(apple_items_both("vert"))
          |> timeline.build,
      ]),
      section("Vertical — right side only", [
        timeline.new()
          |> timeline.vertical
          |> timeline.items(
            list.index_map(
              [
                "First Macintosh",
                "iMac",
                "iPod",
                "iPhone",
                "Apple Watch",
              ],
              fn(label, idx) {
                let is_first = idx == 0
                let is_last = idx == 4
                timeline.item()
                  |> fn(i) {
                    case is_first {
                      True -> i
                      False -> timeline.item_hr_before(i, [])
                    }
                  }
                  |> timeline.item_middle(check_icon())
                  |> timeline.item_end_box([html.text(label)])
                  |> fn(i) {
                    case is_last {
                      True -> i
                      False -> timeline.item_hr_after(i, [])
                    }
                  }
                  |> timeline.item_build
              },
            ),
          )
          |> timeline.build,
      ]),
      section("Vertical snap-icon, compact on mobile", [
        timeline.new()
          |> timeline.vertical
          |> timeline.snap_icon
          |> timeline.attrs([attribute.class("max-md:timeline-compact")])
          |> timeline.items([
            timeline.item()
              |> timeline.item_middle(check_icon())
              |> timeline.item_start([
                html.time([attribute.class("font-mono italic")], [
                  html.text("1984"),
                ]),
                html.div([attribute.class("text-lg font-black")], [
                  html.text("First Macintosh computer"),
                ]),
                html.p([], [
                  html.text(
                    "The Apple Macintosh played a pivotal role in establishing desktop publishing as a general office function.",
                  ),
                ]),
              ])
              |> timeline.item_hr_after([])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([])
              |> timeline.item_middle(check_icon())
              |> timeline.item_end([
                html.time([attribute.class("font-mono italic")], [
                  html.text("1998"),
                ]),
                html.div([attribute.class("text-lg font-black")], [
                  html.text("iMac"),
                ]),
                html.p([], [
                  html.text(
                    "iMac is a family of all-in-one Mac desktop computers. It has been the primary part of Apple's consumer desktop offerings since August 1998.",
                  ),
                ]),
              ])
              |> timeline.item_hr_after([])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([])
              |> timeline.item_middle(check_icon())
              |> timeline.item_start([
                html.time([attribute.class("font-mono italic")], [
                  html.text("2001"),
                ]),
                html.div([attribute.class("text-lg font-black")], [
                  html.text("iPod"),
                ]),
                html.p([], [
                  html.text(
                    "The iPod is a discontinued series of portable media players designed and marketed by Apple Inc.",
                  ),
                ]),
              ])
              |> timeline.item_hr_after([])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([])
              |> timeline.item_middle(check_icon())
              |> timeline.item_end([
                html.time([attribute.class("font-mono italic")], [
                  html.text("2007"),
                ]),
                html.div([attribute.class("text-lg font-black")], [
                  html.text("iPhone"),
                ]),
                html.p([], [
                  html.text(
                    "iPhone is a line of smartphones produced by Apple Inc. The first-generation iPhone was announced by Steve Jobs on January 9, 2007.",
                  ),
                ]),
              ])
              |> timeline.item_hr_after([])
              |> timeline.item_build,
            timeline.item()
              |> timeline.item_hr_before([])
              |> timeline.item_middle(check_icon())
              |> timeline.item_start([
                html.time([attribute.class("font-mono italic")], [
                  html.text("2015"),
                ]),
                html.div([attribute.class("text-lg font-black")], [
                  html.text("Apple Watch"),
                ]),
                html.p([], [
                  html.text(
                    "The Apple Watch incorporates fitness tracking, health-oriented capabilities, and wireless telecommunication.",
                  ),
                ]),
              ])
              |> timeline.item_build,
          ])
          |> timeline.build,
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
