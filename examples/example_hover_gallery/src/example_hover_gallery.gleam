import daisyui/hover_gallery
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
        html.text("Hover Gallery"),
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

fn hat_images() -> List(#(String, String)) {
  [
    #(
      "https://img.daisyui.com/images/stock/daisyui-hat-1.webp",
      "daisyUI hat view 1",
    ),
    #(
      "https://img.daisyui.com/images/stock/daisyui-hat-2.webp",
      "daisyUI hat view 2",
    ),
    #(
      "https://img.daisyui.com/images/stock/daisyui-hat-3.webp",
      "daisyUI hat view 3",
    ),
    #(
      "https://img.daisyui.com/images/stock/daisyui-hat-4.webp",
      "daisyUI hat view 4",
    ),
  ]
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      // Basic gallery
      section("Basic hover gallery (move mouse horizontally)", [
        hover_gallery.new()
          |> hover_gallery.attrs([attribute.class("max-w-60")])
          |> hover_gallery.images(hat_images())
          |> hover_gallery.build,
      ]),
      // In a card
      section("Hover gallery in a product card", [
        html.div([attribute.class("card card-sm bg-base-100 max-w-60 shadow")], [
          hover_gallery.new()
            |> hover_gallery.images(hat_images())
            |> hover_gallery.build,
          html.div([attribute.class("card-body")], [
            html.h2([attribute.class("card-title flex justify-between")], [
              html.text("daisyUI Hat"),
              html.span([attribute.class("font-normal")], [html.text("$25")]),
            ]),
            html.p([], [
              html.text("High quality classic cap hat with stitch logo"),
            ]),
          ]),
        ]),
      ]),
      // Multiple galleries side by side
      section("Multiple galleries (image gallery layout)", [
        html.div([attribute.class("flex flex-wrap gap-4 justify-center")], [
          hover_gallery.new()
            |> hover_gallery.attrs([attribute.class("w-40")])
            |> hover_gallery.images([
              #(
                "https://img.daisyui.com/images/stock/daisyui-hat-1.webp",
                "Hat 1",
              ),
              #(
                "https://img.daisyui.com/images/stock/daisyui-hat-2.webp",
                "Hat 2",
              ),
            ])
            |> hover_gallery.build,
          hover_gallery.new()
            |> hover_gallery.attrs([attribute.class("w-40")])
            |> hover_gallery.images([
              #(
                "https://img.daisyui.com/images/stock/daisyui-hat-3.webp",
                "Hat 3",
              ),
              #(
                "https://img.daisyui.com/images/stock/daisyui-hat-4.webp",
                "Hat 4",
              ),
              #(
                "https://img.daisyui.com/images/stock/daisyui-hat-1.webp",
                "Hat 1",
              ),
            ])
            |> hover_gallery.build,
          hover_gallery.new()
            |> hover_gallery.attrs([attribute.class("w-40")])
            |> hover_gallery.images([
              #(
                "https://img.daisyui.com/images/stock/daisyui-hat-2.webp",
                "Hat 2",
              ),
              #(
                "https://img.daisyui.com/images/stock/daisyui-hat-3.webp",
                "Hat 3",
              ),
              #(
                "https://img.daisyui.com/images/stock/daisyui-hat-4.webp",
                "Hat 4",
              ),
              #(
                "https://img.daisyui.com/images/stock/daisyui-hat-1.webp",
                "Hat 1",
              ),
            ])
            |> hover_gallery.build,
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
