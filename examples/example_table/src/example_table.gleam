import daisyui/select
import daisyui/table
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Table")]),
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
// Helpers
// ---------------------------------------------------------------------------

fn simple_head() -> Element(msg) {
  html.thead([], [
    html.tr([], [
      html.th([], []),
      html.th([], [html.text("Name")]),
      html.th([], [html.text("Job")]),
      html.th([], [html.text("Favorite Color")]),
    ]),
  ])
}

fn simple_rows() -> List(Element(msg)) {
  [
    html.tr([], [
      html.th([], [html.text("1")]),
      html.td([], [html.text("Cy Ganderton")]),
      html.td([], [html.text("Quality Control Specialist")]),
      html.td([], [html.text("Blue")]),
    ]),
    html.tr([], [
      html.th([], [html.text("2")]),
      html.td([], [html.text("Hart Hagerty")]),
      html.td([], [html.text("Desktop Support Technician")]),
      html.td([], [html.text("Purple")]),
    ]),
    html.tr([], [
      html.th([], [html.text("3")]),
      html.td([], [html.text("Brice Swyre")]),
      html.td([], [html.text("Tax Accountant")]),
      html.td([], [html.text("Red")]),
    ]),
  ]
}

fn simple_tbody() -> Element(msg) {
  html.tbody([], simple_rows())
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Basic table", [
        table.new()
          |> table.children([simple_head(), simple_tbody()])
          |> table.build
          |> table.wrap,
      ]),
      section("With border and background", [
        html.div(
          [
            attribute.class(
              "overflow-x-auto rounded-box border border-base-content/5 bg-base-100",
            ),
          ],
          [
            table.new()
              |> table.children([simple_head(), simple_tbody()])
              |> table.build,
          ],
        ),
      ]),
      section("Zebra stripes", [
        table.new()
          |> table.zebra
          |> table.children([simple_head(), simple_tbody()])
          |> table.build
          |> table.wrap,
      ]),
      section("Active row (bg-base-200 on first row)", [
        table.new()
          |> table.children([
            simple_head(),
            html.tbody([], [
              html.tr([attribute.class("bg-base-200")], [
                html.th([], [html.text("1")]),
                html.td([], [html.text("Cy Ganderton")]),
                html.td([], [html.text("Quality Control Specialist")]),
                html.td([], [html.text("Blue")]),
              ]),
              html.tr([], [
                html.th([], [html.text("2")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("3")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("Red")]),
              ]),
            ]),
          ])
          |> table.build
          |> table.wrap,
      ]),
      section("Hover row (hover:bg-base-300 on second row)", [
        table.new()
          |> table.children([
            simple_head(),
            html.tbody([], [
              html.tr([], [
                html.th([], [html.text("1")]),
                html.td([], [html.text("Cy Ganderton")]),
                html.td([], [html.text("Quality Control Specialist")]),
                html.td([], [html.text("Blue")]),
              ]),
              html.tr([attribute.class("hover:bg-base-300")], [
                html.th([], [html.text("2")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("3")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("Red")]),
              ]),
            ]),
          ])
          |> table.build
          |> table.wrap,
      ]),
      section("Extra small (table-xs)", [
        table.new()
          |> table.xs
          |> table.children([
            html.thead([], [
              html.tr([], [
                html.th([], []),
                html.th([], [html.text("Name")]),
                html.th([], [html.text("Job")]),
                html.th([], [html.text("Location")]),
                html.th([], [html.text("Favorite Color")]),
              ]),
            ]),
            html.tbody([], [
              html.tr([], [
                html.th([], [html.text("1")]),
                html.td([], [html.text("Cy Ganderton")]),
                html.td([], [html.text("Quality Control Specialist")]),
                html.td([], [html.text("Canada")]),
                html.td([], [html.text("Blue")]),
              ]),
              html.tr([], [
                html.th([], [html.text("2")]),
                html.td([], [html.text("Hart Hagerty")]),
                html.td([], [html.text("Desktop Support Technician")]),
                html.td([], [html.text("United States")]),
                html.td([], [html.text("Purple")]),
              ]),
              html.tr([], [
                html.th([], [html.text("3")]),
                html.td([], [html.text("Brice Swyre")]),
                html.td([], [html.text("Tax Accountant")]),
                html.td([], [html.text("China")]),
                html.td([], [html.text("Red")]),
              ]),
            ]),
            html.tfoot([], [
              html.tr([], [
                html.th([], []),
                html.th([], [html.text("Name")]),
                html.th([], [html.text("Job")]),
                html.th([], [html.text("Location")]),
                html.th([], [html.text("Favorite Color")]),
              ]),
            ]),
          ])
          |> table.build
          |> table.wrap,
      ]),
      section("Pin rows (scrollable, h-64)", [
        html.div([attribute.class("h-64 overflow-x-auto")], [
          table.new()
            |> table.pin_rows
            |> table.attrs([attribute.class("bg-base-200")])
            |> table.children([
              html.thead([], [html.tr([], [html.th([], [html.text("A")])])]),
              html.tbody([], [
                html.tr([], [html.td([], [html.text("Ant-Man")])]),
                html.tr([], [html.td([], [html.text("Aquaman")])]),
                html.tr([], [html.td([], [html.text("Asterix")])]),
                html.tr([], [html.td([], [html.text("The Atom")])]),
                html.tr([], [html.td([], [html.text("The Avengers")])]),
              ]),
              html.thead([], [html.tr([], [html.th([], [html.text("B")])])]),
              html.tbody([], [
                html.tr([], [html.td([], [html.text("Batgirl")])]),
                html.tr([], [html.td([], [html.text("Batman")])]),
                html.tr([], [html.td([], [html.text("Batwoman")])]),
                html.tr([], [html.td([], [html.text("Black Canary")])]),
                html.tr([], [html.td([], [html.text("Black Panther")])]),
              ]),
              html.thead([], [html.tr([], [html.th([], [html.text("C")])])]),
              html.tbody([], [
                html.tr([], [html.td([], [html.text("Captain America")])]),
                html.tr([], [html.td([], [html.text("Captain Marvel")])]),
                html.tr([], [html.td([], [html.text("Catwoman")])]),
                html.tr([], [html.td([], [html.text("Conan the Barbarian")])]),
              ]),
              html.thead([], [html.tr([], [html.th([], [html.text("S")])])]),
              html.tbody([], [
                html.tr([], [html.td([], [html.text("Spider-Man")])]),
                html.tr([], [html.td([], [html.text("Superman")])]),
                html.tr([], [html.td([], [html.text("Supergirl")])]),
              ]),
              html.thead([], [html.tr([], [html.th([], [html.text("W")])])]),
              html.tbody([], [
                html.tr([], [html.td([], [html.text("Wolverine")])]),
                html.tr([], [html.td([], [html.text("Wonder Woman")])]),
              ]),
            ])
            |> table.build,
        ]),
      ]),
      section("Pin rows + pin cols (xs, 384×256 scroll box)", [
        html.div([attribute.class("overflow-x-auto h-64 w-96")], [
          table.new()
            |> table.xs
            |> table.pin_rows
            |> table.pin_cols
            |> table.children([
              html.thead([], [
                html.tr([], [
                  html.th([], []),
                  html.td([], [html.text("Name")]),
                  html.td([], [html.text("Job")]),
                  html.td([], [html.text("Company")]),
                  html.td([], [html.text("Location")]),
                  html.td([], [html.text("Last Login")]),
                  html.td([], [html.text("Favorite Color")]),
                  html.th([], []),
                ]),
              ]),
              html.tbody([], [
                pin_row("1", "Cy Ganderton", "Quality Control Specialist", "Littel, Schaden and Vandervort", "Canada", "12/16/2020", "Blue"),
                pin_row("2", "Hart Hagerty", "Desktop Support Technician", "Zemlak, Daniel and Leannon", "United States", "12/5/2020", "Purple"),
                pin_row("3", "Brice Swyre", "Tax Accountant", "Carroll Group", "China", "8/15/2020", "Red"),
                pin_row("4", "Marjy Ferencz", "Office Assistant I", "Rowe-Schoen", "Russia", "3/25/2021", "Crimson"),
                pin_row("5", "Yancy Tear", "Community Outreach Specialist", "Wyman-Ledner", "Brazil", "5/22/2020", "Indigo"),
                pin_row("6", "Irma Vasilik", "Editor", "Wiza, Bins and Emard", "Venezuela", "12/8/2020", "Purple"),
                pin_row("7", "Meghann Durtnal", "Staff Accountant IV", "Schuster-Schimmel", "Philippines", "2/17/2021", "Yellow"),
                pin_row("8", "Sammy Seston", "Accountant I", "O'Hara, Welch and Keebler", "Indonesia", "5/23/2020", "Crimson"),
              ]),
              html.tfoot([], [
                html.tr([], [
                  html.th([], []),
                  html.td([], [html.text("Name")]),
                  html.td([], [html.text("Job")]),
                  html.td([], [html.text("Company")]),
                  html.td([], [html.text("Location")]),
                  html.td([], [html.text("Last Login")]),
                  html.td([], [html.text("Favorite Color")]),
                  html.th([], []),
                ]),
              ]),
            ])
            |> table.build,
        ]),
      ]),
    ],
  )
}

fn pin_row(num: String, name: String, job: String, company: String, location: String, login: String, color: String) -> Element(msg) {
  html.tr([], [
    html.th([], [html.text(num)]),
    html.td([], [html.text(name)]),
    html.td([], [html.text(job)]),
    html.td([], [html.text(company)]),
    html.td([], [html.text(location)]),
    html.td([], [html.text(login)]),
    html.td([], [html.text(color)]),
    html.th([], [html.text(num)]),
  ])
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
