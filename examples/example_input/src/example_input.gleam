import daisyui/input
import daisyui/select
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
      html.h1([attribute.class("text-lg font-semibold")], [
        html.text("Text Input"),
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

// ---------------------------------------------------------------------------
// SVG icons
// ---------------------------------------------------------------------------

fn search_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.class("h-[1em] opacity-50"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.g(
        [
          attribute.attribute("stroke-linejoin", "round"),
          attribute.attribute("stroke-linecap", "round"),
          attribute.attribute("stroke-width", "2.5"),
          attribute.attribute("fill", "none"),
          attribute.attribute("stroke", "currentColor"),
        ],
        [
          svg.circle([
            attribute.attribute("cx", "11"),
            attribute.attribute("cy", "11"),
            attribute.attribute("r", "8"),
          ]),
          svg.path([attribute.attribute("d", "m21 21-4.3-4.3")]),
        ],
      ),
    ],
  )
}

fn user_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.class("h-[1em] opacity-50"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.g(
        [
          attribute.attribute("stroke-linejoin", "round"),
          attribute.attribute("stroke-linecap", "round"),
          attribute.attribute("stroke-width", "2.5"),
          attribute.attribute("fill", "none"),
          attribute.attribute("stroke", "currentColor"),
        ],
        [
          svg.path([
            attribute.attribute("d", "M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"),
          ]),
          svg.circle([
            attribute.attribute("cx", "12"),
            attribute.attribute("cy", "7"),
            attribute.attribute("r", "4"),
          ]),
        ],
      ),
    ],
  )
}

fn email_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.class("h-[1em] opacity-50"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.g(
        [
          attribute.attribute("stroke-linejoin", "round"),
          attribute.attribute("stroke-linecap", "round"),
          attribute.attribute("stroke-width", "2.5"),
          attribute.attribute("fill", "none"),
          attribute.attribute("stroke", "currentColor"),
        ],
        [
          svg.rect([
            attribute.attribute("width", "20"),
            attribute.attribute("height", "16"),
            attribute.attribute("x", "2"),
            attribute.attribute("y", "4"),
            attribute.attribute("rx", "2"),
          ]),
          svg.path([
            attribute.attribute(
              "d",
              "m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7",
            ),
          ]),
        ],
      ),
    ],
  )
}

fn password_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.class("h-[1em] opacity-50"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.g(
        [
          attribute.attribute("stroke-linejoin", "round"),
          attribute.attribute("stroke-linecap", "round"),
          attribute.attribute("stroke-width", "2.5"),
          attribute.attribute("fill", "none"),
          attribute.attribute("stroke", "currentColor"),
        ],
        [
          svg.path([
            attribute.attribute(
              "d",
              "M2.586 17.414A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814a6.5 6.5 0 1 0-4-4z",
            ),
          ]),
          svg.circle([
            attribute.attribute("cx", "16.5"),
            attribute.attribute("cy", "7.5"),
            attribute.attribute("r", ".5"),
            attribute.attribute("fill", "currentColor"),
          ]),
        ],
      ),
    ],
  )
}

// ---------------------------------------------------------------------------
// Main content
// ---------------------------------------------------------------------------

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      // Basic
      section("Basic", [
        input.new()
          |> input.attrs([attribute.placeholder("Type here")])
          |> input.build,
      ]),
      // Ghost
      section("Ghost style", [
        input.new()
          |> input.ghost
          |> input.attrs([attribute.placeholder("Type here")])
          |> input.build,
      ]),
      // Label wrapper with icon and kbd
      section("Label wrapper — search with keyboard hint", [
        input.label()
          |> input.children([
            search_icon(),
            html.input([
              attribute.type_("search"),
              attribute.class("grow"),
              attribute.placeholder("Search"),
            ]),
            html.kbd([attribute.class("kbd kbd-sm")], [html.text("⌘")]),
            html.kbd([attribute.class("kbd kbd-sm")], [html.text("K")]),
          ])
          |> input.build,
      ]),
      // Label wrapper with text prefix and badge suffix
      section("Label wrapper — text prefix and badge suffix", [
        input.label()
          |> input.children([
            html.text("Path"),
            html.input([
              attribute.type_("text"),
              attribute.class("grow"),
              attribute.placeholder("src/app/"),
            ]),
            html.span([attribute.class("badge badge-neutral badge-xs")], [
              html.text("Optional"),
            ]),
          ])
          |> input.build,
      ]),
      // Colors
      section("Colors", [
        html.div([attribute.class("flex flex-col gap-2")], [
          input.new()
            |> input.neutral
            |> input.attrs([attribute.placeholder("neutral")])
            |> input.build,
          input.new()
            |> input.primary
            |> input.attrs([attribute.placeholder("Primary")])
            |> input.build,
          input.new()
            |> input.secondary
            |> input.attrs([attribute.placeholder("Secondary")])
            |> input.build,
          input.new()
            |> input.accent
            |> input.attrs([attribute.placeholder("Accent")])
            |> input.build,
          input.new()
            |> input.info
            |> input.attrs([attribute.placeholder("Info")])
            |> input.build,
          input.new()
            |> input.success
            |> input.attrs([attribute.placeholder("Success")])
            |> input.build,
          input.new()
            |> input.warning
            |> input.attrs([attribute.placeholder("Warning")])
            |> input.build,
          input.new()
            |> input.error
            |> input.attrs([attribute.placeholder("Error")])
            |> input.build,
        ]),
      ]),
      // Sizes
      section("Sizes", [
        html.div([attribute.class("flex flex-col gap-2")], [
          input.new()
            |> input.xs
            |> input.attrs([attribute.placeholder("Xsmall")])
            |> input.build,
          input.new()
            |> input.sm
            |> input.attrs([attribute.placeholder("Small")])
            |> input.build,
          input.new()
            |> input.md
            |> input.attrs([attribute.placeholder("Medium")])
            |> input.build,
          input.new()
            |> input.lg
            |> input.attrs([attribute.placeholder("Large")])
            |> input.build,
          input.new()
            |> input.xl
            |> input.attrs([attribute.placeholder("Xlarge")])
            |> input.build,
        ]),
      ]),
      // Disabled
      section("Disabled", [
        input.new()
          |> input.disabled
          |> input.attrs([attribute.placeholder("You can't touch this")])
          |> input.build,
      ]),
      // Input types
      section("Input types (date, time, datetime-local)", [
        html.div([attribute.class("flex flex-col gap-2")], [
          input.new() |> input.attrs([attribute.type_("date")]) |> input.build,
          input.new() |> input.attrs([attribute.type_("time")]) |> input.build,
          input.new()
            |> input.attrs([attribute.type_("datetime-local")])
            |> input.build,
        ]),
      ]),
      // With validator — username
      section("With validator — username", [
        html.div([attribute.class("flex flex-col gap-2")], [
          input.label()
            |> input.validator
            |> input.children([
              user_icon(),
              html.input([
                attribute.type_("text"),
                attribute.attribute("required", ""),
                attribute.placeholder("Username"),
                attribute.attribute("pattern", "[A-Za-z][A-Za-z0-9\\-]*"),
                attribute.attribute("minlength", "3"),
                attribute.attribute("maxlength", "30"),
              ]),
            ])
            |> input.build,
          html.p([attribute.class("validator-hint")], [
            html.text("Must be 3 to 30 characters containing only letters, numbers or dash"),
          ]),
        ]),
      ]),
      // With validator — email
      section("With validator — email", [
        html.div([attribute.class("flex flex-col gap-2")], [
          input.label()
            |> input.validator
            |> input.children([
              email_icon(),
              html.input([
                attribute.type_("email"),
                attribute.attribute("required", ""),
                attribute.placeholder("mail@site.com"),
              ]),
            ])
            |> input.build,
          html.div([attribute.class("validator-hint hidden")], [
            html.text("Enter valid email address"),
          ]),
        ]),
      ]),
      // With validator — password
      section("With validator — password", [
        html.div([attribute.class("flex flex-col gap-2")], [
          input.label()
            |> input.validator
            |> input.children([
              password_icon(),
              html.input([
                attribute.type_("password"),
                attribute.attribute("required", ""),
                attribute.placeholder("Password"),
                attribute.attribute("minlength", "8"),
                attribute.attribute(
                  "pattern",
                  "(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,}",
                ),
              ]),
            ])
            |> input.build,
          html.p([attribute.class("validator-hint hidden")], [
            html.text(
              "Must be more than 8 characters, including at least one number, one lowercase letter, and one uppercase letter",
            ),
          ]),
        ]),
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
