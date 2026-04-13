import daisyui/accordion
import daisyui/select
import daisyui/text
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
        html.text("Accordion"),
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
      html.div([attribute.class("w-full max-w-lg space-y-2 p-4")], [
        faq_item(
          "What is DaisyUI?",
          "DaisyUI is a component library built on top of Tailwind CSS.",
        ),
        faq_item(
          "What is Lustre?",
          "Lustre is a Gleam web framework that models your UI as a tree of Element(msg) values.",
        ),
        faq_item(
          "What is daisyui_gleam?",
          "daisyui_gleam bridges DaisyUI and Lustre with type-safe component builders.",
        ),
      ]),
    ],
  )
}

fn faq_item(question: String, answer: String) -> Element(Msg) {
  accordion.new()
  |> accordion.arrow()
  |> accordion.attrs([attribute.class("border border-base-300 rounded-xl")])
  |> accordion.title(attrs: [], children: [
    text.new()
    |> text.span()
    |> text.semibold()
    |> text.base_content()
    |> text.text(question)
    |> text.build(),
  ])
  |> accordion.content(attrs: [], children: [
    text.new()
    |> text.p()
    |> text.text(answer)
    |> text.build(),
  ])
  |> accordion.build()
}
