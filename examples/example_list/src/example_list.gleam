import daisyui/list
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("List")]),
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

fn play_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.class("size-[1.2em]"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.g(
        [
          attribute.attribute("stroke-linejoin", "round"),
          attribute.attribute("stroke-linecap", "round"),
          attribute.attribute("stroke-width", "2"),
          attribute.attribute("fill", "none"),
          attribute.attribute("stroke", "currentColor"),
        ],
        [svg.path([attribute.attribute("d", "M6 3L20 12 6 21 6 3z")])],
      ),
    ],
  )
}

fn heart_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.class("size-[1.2em]"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.g(
        [
          attribute.attribute("stroke-linejoin", "round"),
          attribute.attribute("stroke-linecap", "round"),
          attribute.attribute("stroke-width", "2"),
          attribute.attribute("fill", "none"),
          attribute.attribute("stroke", "currentColor"),
        ],
        [
          svg.path([
            attribute.attribute(
              "d",
              "M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z",
            ),
          ]),
        ],
      ),
    ],
  )
}

// ---------------------------------------------------------------------------
// Shared song data
// ---------------------------------------------------------------------------

type Song {
  Song(
    rank: String,
    avatar: String,
    artist: String,
    title: String,
    description: String,
  )
}

fn songs() -> List(Song) {
  [
    Song(
      rank: "01",
      avatar: "https://img.daisyui.com/images/profile/demo/1@94.webp",
      artist: "Dio Lupa",
      title: "Remaining Reason",
      description: "\"Remaining Reason\" became an instant hit, praised for its haunting sound and emotional depth.",
    ),
    Song(
      rank: "02",
      avatar: "https://img.daisyui.com/images/profile/demo/4@94.webp",
      artist: "Ellie Beilish",
      title: "Bears of a fever",
      description: "\"Bears of a Fever\" captivated audiences with its intense energy and mysterious lyrics.",
    ),
    Song(
      rank: "03",
      avatar: "https://img.daisyui.com/images/profile/demo/3@94.webp",
      artist: "Sabrino Gardener",
      title: "Cappuccino",
      description: "\"Cappuccino\" quickly gained attention for its smooth melody and relatable themes.",
    ),
  ]
}

fn list_attrs() {
  [attribute.class("bg-base-100 rounded-box shadow-md")]
}

fn header_li() -> Element(msg) {
  html.li(
    [attribute.class("p-4 pb-2 text-xs opacity-60 tracking-wide")],
    [html.text("Most played songs this week")],
  )
}

// ---------------------------------------------------------------------------
// Main content
// ---------------------------------------------------------------------------

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      // Second column grows (default)
      section("Second column grows (default)", [
        list.new()
          |> list.attrs(list_attrs())
          |> list.children(
            [header_li()]
            |> append_all(
              songs()
              |> map_songs(fn(s) {
                list.row_new()
                  |> list.row_children([
                    html.div([], [
                      html.img([
                        attribute.class("size-10 rounded-box"),
                        attribute.src(s.avatar),
                      ]),
                    ]),
                    // second child — grows by default
                    html.div([], [
                      html.div([], [html.text(s.artist)]),
                      html.div(
                        [
                          attribute.class(
                            "text-xs uppercase font-semibold opacity-60",
                          ),
                        ],
                        [html.text(s.title)],
                      ),
                    ]),
                    html.button([attribute.class("btn btn-square btn-ghost")], [
                      play_icon(),
                    ]),
                    html.button([attribute.class("btn btn-square btn-ghost")], [
                      heart_icon(),
                    ]),
                  ])
                  |> list.row_build
              }),
            ),
          )
          |> list.build,
      ]),
      // Third column grows (list-col-grow)
      section("Third column grows (list-col-grow)", [
        list.new()
          |> list.attrs(list_attrs())
          |> list.children(
            [header_li()]
            |> append_all(
              songs()
              |> map_songs(fn(s) {
                list.row_new()
                  |> list.row_children([
                    html.div(
                      [
                        attribute.class(
                          "text-4xl font-thin opacity-30 tabular-nums",
                        ),
                      ],
                      [html.text(s.rank)],
                    ),
                    html.div([], [
                      html.img([
                        attribute.class("size-10 rounded-box"),
                        attribute.src(s.avatar),
                      ]),
                    ]),
                    // explicit list-col-grow on third child
                    html.div([attribute.class("list-col-grow")], [
                      html.div([], [html.text(s.artist)]),
                      html.div(
                        [
                          attribute.class(
                            "text-xs uppercase font-semibold opacity-60",
                          ),
                        ],
                        [html.text(s.title)],
                      ),
                    ]),
                    html.button([attribute.class("btn btn-square btn-ghost")], [
                      play_icon(),
                    ]),
                  ])
                  |> list.row_build
              }),
            ),
          )
          |> list.build,
      ]),
      // Third column wraps (list-col-wrap)
      section("Description wraps to next row (list-col-wrap)", [
        list.new()
          |> list.attrs(list_attrs())
          |> list.children(
            [header_li()]
            |> append_all(
              songs()
              |> map_songs(fn(s) {
                list.row_new()
                  |> list.row_children([
                    html.div([], [
                      html.img([
                        attribute.class("size-10 rounded-box"),
                        attribute.src(s.avatar),
                      ]),
                    ]),
                    html.div([], [
                      html.div([], [html.text(s.artist)]),
                      html.div(
                        [
                          attribute.class(
                            "text-xs uppercase font-semibold opacity-60",
                          ),
                        ],
                        [html.text(s.title)],
                      ),
                    ]),
                    // list-col-wrap pushes this to the next line
                    html.p([attribute.class("list-col-wrap text-xs")], [
                      html.text(s.description),
                    ]),
                    html.button([attribute.class("btn btn-square btn-ghost")], [
                      play_icon(),
                    ]),
                    html.button([attribute.class("btn btn-square btn-ghost")], [
                      heart_icon(),
                    ]),
                  ])
                  |> list.row_build
              }),
            ),
          )
          |> list.build,
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

// ---------------------------------------------------------------------------
// Local list helpers
// ---------------------------------------------------------------------------

fn append_all(a: List(t), b: List(t)) -> List(t) {
  case a {
    [] -> b
    [x, ..rest] -> [x, ..append_all(rest, b)]
  }
}

fn map_songs(songs_list: List(Song), f: fn(Song) -> t) -> List(t) {
  case songs_list {
    [] -> []
    [s, ..rest] -> [f(s), ..map_songs(rest, f)]
  }
}
