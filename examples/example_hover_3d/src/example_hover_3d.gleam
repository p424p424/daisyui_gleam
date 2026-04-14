import daisyui/hover_3d
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
        html.text("Hover 3D"),
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

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      // Image hover
      section("3D image hover effect", [
        hover_3d.new()
          |> hover_3d.children([
            html.figure([attribute.class("max-w-100 rounded-2xl")], [
              html.img([
                attribute.src(
                  "https://img.daisyui.com/images/stock/creditcard.webp",
                ),
                attribute.alt("3D card"),
              ]),
            ]),
          ])
          |> hover_3d.build,
      ]),
      // Clickable card (link variant)
      section("3D card hover effect (whole card is a link)", [
        hover_3d.new()
          |> hover_3d.link("#")
          |> hover_3d.attrs([attribute.class("my-4 mx-2 cursor-pointer")])
          |> hover_3d.children([
            html.div(
              [
                attribute.class(
                  "card w-96 bg-black text-white",
                ),
              ],
              [
                html.div([attribute.class("card-body")], [
                  html.div([attribute.class("flex justify-between mb-10")], [
                    html.div([attribute.class("font-bold")], [
                      html.text("BANK OF LATVERIA"),
                    ]),
                    html.div([attribute.class("text-5xl opacity-10")], [
                      html.text("❁"),
                    ]),
                  ]),
                  html.div([attribute.class("text-lg mb-4 opacity-40")], [
                    html.text("0210 8820 1150 0222"),
                  ]),
                  html.div([attribute.class("flex justify-between")], [
                    html.div([], [
                      html.div([attribute.class("text-xs opacity-20")], [
                        html.text("CARD HOLDER"),
                      ]),
                      html.div([], [html.text("VICTOR VON D.")]),
                    ]),
                    html.div([], [
                      html.div([attribute.class("text-xs opacity-20")], [
                        html.text("EXPIRES"),
                      ]),
                      html.div([], [html.text("29/08")]),
                    ]),
                  ]),
                ]),
              ],
            ),
          ])
          |> hover_3d.build,
      ]),
      // Image gallery
      section("3D hover effect for image gallery", [
        html.div([attribute.class("flex flex-wrap gap-4 justify-center")], [
          hover_3d.new()
            |> hover_3d.children([
              html.figure([attribute.class("w-60 rounded-2xl")], [
                html.img([
                  attribute.src(
                    "https://img.daisyui.com/images/stock/card-1.webp",
                  ),
                  attribute.alt("3D card 1"),
                ]),
              ]),
            ])
            |> hover_3d.build,
          hover_3d.new()
            |> hover_3d.children([
              html.figure([attribute.class("w-60 rounded-2xl")], [
                html.img([
                  attribute.src(
                    "https://img.daisyui.com/images/stock/card-2.webp",
                  ),
                  attribute.alt("3D card 2"),
                ]),
              ]),
            ])
            |> hover_3d.build,
          hover_3d.new()
            |> hover_3d.children([
              html.figure([attribute.class("w-60 rounded-2xl")], [
                html.img([
                  attribute.src(
                    "https://img.daisyui.com/images/stock/card-3.webp",
                  ),
                  attribute.alt("3D card 3"),
                ]),
              ]),
            ])
            |> hover_3d.build,
        ]),
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
