import daisyui/select
import daisyui/toast
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Toast")]),
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

fn alert(color: String, text: String) -> Element(msg) {
  html.div([attribute.class("alert " <> color)], [html.text(text)])
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-6")],
    [
      // Each toast is shown inside a relative container so it stays in flow
      section("Default (bottom-end)", [
        html.div([attribute.class("relative h-32 w-full")], [
          toast.new()
            |> toast.attrs([attribute.class("absolute")])
            |> toast.children([alert("alert-info", "New message arrived.")])
            |> toast.build,
        ]),
      ]),
      section("top-start", [
        html.div([attribute.class("relative h-32 w-full")], [
          toast.new()
            |> toast.top
            |> toast.start
            |> toast.attrs([attribute.class("absolute")])
            |> toast.children([
              alert("alert-info", "New mail arrived."),
              alert("alert-success", "Message sent successfully."),
            ])
            |> toast.build,
        ]),
      ]),
      section("top-center", [
        html.div([attribute.class("relative h-32 w-full")], [
          toast.new()
            |> toast.top
            |> toast.center
            |> toast.attrs([attribute.class("absolute")])
            |> toast.children([
              alert("alert-info", "New mail arrived."),
              alert("alert-success", "Message sent successfully."),
            ])
            |> toast.build,
        ]),
      ]),
      section("top-end", [
        html.div([attribute.class("relative h-32 w-full")], [
          toast.new()
            |> toast.top
            |> toast.end
            |> toast.attrs([attribute.class("absolute")])
            |> toast.children([
              alert("alert-info", "New mail arrived."),
              alert("alert-success", "Message sent successfully."),
            ])
            |> toast.build,
        ]),
      ]),
      section("middle-start", [
        html.div([attribute.class("relative h-32 w-full")], [
          toast.new()
            |> toast.middle
            |> toast.start
            |> toast.attrs([attribute.class("absolute")])
            |> toast.children([
              alert("alert-info", "New mail arrived."),
              alert("alert-success", "Message sent successfully."),
            ])
            |> toast.build,
        ]),
      ]),
      section("middle-center", [
        html.div([attribute.class("relative h-32 w-full")], [
          toast.new()
            |> toast.middle
            |> toast.center
            |> toast.attrs([attribute.class("absolute")])
            |> toast.children([
              alert("alert-info", "New mail arrived."),
              alert("alert-success", "Message sent successfully."),
            ])
            |> toast.build,
        ]),
      ]),
      section("middle-end", [
        html.div([attribute.class("relative h-32 w-full")], [
          toast.new()
            |> toast.middle
            |> toast.end
            |> toast.attrs([attribute.class("absolute")])
            |> toast.children([
              alert("alert-info", "New mail arrived."),
              alert("alert-success", "Message sent successfully."),
            ])
            |> toast.build,
        ]),
      ]),
      section("bottom-start", [
        html.div([attribute.class("relative h-32 w-full")], [
          toast.new()
            |> toast.bottom
            |> toast.start
            |> toast.attrs([attribute.class("absolute")])
            |> toast.children([
              alert("alert-info", "New mail arrived."),
              alert("alert-success", "Message sent successfully."),
            ])
            |> toast.build,
        ]),
      ]),
      section("bottom-center", [
        html.div([attribute.class("relative h-32 w-full")], [
          toast.new()
            |> toast.bottom
            |> toast.center
            |> toast.attrs([attribute.class("absolute")])
            |> toast.children([
              alert("alert-info", "New mail arrived."),
              alert("alert-success", "Message sent successfully."),
            ])
            |> toast.build,
        ]),
      ]),
      section("bottom-end (default)", [
        html.div([attribute.class("relative h-32 w-full")], [
          toast.new()
            |> toast.bottom
            |> toast.end
            |> toast.attrs([attribute.class("absolute")])
            |> toast.children([
              alert("alert-info", "New mail arrived."),
              alert("alert-success", "Message sent successfully."),
            ])
            |> toast.build,
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
