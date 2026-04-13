import daisyui/dropdown
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
      html.h1([attribute.class("text-lg font-semibold")], [
        html.text("Dropdown"),
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
    [attribute.class("pt-20 pb-10 flex justify-center min-h-screen")],
    [
      html.div([attribute.class("w-full max-w-3xl space-y-10 p-4")], [
        // Basic
        section("Basic (CSS focus)", [
          make_dropdown(dropdown.new(), "Click"),
        ]),
        // Hover
        section("Hover", [
          make_dropdown(dropdown.new() |> dropdown.hover, "Hover"),
        ]),
        // Directions
        section("Directions", [
          html.div(
            [attribute.class("flex flex-wrap gap-2 items-center justify-center p-16")],
            [
              make_dropdown(dropdown.new() |> dropdown.top |> dropdown.align_center, "Top ⬆️"),
              make_dropdown(dropdown.new() |> dropdown.bottom, "Bottom ⬇️"),
              make_dropdown(dropdown.new() |> dropdown.left |> dropdown.align_center, "Left ⬅️"),
              make_dropdown(dropdown.new() |> dropdown.right |> dropdown.align_center, "Right ➡️"),
            ],
          ),
        ]),
        // Alignment
        section("Alignment (bottom direction)", [
          html.div([attribute.class("flex flex-wrap gap-2")], [
            make_dropdown(dropdown.new() |> dropdown.align_start, "Start ⬇️"),
            make_dropdown(dropdown.new() |> dropdown.align_center, "Center ⬇️"),
            make_dropdown(dropdown.new() |> dropdown.align_end, "End ⬇️"),
          ]),
        ]),
        // Forced state
        section("Forced state", [
          html.div([attribute.class("flex gap-2")], [
            make_dropdown(dropdown.new() |> dropdown.force_open, "Force open"),
            make_dropdown(dropdown.new() |> dropdown.force_close, "Force close"),
          ]),
        ]),
        // Card content
        section("Card as dropdown content", [
          dropdown.new()
            |> dropdown.trigger([btn_trigger("Click")])
            |> dropdown.content([
              html.div(
                [
                  attribute.attribute("tabindex", "0"),
                  attribute.class(
                    "dropdown-content card card-sm bg-base-100 z-1 w-64 shadow-md",
                  ),
                ],
                [
                  html.div([attribute.class("card-body")], [
                    html.h2([attribute.class("card-title")], [
                      html.text("Card dropdown"),
                    ]),
                    html.p([], [
                      html.text(
                        "Any element can be used as dropdown content — not just menus.",
                      ),
                    ]),
                  ]),
                ],
              ),
            ])
            |> dropdown.build,
        ]),
      ]),
    ],
  )
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

fn btn_trigger(label: String) -> Element(Msg) {
  html.div(
    [
      attribute.attribute("tabindex", "0"),
      attribute.attribute("role", "button"),
      attribute.class("btn m-1"),
    ],
    [html.text(label)],
  )
}

fn menu_content() -> Element(Msg) {
  html.ul(
    [
      attribute.attribute("tabindex", "-1"),
      attribute.class(
        "dropdown-content menu bg-base-100 rounded-box z-1 w-52 p-2 shadow-sm",
      ),
    ],
    [
      html.li([], [html.a([], [html.text("Item 1")])]),
      html.li([], [html.a([], [html.text("Item 2")])]),
      html.li([], [html.a([], [html.text("Item 3")])]),
    ],
  )
}

fn make_dropdown(d: dropdown.Dropdown(Msg), label: String) -> Element(Msg) {
  d
  |> dropdown.trigger([btn_trigger(label)])
  |> dropdown.content([menu_content()])
  |> dropdown.build
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
