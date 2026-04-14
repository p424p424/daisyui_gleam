import daisyui/pagination
import daisyui/select
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub type Model {
  Model(theme: String, current_page: Int)
}

pub type Msg {
  UserChangedTheme(String)
  UserChangedPage(Int)
}

pub fn main() {
  let app = lustre.simple(
    fn(_) { Model(theme: "light", current_page: 2) },
    update,
    view,
  )
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedTheme(t) -> Model(..model, theme: t)
    UserChangedPage(p) -> Model(..model, current_page: p)
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
      html.h1([attribute.class("text-lg font-semibold")], [
        html.text("Pagination"),
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

fn pages(current: Int, size_fn: fn(pagination.Pagination(Msg)) -> pagination.Pagination(Msg)) -> Element(Msg) {
  pagination.new()
  |> size_fn
  |> pagination.items([
    pagination.page("1")
      |> mark_active(current == 1)
      |> pagination.page_attrs([event.on_click(UserChangedPage(1))]),
    pagination.page("2")
      |> mark_active(current == 2)
      |> pagination.page_attrs([event.on_click(UserChangedPage(2))]),
    pagination.page("3")
      |> mark_active(current == 3)
      |> pagination.page_attrs([event.on_click(UserChangedPage(3))]),
    pagination.page("4")
      |> mark_active(current == 4)
      |> pagination.page_attrs([event.on_click(UserChangedPage(4))]),
  ])
  |> pagination.build
}

fn mark_active(p: pagination.PageItem(msg), is_active: Bool) -> pagination.PageItem(msg) {
  case is_active {
    True -> pagination.active(p)
    False -> p
  }
}

fn main_content(model: Model) -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Active button (click to change page)", [
        html.p([attribute.class("text-sm opacity-60")], [
          html.text("Current page: " <> int_to_string(model.current_page)),
        ]),
        pages(model.current_page, fn(p) { p }),
      ]),
      section("Sizes", [
        html.div([attribute.class("flex flex-col gap-3 items-start")], [
          pages(2, pagination.xs),
          pages(2, pagination.sm),
          pages(2, pagination.md),
          pages(2, pagination.lg),
          pages(2, pagination.xl),
        ]),
      ]),
      section("With disabled button", [
        pagination.new()
        |> pagination.items([
          pagination.page("1"),
          pagination.page("2"),
          pagination.page("...") |> pagination.disabled,
          pagination.page("99"),
          pagination.page("100"),
        ])
        |> pagination.build,
      ]),
      section("Prev / Next (« Page »)", [
        pagination.new()
        |> pagination.items([
          pagination.page("«"),
          pagination.page("Page 22"),
          pagination.page("»"),
        ])
        |> pagination.build,
      ]),
      section("Prev / Next outline, equal width", [
        pagination.new()
        |> pagination.grid_2
        |> pagination.attrs([attribute.class("w-64")])
        |> pagination.items([
          pagination.page("Previous page") |> pagination.outline,
          pagination.page("Next page") |> pagination.outline,
        ])
        |> pagination.build,
      ]),
      section("Radio inputs", [
        html.div([attribute.class("join")], [
          html.input([
            attribute.class("join-item btn btn-square"),
            attribute.type_("radio"),
            attribute.name("pag-radio"),
            attribute.attribute("aria-label", "1"),
            attribute.checked(True),
          ]),
          html.input([
            attribute.class("join-item btn btn-square"),
            attribute.type_("radio"),
            attribute.name("pag-radio"),
            attribute.attribute("aria-label", "2"),
          ]),
          html.input([
            attribute.class("join-item btn btn-square"),
            attribute.type_("radio"),
            attribute.name("pag-radio"),
            attribute.attribute("aria-label", "3"),
          ]),
          html.input([
            attribute.class("join-item btn btn-square"),
            attribute.type_("radio"),
            attribute.name("pag-radio"),
            attribute.attribute("aria-label", "4"),
          ]),
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

fn int_to_string(n: Int) -> String {
  case n {
    1 -> "1"
    2 -> "2"
    3 -> "3"
    4 -> "4"
    _ -> "?"
  }
}
