import daisyui/select
import daisyui/steps
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Steps")]),
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

fn checkout_steps() -> List(Element(msg)) {
  [
    steps.step("Register") |> steps.step_primary |> steps.step_build,
    steps.step("Choose plan") |> steps.step_primary |> steps.step_build,
    steps.step("Purchase") |> steps.step_build,
    steps.step("Receive Product") |> steps.step_build,
  ]
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Horizontal (default)", [
        steps.new()
        |> steps.items(checkout_steps())
        |> steps.build,
      ]),
      section("Vertical", [
        steps.new()
        |> steps.vertical
        |> steps.items(checkout_steps())
        |> steps.build,
      ]),
      section("Responsive (vertical → horizontal at lg)", [
        steps.new()
        |> steps.vertical
        |> steps.attrs([attribute.class("lg:steps-horizontal")])
        |> steps.items(checkout_steps())
        |> steps.build,
      ]),
      section("With step-icon", [
        steps.new()
        |> steps.items([
          steps.step("Step 1") |> steps.step_neutral |> steps.step_icon("😕") |> steps.step_build,
          steps.step("Step 2") |> steps.step_neutral |> steps.step_icon("😃") |> steps.step_build,
          steps.step("Step 3") |> steps.step_icon("😍") |> steps.step_build,
        ])
        |> steps.build,
      ]),
      section("With data-content", [
        steps.new()
        |> steps.items([
          steps.step("Step 1") |> steps.step_neutral |> steps.step_data_content("?") |> steps.step_build,
          steps.step("Step 2") |> steps.step_neutral |> steps.step_data_content("!") |> steps.step_build,
          steps.step("Step 3") |> steps.step_neutral |> steps.step_data_content("✓") |> steps.step_build,
          steps.step("Step 4") |> steps.step_neutral |> steps.step_data_content("✕") |> steps.step_build,
          steps.step("Step 5") |> steps.step_neutral |> steps.step_data_content("★") |> steps.step_build,
          steps.step("Step 6") |> steps.step_neutral |> steps.step_data_content("●") |> steps.step_build,
        ])
        |> steps.build,
      ]),
      section("Custom colors", [
        steps.new()
        |> steps.items([
          steps.step("Fly to moon")    |> steps.step_info  |> steps.step_build,
          steps.step("Shrink the moon") |> steps.step_info  |> steps.step_build,
          steps.step("Grab the moon")  |> steps.step_info  |> steps.step_build,
          steps.step("Sit on toilet")  |> steps.step_error |> steps.step_data_content("?") |> steps.step_build,
        ])
        |> steps.build,
      ]),
      section("Scrollable", [
        html.div([attribute.class("overflow-x-auto w-full")], [
          steps.new()
          |> steps.items([
            steps.step("start") |> steps.step_build,
            steps.step("2") |> steps.step_secondary |> steps.step_build,
            steps.step("3") |> steps.step_secondary |> steps.step_build,
            steps.step("4") |> steps.step_secondary |> steps.step_build,
            steps.step("5") |> steps.step_build,
            steps.step("6") |> steps.step_accent |> steps.step_build,
            steps.step("7") |> steps.step_accent |> steps.step_build,
            steps.step("8") |> steps.step_build,
            steps.step("9") |> steps.step_error |> steps.step_build,
            steps.step("10") |> steps.step_error |> steps.step_build,
            steps.step("11") |> steps.step_build,
            steps.step("12") |> steps.step_build,
            steps.step("13") |> steps.step_warning |> steps.step_build,
            steps.step("14") |> steps.step_warning |> steps.step_build,
            steps.step("15") |> steps.step_build,
            steps.step("16") |> steps.step_neutral |> steps.step_build,
            steps.step("end") |> steps.step_neutral |> steps.step_build,
          ])
          |> steps.build,
        ]),
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
