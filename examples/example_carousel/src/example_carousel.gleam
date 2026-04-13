import daisyui/carousel
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
        html.text("Carousel"),
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
      carousel.new()
        |> carousel.start
        |> carousel.attrs([attribute.class("rounded-box w-96")])
        |> carousel.items([
          carousel.item(children: [
            html.img([
              attribute.src(
                "https://img.daisyui.com/images/stock/photo-1559703248-dcaaec9fab78.webp",
              ),
              attribute.alt("Slide 1"),
            ]),
          ]),
          carousel.item(children: [
            html.img([
              attribute.src(
                "https://img.daisyui.com/images/stock/photo-1565098772267-60af42b81ef2.webp",
              ),
              attribute.alt("Slide 2"),
            ]),
          ]),
          carousel.item(children: [
            html.img([
              attribute.src(
                "https://img.daisyui.com/images/stock/photo-1572635148818-ef6fd45eb394.webp",
              ),
              attribute.alt("Slide 3"),
            ]),
          ]),
          carousel.item(children: [
            html.img([
              attribute.src(
                "https://img.daisyui.com/images/stock/photo-1494253109108-2e30c049369b.webp",
              ),
              attribute.alt("Slide 4"),
            ]),
          ]),
        ])
        |> carousel.build,
    ],
  )
}
