import daisyui/rating
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
        html.text("Rating"),
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
      section("Basic (mask-star)", [
        rating.new()
        |> rating.stars("rating-1", 5, 2, "mask-star", "")
        |> rating.build,
      ]),
      section("Read-only", [
        rating.new()
        |> rating.items("rating-ro", [
          rating.item_div("mask-star"),
          rating.item_div("mask-star"),
          rating.item_div("mask-star")
            |> rating.item_attrs([attribute.attribute("aria-current", "true")]),
          rating.item_div("mask-star"),
          rating.item_div("mask-star"),
        ])
        |> rating.build,
      ]),
      section("mask-star-2 orange", [
        rating.new()
        |> rating.stars("rating-2", 5, 2, "mask-star-2", "bg-orange-400")
        |> rating.build,
      ]),
      section("mask-heart multi-color", [
        rating.new()
        |> rating.gap
        |> rating.items("rating-3", [
          rating.item("mask-heart") |> rating.item_class("bg-red-400"),
          rating.item("mask-heart")
            |> rating.item_class("bg-orange-400")
            |> rating.item_checked,
          rating.item("mask-heart") |> rating.item_class("bg-yellow-400"),
          rating.item("mask-heart") |> rating.item_class("bg-lime-400"),
          rating.item("mask-heart") |> rating.item_class("bg-green-400"),
        ])
        |> rating.build,
      ]),
      section("mask-star-2 green", [
        rating.new()
        |> rating.stars("rating-4", 5, 2, "mask-star-2", "bg-green-500")
        |> rating.build,
      ]),
      section("Sizes", [
        html.div([attribute.class("flex flex-col gap-2")], [
          rating.new() |> rating.xs |> rating.stars("rating-xs", 5, 2, "mask-star-2", "bg-orange-400") |> rating.build,
          rating.new() |> rating.sm |> rating.stars("rating-sm", 5, 2, "mask-star-2", "bg-orange-400") |> rating.build,
          rating.new() |> rating.md |> rating.stars("rating-md", 5, 2, "mask-star-2", "bg-orange-400") |> rating.build,
          rating.new() |> rating.lg |> rating.stars("rating-lg", 5, 2, "mask-star-2", "bg-orange-400") |> rating.build,
          rating.new() |> rating.xl |> rating.stars("rating-xl", 5, 2, "mask-star-2", "bg-orange-400") |> rating.build,
        ]),
      ]),
      section("With clear (rating-hidden)", [
        rating.new()
        |> rating.lg
        |> rating.allow_clear
        |> rating.stars("rating-10", 5, 2, "mask-star-2", "")
        |> rating.build_named("rating-10"),
      ]),
      section("Half stars", [
        rating.new()
        |> rating.lg
        |> rating.half
        |> rating.allow_clear
        |> rating.half_stars("rating-11", 5, 3, "mask-star-2", "bg-green-500")
        |> rating.build_named("rating-11"),
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
