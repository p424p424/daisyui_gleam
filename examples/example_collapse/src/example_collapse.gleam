import daisyui/collapse
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
        html.text("Collapse"),
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
    [attribute.class("pt-16 flex items-center justify-center min-h-screen")],
    [
      html.div([attribute.class("w-full max-w-xl space-y-4 p-4")], [
        // Focus-based (default)
        html.p([attribute.class("text-sm font-semibold opacity-60 uppercase tracking-wide")], [
          html.text("Focus (click away to close)"),
        ]),
        collapse.new()
          |> collapse.attrs([attribute.class("bg-base-100 border border-base-300")])
          |> collapse.title(
            attrs: [attribute.class("font-semibold")],
            children: [html.text("How do I create an account?")],
          )
          |> collapse.content(
            attrs: [attribute.class("text-sm")],
            children: [
              html.text(
                "Click the \"Sign Up\" button in the top right corner and follow the registration process.",
              ),
            ],
          )
          |> collapse.build,
        collapse.new()
          |> collapse.arrow
          |> collapse.attrs([attribute.class("bg-base-100 border border-base-300")])
          |> collapse.title(
            attrs: [attribute.class("font-semibold")],
            children: [html.text("With arrow icon")],
          )
          |> collapse.content(
            attrs: [attribute.class("text-sm")],
            children: [html.text("The arrow rotates when the panel opens.")],
          )
          |> collapse.build,
        collapse.new()
          |> collapse.plus
          |> collapse.attrs([attribute.class("bg-base-100 border border-base-300")])
          |> collapse.title(
            attrs: [attribute.class("font-semibold")],
            children: [html.text("With plus/minus icon")],
          )
          |> collapse.content(
            attrs: [attribute.class("text-sm")],
            children: [html.text("The icon toggles between + and − as the panel opens.")],
          )
          |> collapse.build,
        // Checkbox-based
        html.p([attribute.class("text-sm font-semibold opacity-60 uppercase tracking-wide pt-2")], [
          html.text("Checkbox (state persists on blur)"),
        ]),
        collapse.new()
          |> collapse.checkbox
          |> collapse.arrow
          |> collapse.attrs([attribute.class("bg-base-100 border border-base-300")])
          |> collapse.title(
            attrs: [attribute.class("font-semibold")],
            children: [html.text("Click to toggle")],
          )
          |> collapse.content(
            attrs: [attribute.class("text-sm")],
            children: [html.text("Unlike focus, this stays open when you click elsewhere.")],
          )
          |> collapse.build,
        // Details-based
        html.p([attribute.class("text-sm font-semibold opacity-60 uppercase tracking-wide pt-2")], [
          html.text("Details / Summary (browser-searcheable)"),
        ]),
        collapse.new()
          |> collapse.details(open: False)
          |> collapse.arrow
          |> collapse.attrs([attribute.class("bg-base-100 border border-base-300")])
          |> collapse.title(
            attrs: [attribute.class("font-semibold")],
            children: [html.text("Show source (starts closed)")],
          )
          |> collapse.content(
            attrs: [attribute.class("text-sm font-mono")],
            children: [html.text("collapse.new() |> collapse.details(open: False) |> collapse.build")],
          )
          |> collapse.build,
        collapse.new()
          |> collapse.details(open: True)
          |> collapse.plus
          |> collapse.attrs([attribute.class("bg-base-100 border border-base-300")])
          |> collapse.title(
            attrs: [attribute.class("font-semibold")],
            children: [html.text("Open by default")],
          )
          |> collapse.content(
            attrs: [attribute.class("text-sm")],
            children: [html.text("This panel is expanded on first paint because open: True was set.")],
          )
          |> collapse.build,
        // Force open / close
        html.p([attribute.class("text-sm font-semibold opacity-60 uppercase tracking-wide pt-2")], [
          html.text("Forced state"),
        ]),
        collapse.new()
          |> collapse.force_open
          |> collapse.arrow
          |> collapse.attrs([attribute.class("bg-base-100 border border-base-300")])
          |> collapse.title(
            attrs: [attribute.class("font-semibold")],
            children: [html.text("Always open (collapse-open)")],
          )
          |> collapse.content(
            attrs: [attribute.class("text-sm")],
            children: [html.text("User interaction cannot close this panel.")],
          )
          |> collapse.build,
        collapse.new()
          |> collapse.force_close
          |> collapse.arrow
          |> collapse.attrs([attribute.class("bg-base-100 border border-base-300")])
          |> collapse.title(
            attrs: [attribute.class("font-semibold")],
            children: [html.text("Always closed (collapse-close)")],
          )
          |> collapse.content(
            attrs: [attribute.class("text-sm")],
            children: [html.text("This content is permanently hidden.")],
          )
          |> collapse.build,
      ]),
    ],
  )
}
