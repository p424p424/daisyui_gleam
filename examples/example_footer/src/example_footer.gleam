import daisyui/footer
import daisyui/select
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
      html.h1([attribute.class("text-lg font-semibold")], [
        html.text("Footer"),
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
    [
      attribute.class(
        "pt-20 pb-10 flex flex-col items-center min-h-screen gap-8",
      ),
    ],
    [
      // Basic nav columns
      section("Vertical (default) with nav columns", [
        footer.new()
          |> footer.attrs([
            attribute.class(
              "sm:footer-horizontal bg-neutral text-neutral-content p-10 w-full",
            ),
          ])
          |> footer.children([
            html.nav([], [
              footer.title("Services"),
              html.a([attribute.class("link link-hover")], [
                html.text("Branding"),
              ]),
              html.a([attribute.class("link link-hover")], [html.text("Design")]),
              html.a([attribute.class("link link-hover")], [
                html.text("Marketing"),
              ]),
              html.a([attribute.class("link link-hover")], [
                html.text("Advertisement"),
              ]),
            ]),
            html.nav([], [
              footer.title("Company"),
              html.a([attribute.class("link link-hover")], [
                html.text("About us"),
              ]),
              html.a([attribute.class("link link-hover")], [
                html.text("Contact"),
              ]),
              html.a([attribute.class("link link-hover")], [html.text("Jobs")]),
              html.a([attribute.class("link link-hover")], [
                html.text("Press kit"),
              ]),
            ]),
            html.nav([], [
              footer.title("Legal"),
              html.a([attribute.class("link link-hover")], [
                html.text("Terms of use"),
              ]),
              html.a([attribute.class("link link-hover")], [
                html.text("Privacy policy"),
              ]),
              html.a([attribute.class("link link-hover")], [
                html.text("Cookie policy"),
              ]),
            ]),
          ])
          |> footer.build,
      ]),
      // With logo aside
      section("With logo aside", [
        footer.new()
          |> footer.attrs([
            attribute.class(
              "sm:footer-horizontal bg-base-200 text-base-content p-10 w-full",
            ),
          ])
          |> footer.children([
            html.aside([], [
              acme_logo_large(),
              html.p([], [
                html.text("ACME Industries Ltd."),
                html.br([]),
                html.text("Providing reliable tech since 1992"),
              ]),
            ]),
            html.nav([], [
              footer.title("Services"),
              html.a([attribute.class("link link-hover")], [
                html.text("Branding"),
              ]),
              html.a([attribute.class("link link-hover")], [html.text("Design")]),
              html.a([attribute.class("link link-hover")], [
                html.text("Marketing"),
              ]),
              html.a([attribute.class("link link-hover")], [
                html.text("Advertisement"),
              ]),
            ]),
            html.nav([], [
              footer.title("Legal"),
              html.a([attribute.class("link link-hover")], [
                html.text("Terms of use"),
              ]),
              html.a([attribute.class("link link-hover")], [
                html.text("Privacy policy"),
              ]),
              html.a([attribute.class("link link-hover")], [
                html.text("Cookie policy"),
              ]),
            ]),
          ])
          |> footer.build,
      ]),
      // With social icons
      section("With social icons", [
        footer.new()
          |> footer.attrs([
            attribute.class(
              "sm:footer-horizontal bg-neutral text-neutral-content p-10 w-full",
            ),
          ])
          |> footer.children([
            html.aside([], [
              acme_logo_large(),
              html.p([], [
                html.text("ACME Industries Ltd."),
                html.br([]),
                html.text("Providing reliable tech since 1992"),
              ]),
            ]),
            html.nav([], [
              footer.title("Social"),
              html.div([attribute.class("grid grid-flow-col gap-4")], [
                html.a([], [twitter_icon()]),
                html.a([], [youtube_icon()]),
                html.a([], [facebook_icon()]),
              ]),
            ]),
          ])
          |> footer.build,
      ]),
      // Centered with footer-center modifier
      section("Centered (footer-center)", [
        footer.new()
          |> footer.horizontal
          |> footer.center
          |> footer.attrs([
            attribute.class("bg-primary text-primary-content p-10 w-full"),
          ])
          |> footer.children([
            html.aside([], [
              acme_logo_large(),
              html.p([attribute.class("font-bold")], [
                html.text("ACME Industries Ltd."),
                html.br([]),
                html.text("Providing reliable tech since 1992"),
              ]),
              html.p([], [
                html.text("Copyright © 2024 - All right reserved"),
              ]),
            ]),
            html.nav([], [
              html.div([attribute.class("grid grid-flow-col gap-4")], [
                html.a([], [twitter_icon()]),
                html.a([], [youtube_icon()]),
                html.a([], [facebook_icon()]),
              ]),
            ]),
          ])
          |> footer.build,
      ]),
      // Copyright bar
      section("Copyright bar", [
        footer.new()
          |> footer.horizontal
          |> footer.center
          |> footer.attrs([
            attribute.class("bg-base-300 text-base-content p-4 w-full"),
          ])
          |> footer.children([
            html.aside([], [
              html.p([], [
                html.text(
                  "Copyright © 2024 - All right reserved by ACME Industries Ltd",
                ),
              ]),
            ]),
          ])
          |> footer.build,
      ]),
    ],
  )
}

fn section(label: String, children: List(Element(Msg))) -> Element(Msg) {
  html.div([attribute.class("w-full max-w-4xl space-y-3 px-4")], [
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

fn acme_logo_large() -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("width", "50"),
      attribute.attribute("height", "50"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("fill-rule", "evenodd"),
      attribute.attribute("clip-rule", "evenodd"),
      attribute.class("fill-current"),
    ],
    [
      svg.path(
        [
          attribute.attribute(
            "d",
            "M22.672 15.226l-2.432.811.841 2.515c.33 1.019-.209 2.127-1.23 2.456-1.15.325-2.148-.321-2.463-1.226l-.84-2.518-5.013 1.677.84 2.517c.391 1.203-.434 2.542-1.831 2.542-.88 0-1.601-.564-1.86-1.314l-.842-2.516-2.431.809c-1.135.328-2.145-.317-2.463-1.229-.329-1.018.211-2.127 1.231-2.456l2.432-.809-1.621-4.823-2.432.808c-1.355.384-2.558-.59-2.558-1.839 0-.817.509-1.582 1.327-1.846l2.433-.809-.842-2.515c-.33-1.02.211-2.129 1.232-2.458 1.02-.329 2.13.209 2.461 1.229l.842 2.515 5.011-1.677-.839-2.517c-.403-1.238.484-2.553 1.843-2.553.819 0 1.585.509 1.85 1.326l.841 2.517 2.431-.81c1.02-.33 2.131.211 2.461 1.229.332 1.018-.21 2.126-1.23 2.456l-2.433.809 1.622 4.823 2.433-.809c1.242-.401 2.557.484 2.557 1.838 0 .819-.51 1.583-1.328 1.847m-8.992-6.428l-5.01 1.675 1.619 4.828 5.011-1.674-1.62-4.829z",
          ),
        ],
      ),
    ],
  )
}

fn twitter_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("width", "24"),
      attribute.attribute("height", "24"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.class("fill-current"),
    ],
    [
      svg.path(
        [
          attribute.attribute(
            "d",
            "M24 4.557c-.883.392-1.832.656-2.828.775 1.017-.609 1.798-1.574 2.165-2.724-.951.564-2.005.974-3.127 1.195-.897-.957-2.178-1.555-3.594-1.555-3.179 0-5.515 2.966-4.797 6.045-4.091-.205-7.719-2.165-10.148-5.144-1.29 2.213-.669 5.108 1.523 6.574-.806-.026-1.566-.247-2.229-.616-.054 2.281 1.581 4.415 3.949 4.89-.693.188-1.452.232-2.224.084.626 1.956 2.444 3.379 4.6 3.419-2.07 1.623-4.678 2.348-7.29 2.04 2.179 1.397 4.768 2.212 7.548 2.212 9.142 0 14.307-7.721 13.995-14.646.962-.695 1.797-1.562 2.457-2.549z",
          ),
        ],
      ),
    ],
  )
}

fn youtube_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("width", "24"),
      attribute.attribute("height", "24"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.class("fill-current"),
    ],
    [
      svg.path(
        [
          attribute.attribute(
            "d",
            "M19.615 3.184c-3.604-.246-11.631-.245-15.23 0-3.897.266-4.356 2.62-4.385 8.816.029 6.185.484 8.549 4.385 8.816 3.6.245 11.626.246 15.23 0 3.897-.266 4.356-2.62 4.385-8.816-.029-6.185-.484-8.549-4.385-8.816zm-10.615 12.816v-8l8 3.993-8 4.007z",
          ),
        ],
      ),
    ],
  )
}

fn facebook_icon() -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("width", "24"),
      attribute.attribute("height", "24"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.class("fill-current"),
    ],
    [
      svg.path(
        [
          attribute.attribute(
            "d",
            "M9 8h-3v4h3v12h5v-12h3.642l.358-4h-4v-1.667c0-.955.192-1.333 1.115-1.333h2.885v-5h-3.808c-3.596 0-5.192 1.583-5.192 4.615v3.385z",
          ),
        ],
      ),
    ],
  )
}
