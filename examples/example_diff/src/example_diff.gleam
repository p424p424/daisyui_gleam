import daisyui/diff
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

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedTheme(t) -> Model(..model, theme: t)
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Diff")]),
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
    [attribute.class("pt-16 flex items-center justify-center min-h-screen")],
    [
      html.div([attribute.class("w-full max-w-2xl space-y-10 p-4")], [
        // Image diff
        section("Image comparison (drag the resizer)", [
          diff.new()
            |> diff.attrs([attribute.class("aspect-16/9 w-full rounded-xl overflow-hidden")])
            |> diff.item1(
              attrs: [],
              children: [
                html.img([
                  attribute.src(
                    "https://img.daisyui.com/images/stock/photo-1560717789-0ac7c58ac90a.webp",
                  ),
                  attribute.alt("Original photo"),
                ]),
              ],
            )
            |> diff.item2(
              attrs: [],
              children: [
                html.img([
                  attribute.src(
                    "https://img.daisyui.com/images/stock/photo-1560717789-0ac7c58ac90a-blur.webp",
                  ),
                  attribute.alt("Blurred photo"),
                ]),
              ],
            )
            |> diff.build,
        ]),
        // Text / colour diff
        section("Text content comparison", [
          diff.new()
            |> diff.attrs([attribute.class("aspect-16/9 w-full rounded-xl overflow-hidden")])
            |> diff.item1(
              attrs: [],
              children: [
                html.div(
                  [
                    attribute.class(
                      "bg-base-200 grid place-content-center h-full text-9xl font-black select-none",
                    ),
                  ],
                  [html.text("A")],
                ),
              ],
            )
            |> diff.item2(
              attrs: [],
              children: [
                html.div(
                  [
                    attribute.class(
                      "bg-primary grid place-content-center h-full text-9xl font-black text-primary-content select-none",
                    ),
                  ],
                  [html.text("B")],
                ),
              ],
            )
            |> diff.build,
        ]),
      ]),
    ],
  )
}

fn section(label: String, children: List(Element(Msg))) -> Element(Msg) {
  html.div([attribute.class("space-y-3")], [
    html.p(
      [attribute.class("text-sm font-semibold opacity-60 uppercase tracking-wide")],
      [html.text(label)],
    ),
    ..children
  ])
}
