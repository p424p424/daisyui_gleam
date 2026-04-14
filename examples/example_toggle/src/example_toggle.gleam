import daisyui/select
import daisyui/toggle
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Toggle")]),
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

fn row(children: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("flex flex-wrap items-center gap-4")], children)
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Basic", [
        toggle.new() |> toggle.checked |> toggle.build,
      ]),
      section("With fieldset label", [
        html.fieldset(
          [
            attribute.class(
              "fieldset p-4 bg-base-100 border border-base-300 rounded-box w-64",
            ),
          ],
          [
            html.legend([attribute.class("fieldset-legend")], [
              html.text("Login options"),
            ]),
            html.label([attribute.class("label")], [
              toggle.new() |> toggle.checked |> toggle.build,
              html.text("Remember me"),
            ]),
          ],
        ),
      ]),
      section("Sizes", [
        row([
          toggle.new() |> toggle.xs |> toggle.checked |> toggle.build,
          toggle.new() |> toggle.sm |> toggle.checked |> toggle.build,
          toggle.new() |> toggle.md |> toggle.checked |> toggle.build,
          toggle.new() |> toggle.lg |> toggle.checked |> toggle.build,
          toggle.new() |> toggle.xl |> toggle.checked |> toggle.build,
        ]),
      ]),
      section("Colors", [
        row([
          toggle.new() |> toggle.primary |> toggle.checked |> toggle.build,
          toggle.new() |> toggle.secondary |> toggle.checked |> toggle.build,
          toggle.new() |> toggle.accent |> toggle.checked |> toggle.build,
          toggle.new() |> toggle.neutral |> toggle.checked |> toggle.build,
          toggle.new() |> toggle.info |> toggle.checked |> toggle.build,
          toggle.new() |> toggle.success |> toggle.checked |> toggle.build,
          toggle.new() |> toggle.warning |> toggle.checked |> toggle.build,
          toggle.new() |> toggle.error |> toggle.checked |> toggle.build,
        ]),
      ]),
      section("Disabled", [
        row([
          toggle.new() |> toggle.disabled |> toggle.build,
          toggle.new() |> toggle.disabled |> toggle.checked |> toggle.build,
        ]),
      ]),
      section("With icons inside (label-based)", [
        html.label([attribute.class("toggle text-base-content")], [
          html.input([attribute.type_("checkbox")]),
          // checkmark — shown when checked
          svg.svg(
            [
              attribute.attribute("aria-label", "enabled"),
              attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
              attribute.attribute("viewBox", "0 0 24 24"),
            ],
            [
              svg.g(
                [
                  attribute.attribute("stroke-linejoin", "round"),
                  attribute.attribute("stroke-linecap", "round"),
                  attribute.attribute("stroke-width", "4"),
                  attribute.attribute("fill", "none"),
                  attribute.attribute("stroke", "currentColor"),
                ],
                [
                  svg.path([attribute.attribute("d", "M20 6 9 17l-5-5")]),
                ],
              ),
            ],
          ),
          // x — shown when unchecked
          svg.svg(
            [
              attribute.attribute("aria-label", "disabled"),
              attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
              attribute.attribute("viewBox", "0 0 24 24"),
              attribute.attribute("fill", "none"),
              attribute.attribute("stroke", "currentColor"),
              attribute.attribute("stroke-width", "4"),
              attribute.attribute("stroke-linecap", "round"),
              attribute.attribute("stroke-linejoin", "round"),
            ],
            [
              svg.path([attribute.attribute("d", "M18 6 6 18")]),
              svg.path([attribute.attribute("d", "m6 6 12 12")]),
            ],
          ),
        ]),
      ]),
      section("Custom colors", [
        toggle.new()
          |> toggle.checked
          |> toggle.attrs([
            attribute.class(
              "border-indigo-600 bg-indigo-500 checked:bg-orange-400 checked:text-orange-800 checked:border-orange-500",
            ),
          ])
          |> toggle.build,
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
