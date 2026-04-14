import daisyui/label
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
        html.text("Label"),
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
      // Label prefix in input
      section("Label prefix (https://)", [
        html.label([attribute.class("input")], [
          label.label("https://"),
          html.input([
            attribute.type_("text"),
            attribute.placeholder("URL"),
          ]),
        ]),
      ]),
      // Label suffix in input
      section("Label suffix (.com)", [
        html.label([attribute.class("input")], [
          html.input([
            attribute.type_("text"),
            attribute.placeholder("domain name"),
          ]),
          label.label(".com"),
        ]),
      ]),
      // Label in select
      section("Label for select", [
        html.label([attribute.class("select")], [
          label.label("Type"),
          html.select([], [
            html.option([], "Personal"),
            html.option([], "Business"),
          ]),
        ]),
      ]),
      // Label for date input
      section("Label for date input", [
        html.label([attribute.class("input")], [
          label.label("Publish date"),
          html.input([attribute.type_("date")]),
        ]),
      ]),
      // Floating label
      section("Floating label", [
        label.floating_new()
          |> label.floating_children([
            html.input([
              attribute.type_("text"),
              attribute.class("input input-md"),
              attribute.placeholder("mail@site.com"),
            ]),
            html.span([], [html.text("Your Email")]),
          ])
          |> label.floating_build,
      ]),
      // Floating label sizes
      section("Floating label sizes", [
        html.div([attribute.class("flex flex-col gap-4")], [
          label.floating_new()
            |> label.floating_children([
              html.input([
                attribute.type_("text"),
                attribute.class("input input-xs"),
                attribute.placeholder("Extra Small"),
              ]),
              html.span([], [html.text("Extra Small")]),
            ])
            |> label.floating_build,
          label.floating_new()
            |> label.floating_children([
              html.input([
                attribute.type_("text"),
                attribute.class("input input-sm"),
                attribute.placeholder("Small"),
              ]),
              html.span([], [html.text("Small")]),
            ])
            |> label.floating_build,
          label.floating_new()
            |> label.floating_children([
              html.input([
                attribute.type_("text"),
                attribute.class("input input-md"),
                attribute.placeholder("Medium"),
              ]),
              html.span([], [html.text("Medium")]),
            ])
            |> label.floating_build,
          label.floating_new()
            |> label.floating_children([
              html.input([
                attribute.type_("text"),
                attribute.class("input input-lg"),
                attribute.placeholder("Large"),
              ]),
              html.span([], [html.text("Large")]),
            ])
            |> label.floating_build,
          label.floating_new()
            |> label.floating_children([
              html.input([
                attribute.type_("text"),
                attribute.class("input input-xl"),
                attribute.placeholder("Extra Large"),
              ]),
              html.span([], [html.text("Extra Large")]),
            ])
            |> label.floating_build,
        ]),
      ]),
    ],
  )
}

fn section(label_text: String, children: List(Element(Msg))) -> Element(Msg) {
  html.div([attribute.class("w-full max-w-xl space-y-3 px-4")], [
    html.p(
      [
        attribute.class(
          "text-sm font-semibold opacity-60 uppercase tracking-wide",
        ),
      ],
      [html.text(label_text)],
    ),
    ..children
  ])
}
