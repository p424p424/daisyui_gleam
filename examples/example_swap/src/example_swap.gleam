import daisyui/select
import daisyui/swap
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Swap")]),
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
// Icons
// ---------------------------------------------------------------------------

fn volume_on() -> Element(msg) {
  svg.svg(
    [
      attribute.class("swap-on fill-current"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("width", "48"),
      attribute.attribute("height", "48"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.path([
        attribute.attribute(
          "d",
          "M14,3.23V5.29C16.89,6.15 19,8.83 19,12C19,15.17 16.89,17.84 14,18.7V20.77C18,19.86 21,16.28 21,12C21,7.72 18,4.14 14,3.23M16.5,12C16.5,10.23 15.5,8.71 14,7.97V16C15.5,15.29 16.5,13.76 16.5,12M3,9V15H7L12,20V4L7,9H3Z",
        ),
      ]),
    ],
  )
}

fn volume_off() -> Element(msg) {
  svg.svg(
    [
      attribute.class("swap-off fill-current"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("width", "48"),
      attribute.attribute("height", "48"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.path([
        attribute.attribute(
          "d",
          "M3,9H7L12,4V20L7,15H3V9M16.59,12L14,9.41L15.41,8L18,10.59L20.59,8L22,9.41L19.41,12L22,14.59L20.59,16L18,13.41L15.41,16L14,14.59L16.59,12Z",
        ),
      ]),
    ],
  )
}

fn sun_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.class("swap-on h-10 w-10 fill-current"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.path([
        attribute.attribute(
          "d",
          "M5.64,17l-.71.71a1,1,0,0,0,0,1.41,1,1,0,0,0,1.41,0l.71-.71A1,1,0,0,0,5.64,17ZM5,12a1,1,0,0,0-1-1H3a1,1,0,0,0,0,2H4A1,1,0,0,0,5,12Zm7-7a1,1,0,0,0,1-1V3a1,1,0,0,0-2,0V4A1,1,0,0,0,12,5ZM5.64,7.05a1,1,0,0,0,.7.29,1,1,0,0,0,.71-.29,1,1,0,0,0,0-1.41l-.71-.71A1,1,0,0,0,4.93,6.34Zm12,.29a1,1,0,0,0,.7-.29l.71-.71a1,1,0,1,0-1.41-1.41L17,5.64a1,1,0,0,0,0,1.41A1,1,0,0,0,17.66,7.34ZM21,11H20a1,1,0,0,0,0,2h1a1,1,0,0,0,0-2Zm-9,8a1,1,0,0,0-1,1v1a1,1,0,0,0,2,0V20A1,1,0,0,0,12,19ZM18.36,17A1,1,0,0,0,17,18.36l.71.71a1,1,0,0,0,1.41,0,1,1,0,0,0,0-1.41ZM12,6.5A5.5,5.5,0,1,0,17.5,12,5.51,5.51,0,0,0,12,6.5Zm0,9A3.5,3.5,0,1,1,15.5,12,3.5,3.5,0,0,1,12,15.5Z",
        ),
      ]),
    ],
  )
}

fn moon_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.class("swap-off h-10 w-10 fill-current"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.path([
        attribute.attribute(
          "d",
          "M21.64,13a1,1,0,0,0-1.05-.14,8.05,8.05,0,0,1-3.37.73A8.15,8.15,0,0,1,9.08,5.49a8.59,8.59,0,0,1,.25-2A1,1,0,0,0,8,2.36,10.14,10.14,0,1,0,22,14.05,1,1,0,0,0,21.64,13Zm-9.5,6.69A8.14,8.14,0,0,1,7.08,5.22v.27A10.15,10.15,0,0,0,17.22,15.63a9.79,9.79,0,0,0,2.1-.22A8.11,8.11,0,0,1,12.14,19.73Z",
        ),
      ]),
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
      section("Swap text", [
        swap.new()
        |> swap.on(swap.on_div([html.text("ON")]))
        |> swap.off(swap.off_div([html.text("OFF")]))
        |> swap.build,
      ]),
      section("Volume icons", [
        swap.new()
        |> swap.on(volume_on())
        |> swap.off(volume_off())
        |> swap.build,
      ]),
      section("Rotate effect (sun/moon)", [
        swap.new()
        |> swap.rotate
        |> swap.on(sun_icon())
        |> swap.off(moon_icon())
        |> swap.build,
      ]),
      section("Hamburger button (rotate)", [
        swap.new()
        |> swap.rotate
        |> swap.attrs([attribute.class("btn btn-circle")])
        |> swap.on(
          svg.svg(
            [
              attribute.class("swap-on fill-current"),
              attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
              attribute.attribute("width", "32"),
              attribute.attribute("height", "32"),
              attribute.attribute("viewBox", "0 0 512 512"),
            ],
            [
              svg.path([
                attribute.attribute(
                  "d",
                  "M64,384H448V341.33H64Zm0-106.67H448V234.67H64ZM64,128v42.67H448V128Z",
                ),
              ]),
            ],
          ),
        )
        |> swap.off(
          svg.svg(
            [
              attribute.class("swap-off fill-current"),
              attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
              attribute.attribute("width", "32"),
              attribute.attribute("height", "32"),
              attribute.attribute("viewBox", "0 0 512 512"),
            ],
            [
              svg.path([
                attribute.attribute(
                  "d",
                  "M64,384H448V341.33H64Zm0-106.67H448V234.67H64ZM64,128v42.67H448V128Z",
                ),
              ]),
            ],
          ),
        )
        |> swap.build,
      ]),
      section("Flip effect", [
        swap.new()
        |> swap.flip
        |> swap.attrs([attribute.class("text-9xl")])
        |> swap.on(swap.on_div([html.text("😈")]))
        |> swap.off(swap.off_div([html.text("😇")]))
        |> swap.build,
      ]),
      section("Class-controlled (swap-active)", [
        html.div([attribute.class("flex gap-4")], [
          swap.new()
          |> swap.attrs([attribute.class("text-6xl")])
          |> swap.on(swap.on_div([html.text("🥵")]))
          |> swap.off(swap.off_div([html.text("🥶")]))
          |> swap.active
          |> swap.build,
          swap.new()
          |> swap.attrs([attribute.class("text-6xl")])
          |> swap.on(swap.on_div([html.text("🥳")]))
          |> swap.off(swap.off_div([html.text("😭")]))
          |> swap.build,
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
