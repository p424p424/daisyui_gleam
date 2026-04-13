import daisyui/fieldset
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
        html.text("Fieldset"),
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
      html.div([attribute.class("w-full max-w-xl space-y-10 p-4")], [
        // Basic — no border/background
        section("Basic fieldset", [
          fieldset.new()
            |> fieldset.legend("Page title")
            |> fieldset.children([
              html.input([
                attribute.type_("text"),
                attribute.class("input"),
                attribute.placeholder("My awesome page"),
              ]),
              html.p([attribute.class("label")], [
                html.text(
                  "You can edit page title later on from settings",
                ),
              ]),
            ])
            |> fieldset.build,
        ]),
        // With background and border
        section("With background and border", [
          fieldset.new()
            |> fieldset.legend("Page title")
            |> fieldset.attrs([
              attribute.class(
                "bg-base-200 border-base-300 rounded-box w-xs border p-4",
              ),
            ])
            |> fieldset.children([
              html.input([
                attribute.type_("text"),
                attribute.class("input"),
                attribute.placeholder("My awesome page"),
              ]),
              html.p([attribute.class("label")], [
                html.text(
                  "You can edit page title later on from settings",
                ),
              ]),
            ])
            |> fieldset.build,
        ]),
        // Multiple inputs
        section("Multiple inputs", [
          fieldset.new()
            |> fieldset.legend("Page details")
            |> fieldset.attrs([
              attribute.class(
                "bg-base-200 border-base-300 rounded-box w-xs border p-4",
              ),
            ])
            |> fieldset.children([
              html.label(
                [attribute.class("label"), attribute.for("title")],
                [html.text("Title")],
              ),
              html.input([
                attribute.id("title"),
                attribute.type_("text"),
                attribute.class("input"),
                attribute.placeholder("My awesome page"),
              ]),
              html.label(
                [attribute.class("label"), attribute.for("slug")],
                [html.text("Slug")],
              ),
              html.input([
                attribute.id("slug"),
                attribute.type_("text"),
                attribute.class("input"),
                attribute.placeholder("my-awesome-page"),
              ]),
              html.label(
                [attribute.class("label"), attribute.for("author")],
                [html.text("Author")],
              ),
              html.input([
                attribute.id("author"),
                attribute.type_("text"),
                attribute.class("input"),
                attribute.placeholder("Name"),
              ]),
            ])
            |> fieldset.build,
        ]),
        // Join items
        section("With join items", [
          fieldset.new()
            |> fieldset.legend("Settings")
            |> fieldset.attrs([
              attribute.class(
                "bg-base-200 border-base-300 rounded-box w-xs border p-4",
              ),
            ])
            |> fieldset.children([
              html.div([attribute.class("join")], [
                html.input([
                  attribute.type_("text"),
                  attribute.class("input join-item"),
                  attribute.placeholder("Product name"),
                ]),
                html.button([attribute.class("btn join-item")], [
                  html.text("Save"),
                ]),
              ]),
            ])
            |> fieldset.build,
        ]),
        // Login form
        section("Login form", [
          fieldset.new()
            |> fieldset.legend("Login")
            |> fieldset.attrs([
              attribute.class(
                "bg-base-200 border-base-300 rounded-box w-xs border p-4",
              ),
            ])
            |> fieldset.children([
              html.label(
                [attribute.class("label"), attribute.for("email")],
                [html.text("Email")],
              ),
              html.input([
                attribute.id("email"),
                attribute.type_("email"),
                attribute.class("input"),
                attribute.placeholder("Email"),
              ]),
              html.label(
                [attribute.class("label"), attribute.for("password")],
                [html.text("Password")],
              ),
              html.input([
                attribute.id("password"),
                attribute.type_("password"),
                attribute.class("input"),
                attribute.placeholder("Password"),
              ]),
              html.button([attribute.class("btn btn-neutral mt-4")], [
                html.text("Login"),
              ]),
            ])
            |> fieldset.build,
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
