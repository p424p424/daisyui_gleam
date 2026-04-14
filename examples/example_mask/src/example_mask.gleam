import daisyui/mask
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Mask")]),
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

const photo = "https://img.daisyui.com/images/stock/photo-1567653418876-5bb0e566e1c2.webp"

fn img_attrs() -> List(attribute.Attribute(msg)) {
  [attribute.src(photo), attribute.alt("Mask demo"), attribute.class("w-24")]
}

fn masked(shape: mask.MaskShape) -> Element(msg) {
  mask.new(shape) |> mask.attrs(img_attrs()) |> mask.build
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("All shapes", [
        html.div(
          [attribute.class("flex flex-wrap gap-4 justify-center items-center")],
          [
            labeled("squircle", masked(mask.Squircle)),
            labeled("heart", masked(mask.Heart)),
            labeled("hexagon", masked(mask.Hexagon)),
            labeled("hexagon-2", masked(mask.Hexagon2)),
            labeled("decagon", masked(mask.Decagon)),
            labeled("pentagon", masked(mask.Pentagon)),
            labeled("diamond", masked(mask.Diamond)),
            labeled("square", masked(mask.Square)),
            labeled("circle", masked(mask.Circle)),
            labeled("star", masked(mask.Star)),
            labeled("star-2", masked(mask.Star2)),
            labeled("triangle", masked(mask.Triangle)),
            labeled("triangle-2", masked(mask.Triangle2)),
            labeled("triangle-3", masked(mask.Triangle3)),
            labeled("triangle-4", masked(mask.Triangle4)),
          ],
        ),
      ]),
      section("Half modifiers (split heart)", [
        html.div([attribute.class("flex items-center gap-2")], [
          mask.new(mask.Heart)
            |> mask.half_1
            |> mask.attrs([
              attribute.src(photo),
              attribute.alt("Heart half 1"),
              attribute.class("w-24 bg-primary"),
            ])
            |> mask.build,
          mask.new(mask.Heart)
            |> mask.half_2
            |> mask.attrs([
              attribute.src(photo),
              attribute.alt("Heart half 2"),
              attribute.class("w-24"),
            ])
            |> mask.build,
        ]),
      ]),
    ],
  )
}

fn labeled(label: String, el: Element(Msg)) -> Element(Msg) {
  html.div([attribute.class("flex flex-col items-center gap-1")], [
    el,
    html.span([attribute.class("text-xs opacity-60")], [html.text(label)]),
  ])
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
