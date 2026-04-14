import daisyui/indicator
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
      html.h1([attribute.class("text-lg font-semibold")], [
        html.text("Indicator"),
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

fn content_box() -> Element(Msg) {
  html.div(
    [attribute.class("bg-base-300 grid h-32 w-32 place-items-center")],
    [html.text("content")],
  )
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      // Status indicator
      section("Status indicator", [
        indicator.new()
          |> indicator.children([
            indicator.item_new([])
              |> indicator.item_attrs([
                attribute.class("status status-success"),
              ])
              |> indicator.item_build,
            content_box(),
          ])
          |> indicator.build,
      ]),
      // Badge as indicator
      section("Badge as indicator", [
        html.div([attribute.class("flex flex-wrap gap-4")], [
          // For button
          indicator.new()
            |> indicator.children([
              indicator.item_new([html.text("12")])
                |> indicator.item_attrs([
                  attribute.class("badge badge-secondary"),
                ])
                |> indicator.item_build,
              html.button([attribute.class("btn")], [html.text("inbox")]),
            ])
            |> indicator.build,
          // For input
          indicator.new()
            |> indicator.children([
              indicator.item_new([html.text("Required")])
                |> indicator.item_attrs([attribute.class("badge")])
                |> indicator.item_build,
              html.input([
                attribute.type_("text"),
                attribute.placeholder("Your email address"),
                attribute.class("input input-bordered"),
              ]),
            ])
            |> indicator.build,
        ]),
      ]),
      // Button as indicator for card
      section("Button as indicator for a card", [
        indicator.new()
          |> indicator.children([
            indicator.item_new([
              html.button([attribute.class("btn btn-primary")], [
                html.text("Apply"),
              ]),
            ])
              |> indicator.item_bottom
              |> indicator.item_build,
            html.div([attribute.class("card border-base-300 border shadow-sm")], [
              html.div([attribute.class("card-body")], [
                html.h2([attribute.class("card-title")], [
                  html.text("Job Title"),
                ]),
                html.p([], [
                  html.text("Rerum reiciendis beatae tenetur excepturi"),
                ]),
              ]),
            ]),
          ])
          |> indicator.build,
      ]),
      // Centered overlay
      section("Indicator in center of image", [
        indicator.new()
          |> indicator.children([
            indicator.item_new([html.text("Only available for Pro users")])
              |> indicator.item_h_center
              |> indicator.item_v_middle
              |> indicator.item_build,
            html.img([
              attribute.src(
                "https://img.daisyui.com/images/stock/photo-1606107557195-0e29a4b5b4aa.webp",
              ),
              attribute.alt("indicator demo"),
            ]),
          ])
          |> indicator.build,
      ]),
      // All 9 positions
      section("All placement combinations", [
        indicator.new()
          |> indicator.children([
            indicator.item_new([html.text("↖︎")])
              |> indicator.item_top
              |> indicator.item_start
              |> indicator.item_attrs([attribute.class("badge")])
              |> indicator.item_build,
            indicator.item_new([html.text("↑")])
              |> indicator.item_top
              |> indicator.item_h_center
              |> indicator.item_attrs([attribute.class("badge")])
              |> indicator.item_build,
            indicator.item_new([html.text("↗︎")])
              |> indicator.item_top
              |> indicator.item_end
              |> indicator.item_attrs([attribute.class("badge")])
              |> indicator.item_build,
            indicator.item_new([html.text("←")])
              |> indicator.item_v_middle
              |> indicator.item_start
              |> indicator.item_attrs([attribute.class("badge")])
              |> indicator.item_build,
            indicator.item_new([html.text("●")])
              |> indicator.item_v_middle
              |> indicator.item_h_center
              |> indicator.item_attrs([attribute.class("badge")])
              |> indicator.item_build,
            indicator.item_new([html.text("→")])
              |> indicator.item_v_middle
              |> indicator.item_end
              |> indicator.item_attrs([attribute.class("badge")])
              |> indicator.item_build,
            indicator.item_new([html.text("↙︎")])
              |> indicator.item_bottom
              |> indicator.item_start
              |> indicator.item_attrs([attribute.class("badge")])
              |> indicator.item_build,
            indicator.item_new([html.text("↓")])
              |> indicator.item_bottom
              |> indicator.item_h_center
              |> indicator.item_attrs([attribute.class("badge")])
              |> indicator.item_build,
            indicator.item_new([html.text("↘︎")])
              |> indicator.item_bottom
              |> indicator.item_end
              |> indicator.item_attrs([attribute.class("badge")])
              |> indicator.item_build,
            html.div(
              [
                attribute.class(
                  "bg-base-300 grid h-32 w-60 place-items-center",
                ),
              ],
              [html.text("Box")],
            ),
          ])
          |> indicator.build,
      ]),
    ],
  )
}

fn section(label: String, children: List(Element(Msg))) -> Element(Msg) {
  html.div([attribute.class("w-full max-w-2xl space-y-3 px-4")], [
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
