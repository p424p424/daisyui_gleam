import daisyui/theme_controller as tc
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg

pub fn main() {
  let app = lustre.element(view())
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn view() -> Element(msg) {
  html.div(
    [attribute.class("min-h-screen bg-base-200")],
    [
      html.header(
        [
          attribute.class(
            "fixed top-0 left-0 right-0 z-50 flex items-center px-6 h-16 bg-base-100 shadow",
          ),
        ],
        [
          html.h1([attribute.class("text-lg font-semibold")], [
            html.text("Theme Controller"),
          ]),
        ],
      ),
      html.main(
        [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
        [
          section("Toggle checkbox", [
            html.label([attribute.class("flex cursor-pointer gap-2 items-center")], [
              html.span([attribute.class("label-text")], [html.text("Default")]),
              tc.toggle("synthwave", []),
              html.span([attribute.class("label-text")], [html.text("Synthwave")]),
            ]),
          ]),
          section("Checkbox", [
            tc.checkbox("synthwave", []),
          ]),
          section("Swap (sun ↔ moon)", [
            html.label([attribute.class("swap swap-rotate")], [
              tc.swap_checkbox("synthwave", []),
              // sun icon — shown when unchecked (swap-off)
              svg.svg(
                [
                  attribute.class("swap-off h-10 w-10 fill-current"),
                  attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
                  attribute.attribute("viewBox", "0 0 24 24"),
                ],
                [
                  svg.path([
                    attribute.attribute(
                      "d",
                      "M5.64,17l-.71.71a1,1,0,0,0,0,1.41,1,1,0,0,0,1.41,0l.71-.71A1,1,0,0,0,5.64,17ZM5,12a1,1,0,0,0-1-1H3a1,1,0,0,0,0,2H4A1,1,0,0,0,5,12Zm7-7a1,1,0,0,0,1-1V3a1,1,0,0,0-2,0V4A1,1,0,0,0,12,5ZM5.64,7.05a1,1,0,0,0,.7.29,1,1,0,0,0,.71-.29,1,1,0,0,0,0-1.41l-.71-.71A1,1,0,0,0,4.93,6.34Zm12,.29a1,1,0,0,0,.7-.29l.71-.71a1,1,0,1,0-1.41-1.41L17,5.64a1,1,0,0,0,0,1.41A1,1,0,0,0,17.66,7.34ZM21,11H20a1,1,0,0,0,0,2h1a1,1,0,0,0,0-2Zm-9,8a1,1,0,0,0-1,1v1a1,1,0,0,0,2,0V20A1,1,0,0,0,12,19ZM18.36,17A1,1,0,0,0,17,18.36l.71.71a1,1,0,0,0,1.41,0,1,1,0,0,0,0-1.41ZM12,6.5A5.5,5.5,0,1,0,17.5,12,5.51,5.51,0,0,0,12,6.5Zm0,9A3.5,3.5,0,1,1,15.5,12,3.5,3.5,0,0,1,12,15.5Z",
                    ),
                  ]),
                ],
              ),
              // moon icon — shown when checked (swap-on)
              svg.svg(
                [
                  attribute.class("swap-on h-10 w-10 fill-current"),
                  attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
                  attribute.attribute("viewBox", "0 0 24 24"),
                ],
                [
                  svg.path([
                    attribute.attribute(
                      "d",
                      "M21.64,13a1,1,0,0,0-1.05-.14,8.05,8.05,0,0,1-3.37.73A8.15,8.15,0,0,1,9.08,5.49a8.59,8.59,0,0,1,.25-2A1,1,0,0,0,8,2.36,10.14,10.14,0,1,0,22,14.05,1,1,0,0,0,21.64,13Zm-9.5,6.69A8.14,8.14,0,0,1,7.08,5.22v.27A10.15,10.15,0,0,0,17.22,15.63a9.79,9.79,0,0,0,2.1-.22A8.11,8.11,0,0,1,12.14,19.73Z",
                    ),
                  ]),
                ],
              ),
            ]),
          ]),
          section("Radio inputs (fieldset)", [
            html.fieldset([attribute.class("fieldset")], [
              radio_label("theme-radios", "default", "Default"),
              radio_label("theme-radios", "retro", "Retro"),
              radio_label("theme-radios", "cyberpunk", "Cyberpunk"),
              radio_label("theme-radios", "valentine", "Valentine"),
              radio_label("theme-radios", "aqua", "Aqua"),
            ]),
          ]),
          section("Radio buttons (join)", [
            html.div([attribute.class("join join-vertical")], [
              tc.radio_btn("theme-btns", "default", "Default", [
                attribute.class("join-item"),
              ]),
              tc.radio_btn("theme-btns", "retro", "Retro", [
                attribute.class("join-item"),
              ]),
              tc.radio_btn("theme-btns", "cyberpunk", "Cyberpunk", [
                attribute.class("join-item"),
              ]),
              tc.radio_btn("theme-btns", "valentine", "Valentine", [
                attribute.class("join-item"),
              ]),
              tc.radio_btn("theme-btns", "aqua", "Aqua", [
                attribute.class("join-item"),
              ]),
            ]),
          ]),
          section("Dropdown", [
            html.div([attribute.class("dropdown mb-72")], [
              html.div(
                [
                  attribute.attribute("tabindex", "0"),
                  attribute.role("button"),
                  attribute.class("btn m-1"),
                ],
                [html.text("Theme ▾")],
              ),
              html.ul(
                [
                  attribute.attribute("tabindex", "-1"),
                  attribute.class(
                    "dropdown-content bg-base-300 rounded-box z-1 w-52 p-2 shadow-2xl",
                  ),
                ],
                [
                  html.li([], [
                    tc.radio_dropdown("theme-dropdown", "default", "Default", []),
                  ]),
                  html.li([], [
                    tc.radio_dropdown("theme-dropdown", "retro", "Retro", []),
                  ]),
                  html.li([], [
                    tc.radio_dropdown(
                      "theme-dropdown",
                      "cyberpunk",
                      "Cyberpunk",
                      [],
                    ),
                  ]),
                  html.li([], [
                    tc.radio_dropdown(
                      "theme-dropdown",
                      "valentine",
                      "Valentine",
                      [],
                    ),
                  ]),
                  html.li([], [
                    tc.radio_dropdown("theme-dropdown", "aqua", "Aqua", []),
                  ]),
                ],
              ),
            ]),
          ]),
        ],
      ),
    ],
  )
}

fn radio_label(name: String, theme: String, label: String) -> Element(msg) {
  html.label([attribute.class("flex gap-2 cursor-pointer items-center")], [
    tc.radio(name, theme, [attribute.class("radio-sm")]),
    html.text(label),
  ])
}

fn section(label: String, children: List(Element(msg))) -> Element(msg) {
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
