import daisyui/select
import daisyui/tabs
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Tabs")]),
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
      section("Border style", [
        tabs.new()
          |> tabs.border
          |> tabs.children([
            tabs.tab("Tab 1") |> tabs.tab_build,
            tabs.tab("Tab 2") |> tabs.tab_active |> tabs.tab_build,
            tabs.tab("Tab 3") |> tabs.tab_build,
          ])
          |> tabs.build,
      ]),
      section("Lift style", [
        tabs.new()
          |> tabs.lift
          |> tabs.children([
            tabs.tab("Tab 1") |> tabs.tab_build,
            tabs.tab("Tab 2") |> tabs.tab_active |> tabs.tab_build,
            tabs.tab("Tab 3") |> tabs.tab_build,
          ])
          |> tabs.build,
      ]),
      section("Box style", [
        tabs.new()
          |> tabs.box
          |> tabs.children([
            tabs.tab("Tab 1") |> tabs.tab_build,
            tabs.tab("Tab 2") |> tabs.tab_active |> tabs.tab_build,
            tabs.tab("Tab 3") |> tabs.tab_build,
          ])
          |> tabs.build,
      ]),
      section("Radio tabs with content (lift)", [
        tabs.new()
          |> tabs.lift
          |> tabs.children(
            tabs.radio_items("demo_tabs", [
              tabs.radio_item(
                "Tab 1",
                [html.p([attribute.class("py-4")], [html.text("Content for Tab 1")])],
                True,
              ),
              tabs.radio_item(
                "Tab 2",
                [html.p([attribute.class("py-4")], [html.text("Content for Tab 2")])],
                False,
              ),
              tabs.radio_item(
                "Tab 3",
                [html.p([attribute.class("py-4")], [html.text("Content for Tab 3")])],
                False,
              ),
            ]),
          )
          |> tabs.build,
      ]),
      section("Sizes (box)", [
        html.div(
          [attribute.class("flex flex-col gap-2")],
          [
            tabs.new()
              |> tabs.box
              |> tabs.xs
              |> tabs.children([
                tabs.tab("xs") |> tabs.tab_active |> tabs.tab_build,
                tabs.tab("Tab 2") |> tabs.tab_build,
              ])
              |> tabs.build,
            tabs.new()
              |> tabs.box
              |> tabs.sm
              |> tabs.children([
                tabs.tab("sm") |> tabs.tab_active |> tabs.tab_build,
                tabs.tab("Tab 2") |> tabs.tab_build,
              ])
              |> tabs.build,
            tabs.new()
              |> tabs.box
              |> tabs.md
              |> tabs.children([
                tabs.tab("md") |> tabs.tab_active |> tabs.tab_build,
                tabs.tab("Tab 2") |> tabs.tab_build,
              ])
              |> tabs.build,
            tabs.new()
              |> tabs.box
              |> tabs.lg
              |> tabs.children([
                tabs.tab("lg") |> tabs.tab_active |> tabs.tab_build,
                tabs.tab("Tab 2") |> tabs.tab_build,
              ])
              |> tabs.build,
            tabs.new()
              |> tabs.box
              |> tabs.xl
              |> tabs.children([
                tabs.tab("xl") |> tabs.tab_active |> tabs.tab_build,
                tabs.tab("Tab 2") |> tabs.tab_build,
              ])
              |> tabs.build,
          ],
        ),
      ]),
      section("Bottom placement (radio + lift)", [
        tabs.new()
          |> tabs.lift
          |> tabs.bottom
          |> tabs.children(
            tabs.radio_items("bottom_tabs", [
              tabs.radio_item(
                "Tab 1",
                [html.p([attribute.class("py-4")], [html.text("Content above tab bar")])],
                True,
              ),
              tabs.radio_item("Tab 2", [], False),
              tabs.radio_item("Tab 3", [], False),
            ]),
          )
          |> tabs.build,
      ]),
      section("Disabled tab", [
        tabs.new()
          |> tabs.border
          |> tabs.children([
            tabs.tab("Tab 1") |> tabs.tab_active |> tabs.tab_build,
            tabs.tab("Tab 2") |> tabs.tab_build,
            tabs.tab("Tab 3") |> tabs.tab_disabled |> tabs.tab_build,
          ])
          |> tabs.build,
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
