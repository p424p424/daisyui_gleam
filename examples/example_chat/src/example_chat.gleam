import daisyui/chat
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
        html.text("Chat Bubble"),
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
      html.div([attribute.class("w-full max-w-xl space-y-1 p-4")], [
        // Basic start / end
        chat.new()
          |> chat.start
          |> chat.header(
            attrs: [],
            children: [
              html.text("Obi-Wan  "),
              html.time([attribute.class("text-xs opacity-50")], [
                html.text("12:00"),
              ]),
            ],
          )
          |> chat.text("It's over Anakin, I have the high ground.")
          |> chat.footer(
            attrs: [attribute.class("opacity-50")],
            children: [html.text("Delivered")],
          )
          |> chat.build,
        chat.new()
          |> chat.end
          |> chat.header(
            attrs: [],
            children: [
              html.text("Anakin  "),
              html.time([attribute.class("text-xs opacity-50")], [
                html.text("12:01"),
              ]),
            ],
          )
          |> chat.text("You underestimate my power!")
          |> chat.footer(
            attrs: [attribute.class("opacity-50")],
            children: [html.text("Seen")],
          )
          |> chat.build,
        // Colour variants
        html.div([attribute.class("pt-4")], []),
        chat.new()
          |> chat.start
          |> chat.primary
          |> chat.text("Primary bubble")
          |> chat.build,
        chat.new()
          |> chat.end
          |> chat.secondary
          |> chat.text("Secondary bubble")
          |> chat.build,
        chat.new()
          |> chat.start
          |> chat.accent
          |> chat.text("Accent bubble")
          |> chat.build,
        chat.new()
          |> chat.end
          |> chat.neutral
          |> chat.text("Neutral bubble")
          |> chat.build,
        chat.new()
          |> chat.start
          |> chat.info
          |> chat.text("Info bubble")
          |> chat.build,
        chat.new()
          |> chat.end
          |> chat.success
          |> chat.text("Success bubble")
          |> chat.build,
        chat.new()
          |> chat.start
          |> chat.warning
          |> chat.text("Warning bubble")
          |> chat.build,
        chat.new()
          |> chat.end
          |> chat.error
          |> chat.text("Error bubble")
          |> chat.build,
        // With avatar image
        html.div([attribute.class("pt-4")], []),
        chat.new()
          |> chat.start
          |> chat.image(children: [
            html.div([attribute.class("w-10 rounded-full overflow-hidden bg-neutral text-neutral-content flex items-center justify-center font-bold")], [
              html.text("OW"),
            ]),
          ])
          |> chat.header(attrs: [], children: [html.text("Obi-Wan")])
          |> chat.primary
          |> chat.text("Hello there.")
          |> chat.build,
        chat.new()
          |> chat.end
          |> chat.image(children: [
            html.div([attribute.class("w-10 rounded-full overflow-hidden bg-error text-error-content flex items-center justify-center font-bold")], [
              html.text("A"),
            ]),
          ])
          |> chat.header(attrs: [], children: [html.text("Anakin")])
          |> chat.error
          |> chat.text("General Kenobi!")
          |> chat.build,
      ]),
    ],
  )
}
