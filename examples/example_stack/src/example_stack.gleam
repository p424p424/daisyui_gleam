import daisyui/select
import gleam/list
import daisyui/stack
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Stack")]),
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

fn abc_cards() -> List(Element(msg)) {
  ["A", "B", "C"]
  |> list.map(fn(label) {
    html.div(
      [
        attribute.class(
          "border-base-content card bg-base-100 border text-center",
        ),
      ],
      [html.div([attribute.class("card-body")], [html.text(label)])],
    )
  })
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("3 divs", [
        stack.new()
        |> stack.attrs([attribute.class("h-20 w-32")])
        |> stack.children([
          html.div(
            [
              attribute.class(
                "bg-primary text-primary-content grid place-content-center rounded-box",
              ),
            ],
            [html.text("1")],
          ),
          html.div(
            [
              attribute.class(
                "bg-accent text-accent-content grid place-content-center rounded-box",
              ),
            ],
            [html.text("2")],
          ),
          html.div(
            [
              attribute.class(
                "bg-secondary text-secondary-content grid place-content-center rounded-box",
              ),
            ],
            [html.text("3")],
          ),
        ])
        |> stack.build,
      ]),
      section("Stacked images", [
        stack.new()
        |> stack.attrs([attribute.class("w-48")])
        |> stack.children([
          html.img([
            attribute.src(
              "https://img.daisyui.com/images/stock/photo-1572635148818-ef6fd45eb394.webp",
            ),
            attribute.class("rounded-box"),
          ]),
          html.img([
            attribute.src(
              "https://img.daisyui.com/images/stock/photo-1565098772267-60af42b81ef2.webp",
            ),
            attribute.class("rounded-box"),
          ]),
          html.img([
            attribute.src(
              "https://img.daisyui.com/images/stock/photo-1559703248-dcaaec9fab78.webp",
            ),
            attribute.class("rounded-box"),
          ]),
        ])
        |> stack.build,
      ]),
      section("Stacked cards (default / bottom)", [
        stack.new()
        |> stack.attrs([attribute.class("size-28")])
        |> stack.children(abc_cards())
        |> stack.build,
      ]),
      section("Alignment variants", [
        html.div([attribute.class("flex flex-wrap gap-8 items-start")], [
          html.div([attribute.class("flex flex-col items-center gap-1")], [
            html.p([attribute.class("text-xs opacity-60")], [html.text("top")]),
            stack.new() |> stack.top |> stack.attrs([attribute.class("size-28")]) |> stack.children(abc_cards()) |> stack.build,
          ]),
          html.div([attribute.class("flex flex-col items-center gap-1")], [
            html.p([attribute.class("text-xs opacity-60")], [html.text("start")]),
            stack.new() |> stack.start |> stack.attrs([attribute.class("size-28")]) |> stack.children(abc_cards()) |> stack.build,
          ]),
          html.div([attribute.class("flex flex-col items-center gap-1")], [
            html.p([attribute.class("text-xs opacity-60")], [html.text("end")]),
            stack.new() |> stack.end |> stack.attrs([attribute.class("size-28")]) |> stack.children(abc_cards()) |> stack.build,
          ]),
        ]),
      ]),
      section("With shadow", [
        stack.new()
        |> stack.children([
          html.div([attribute.class("card bg-base-200 text-center shadow-md")], [
            html.div([attribute.class("card-body")], [html.text("A")]),
          ]),
          html.div([attribute.class("card bg-base-200 text-center shadow")], [
            html.div([attribute.class("card-body")], [html.text("B")]),
          ]),
          html.div([attribute.class("card bg-base-200 text-center shadow-sm")], [
            html.div([attribute.class("card-body")], [html.text("C")]),
          ]),
        ])
        |> stack.build,
      ]),
      section("Notification cards", [
        stack.new()
        |> stack.children(
          ["1", "2", "3"]
          |> list.map(fn(n) {
            html.div([attribute.class("card shadow-md bg-base-100")], [
              html.div([attribute.class("card-body")], [
                html.h2([attribute.class("card-title")], [
                  html.text("Notification " <> n),
                ]),
                html.p([], [html.text("You have 3 unread messages.")]),
              ]),
            ])
          }),
        )
        |> stack.build,
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

