import daisyui/hero
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Hero")]),
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
    [attribute.class("pt-16 flex flex-col gap-0")],
    [
      // Centered hero
      section_label("Centered hero"),
      hero.new()
        |> hero.attrs([attribute.class("bg-base-200 min-h-64")])
        |> hero.children([
          hero.content([attribute.class("text-center")], [
            html.div([attribute.class("max-w-md")], [
              html.h1([attribute.class("text-5xl font-bold")], [
                html.text("Hello there"),
              ]),
              html.p([attribute.class("py-6")], [
                html.text(
                  "Provident cupiditate voluptatem et in. Quaerat fugiat ut assumenda excepturi exercitationem quasi.",
                ),
              ]),
              html.button([attribute.class("btn btn-primary")], [
                html.text("Get Started"),
              ]),
            ]),
          ]),
        ])
        |> hero.build,
      // Hero with figure
      section_label("Hero with figure"),
      hero.new()
        |> hero.attrs([attribute.class("bg-base-300 min-h-64")])
        |> hero.children([
          hero.content([attribute.class("flex-col lg:flex-row gap-8")], [
            html.img([
              attribute.src(
                "https://img.daisyui.com/images/stock/photo-1635805737707-575885ab0820.webp",
              ),
              attribute.class("max-w-sm rounded-lg shadow-2xl"),
            ]),
            html.div([], [
              html.h1([attribute.class("text-5xl font-bold")], [
                html.text("Box Office News!"),
              ]),
              html.p([attribute.class("py-6")], [
                html.text(
                  "Provident cupiditate voluptatem et in. Quaerat fugiat ut assumenda excepturi exercitationem quasi.",
                ),
              ]),
              html.button([attribute.class("btn btn-primary")], [
                html.text("Get Started"),
              ]),
            ]),
          ]),
        ])
        |> hero.build,
      // Hero with figure — reversed
      section_label("Hero with figure (reversed)"),
      hero.new()
        |> hero.attrs([attribute.class("bg-base-200 min-h-64")])
        |> hero.children([
          hero.content([attribute.class("flex-col lg:flex-row-reverse gap-8")], [
            html.img([
              attribute.src(
                "https://img.daisyui.com/images/stock/photo-1635805737707-575885ab0820.webp",
              ),
              attribute.class("max-w-sm rounded-lg shadow-2xl"),
            ]),
            html.div([], [
              html.h1([attribute.class("text-5xl font-bold")], [
                html.text("Box Office News!"),
              ]),
              html.p([attribute.class("py-6")], [
                html.text(
                  "Provident cupiditate voluptatem et in. Quaerat fugiat ut assumenda excepturi exercitationem quasi.",
                ),
              ]),
              html.button([attribute.class("btn btn-primary")], [
                html.text("Get Started"),
              ]),
            ]),
          ]),
        ])
        |> hero.build,
      // Hero with overlay image
      section_label("Hero with background image and overlay"),
      hero.new()
        |> hero.bg_image(
          "url(https://img.daisyui.com/images/stock/photo-1507358522600-9f71e620c44e.webp)",
        )
        |> hero.overlay
        |> hero.attrs([attribute.class("min-h-64")])
        |> hero.children([
          hero.content([attribute.class("text-neutral-content text-center")], [
            html.div([attribute.class("max-w-md")], [
              html.h1([attribute.class("mb-5 text-5xl font-bold")], [
                html.text("Hello there"),
              ]),
              html.p([attribute.class("mb-5")], [
                html.text(
                  "Provident cupiditate voluptatem et in. Quaerat fugiat ut assumenda excepturi exercitationem quasi.",
                ),
              ]),
              html.button([attribute.class("btn btn-primary")], [
                html.text("Get Started"),
              ]),
            ]),
          ]),
        ])
        |> hero.build,
    ],
  )
}

fn section_label(label: String) -> Element(Msg) {
  html.div(
    [attribute.class("px-6 pt-6 pb-2")],
    [
      html.p(
        [
          attribute.class(
            "text-sm font-semibold opacity-60 uppercase tracking-wide",
          ),
        ],
        [html.text(label)],
      ),
    ],
  )
}
