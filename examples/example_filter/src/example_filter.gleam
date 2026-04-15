import daisyui/filter
import daisyui/select
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub type Model {
  Model(theme: String, selected_framework: String, selected_size: String)
}

pub type Msg {
  UserChangedTheme(String)
  UserSelectedFramework(String)
  UserSelectedSize(String)
}

pub fn main() {
  let app =
    lustre.simple(
      fn(_) { Model(theme: "light", selected_framework: "", selected_size: "") },
      update,
      view,
    )
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedTheme(t) -> Model(..model, theme: t)
    UserSelectedFramework(f) -> Model(..model, selected_framework: f)
    UserSelectedSize(s) -> Model(..model, selected_size: s)
  }
}

fn view(model: Model) -> Element(Msg) {
  html.div(
    [
      attribute.attribute("data-theme", model.theme),
      attribute.class("min-h-screen bg-base-200"),
    ],
    [page_header(model.theme), main_content(model)],
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
        html.text("Filter"),
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

fn main_content(model: Model) -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex justify-center min-h-screen")],
    [
      html.div([attribute.class("w-full max-w-xl space-y-10 p-4")], [
        // Form variant
        section("Form variant (native reset button)", [
          filter.new("frameworks")
            |> filter.items([
              filter.item("Svelte", []),
              filter.item("Vue", []),
              filter.item("React", []),
              filter.item("Angular", []),
            ])
            |> filter.build,
        ]),
        // Div variant
        section("Div variant (filter-reset radio, label: \"All\")", [
          filter.new("metaframeworks")
            |> filter.div
            |> filter.reset_label("All")
            |> filter.items([
              filter.item("SvelteKit", []),
              filter.item("Nuxt", []),
              filter.item("Next.js", []),
              filter.item("Remix", []),
            ])
            |> filter.build,
        ]),
        // With Lustre events
        section("With Lustre events", [
          html.div([attribute.class("space-y-2")], [
            filter.new("sizes")
              |> filter.div
              |> filter.reset_label("All sizes")
              |> filter.items([
                filter.item("XS", [event.on_click(UserSelectedSize("XS"))]),
                filter.item("S", [event.on_click(UserSelectedSize("S"))]),
                filter.item("M", [event.on_click(UserSelectedSize("M"))]),
                filter.item("L", [event.on_click(UserSelectedSize("L"))]),
                filter.item("XL", [event.on_click(UserSelectedSize("XL"))]),
              ])
              |> filter.build,
            html.p([attribute.class("text-sm opacity-60")], [
              html.text(case model.selected_size {
                "" -> "No size selected"
                s -> "Selected: " <> s
              }),
            ]),
          ]),
        ]),
        // Custom reset label
        section("Custom reset label", [
          filter.new("colours")
            |> filter.div
            |> filter.reset_label("Any colour")
            |> filter.items([
              filter.item("Red", []),
              filter.item("Green", []),
              filter.item("Blue", []),
              filter.item("Yellow", []),
            ])
            |> filter.build,
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
