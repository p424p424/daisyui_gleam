import daisyui/modal
import daisyui/select
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub type Model {
  Model(theme: String, checkbox_open: Bool)
}

pub type Msg {
  UserChangedTheme(String)
  UserToggledCheckboxModal(Bool)
}

pub fn main() {
  let app = lustre.simple(
    fn(_) { Model(theme: "light", checkbox_open: False) },
    update,
    view,
  )
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedTheme(t) -> Model(..model, theme: t)
    UserToggledCheckboxModal(v) -> Model(..model, checkbox_open: v)
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Modal")]),
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
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      // ── Method 1: <dialog> ───────────────────────────────────────────────
      section("Method 1: dialog element (recommended)", [
        html.div([attribute.class("flex flex-wrap gap-3")], [
          // Basic dialog
          html.button(
            [
              attribute.class("btn"),
              attribute.attribute("onclick", "modal_basic.showModal()"),
            ],
            [html.text("Basic modal")],
          ),
          modal.dialog_new("modal_basic")
          |> modal.children([
            modal.box([], [
              html.h3([attribute.class("text-lg font-bold")], [
                html.text("Hello!"),
              ]),
              html.p([attribute.class("py-4")], [
                html.text("Press ESC key or click the button below to close"),
              ]),
              modal.action([
                html.form([attribute.method("dialog")], [
                  html.button([attribute.class("btn")], [html.text("Close")]),
                ]),
              ]),
            ]),
          ])
          |> modal.build,
          // Close on outside click
          html.button(
            [
              attribute.class("btn"),
              attribute.attribute("onclick", "modal_outside.showModal()"),
            ],
            [html.text("Close on outside click")],
          ),
          modal.dialog_new("modal_outside")
          |> modal.children([
            modal.box([], [
              html.h3([attribute.class("text-lg font-bold")], [
                html.text("Hello!"),
              ]),
              html.p([attribute.class("py-4")], [
                html.text("Press ESC key or click outside to close"),
              ]),
            ]),
            modal.backdrop_form([
              html.button([], [html.text("close")]),
            ]),
          ])
          |> modal.build,
          // Corner close button
          html.button(
            [
              attribute.class("btn"),
              attribute.attribute("onclick", "modal_corner.showModal()"),
            ],
            [html.text("Corner close button")],
          ),
          modal.dialog_new("modal_corner")
          |> modal.children([
            modal.box([], [
              html.form([attribute.method("dialog")], [
                html.button(
                  [
                    attribute.class(
                      "btn btn-sm btn-circle btn-ghost absolute right-2 top-2",
                    ),
                  ],
                  [html.text("✕")],
                ),
              ]),
              html.h3([attribute.class("text-lg font-bold")], [
                html.text("Hello!"),
              ]),
              html.p([attribute.class("py-4")], [
                html.text("Press ESC key or click on ✕ button to close"),
              ]),
            ]),
          ])
          |> modal.build,
          // Custom width
          html.button(
            [
              attribute.class("btn"),
              attribute.attribute("onclick", "modal_wide.showModal()"),
            ],
            [html.text("Custom width")],
          ),
          modal.dialog_new("modal_wide")
          |> modal.children([
            modal.box(
              [attribute.class("w-11/12 max-w-5xl")],
              [
                html.h3([attribute.class("text-lg font-bold")], [
                  html.text("Hello!"),
                ]),
                html.p([attribute.class("py-4")], [
                  html.text("Click the button below to close"),
                ]),
                modal.action([
                  html.form([attribute.method("dialog")], [
                    html.button([attribute.class("btn")], [html.text("Close")]),
                  ]),
                ]),
              ],
            ),
          ])
          |> modal.build,
          // Responsive (bottom on sm, middle on md+)
          html.button(
            [
              attribute.class("btn"),
              attribute.attribute("onclick", "modal_resp.showModal()"),
            ],
            [html.text("Responsive")],
          ),
          modal.dialog_new("modal_resp")
          |> modal.bottom
          |> modal.attrs([attribute.class("sm:modal-middle")])
          |> modal.children([
            modal.box([], [
              html.h3([attribute.class("text-lg font-bold")], [
                html.text("Hello!"),
              ]),
              html.p([attribute.class("py-4")], [
                html.text("Bottom on small screens, middle on larger ones"),
              ]),
              modal.action([
                html.form([attribute.method("dialog")], [
                  html.button([attribute.class("btn")], [html.text("Close")]),
                ]),
              ]),
            ]),
          ])
          |> modal.build,
        ]),
      ]),
      // ── Method 2: checkbox ───────────────────────────────────────────────
      section("Method 2: checkbox", [
        html.div([attribute.class("flex flex-wrap gap-3")], [
          html.label(
            [attribute.for("modal_checkbox"), attribute.class("btn")],
            [html.text("Open modal")],
          ),
          html.input([
            attribute.type_("checkbox"),
            attribute.id("modal_checkbox"),
            attribute.class("modal-toggle"),
            attribute.checked(model.checkbox_open),
            event.on_check(UserToggledCheckboxModal),
          ]),
          modal.new()
          |> modal.children([
            modal.box([], [
              html.h3([attribute.class("text-lg font-bold")], [
                html.text("Hello!"),
              ]),
              html.p([attribute.class("py-4")], [
                html.text("This modal works with a hidden checkbox!"),
              ]),
              modal.action([
                html.label(
                  [
                    attribute.for("modal_checkbox"),
                    attribute.class("btn"),
                  ],
                  [html.text("Close!")],
                ),
              ]),
            ]),
            modal.backdrop_label("modal_checkbox"),
          ])
          |> modal.build,
        ]),
      ]),
      // ── Method 3: anchor link ────────────────────────────────────────────
      section("Method 3: anchor link", [
        html.div([attribute.class("flex flex-wrap gap-3")], [
          html.a(
            [attribute.href("#modal_anchor"), attribute.class("btn")],
            [html.text("Open modal")],
          ),
          modal.new()
          |> modal.attrs([attribute.id("modal_anchor")])
          |> modal.children([
            modal.box([], [
              html.h3([attribute.class("text-lg font-bold")], [
                html.text("Hello!"),
              ]),
              html.p([attribute.class("py-4")], [
                html.text("This modal works with anchor links"),
              ]),
              modal.action([
                html.a(
                  [attribute.href("#"), attribute.class("btn")],
                  [html.text("Yay!")],
                ),
              ]),
            ]),
          ])
          |> modal.build,
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
