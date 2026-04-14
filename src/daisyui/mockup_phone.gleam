/// A builder for DaisyUI phone mockup elements.
///
/// Phone mockup shows a styled iPhone frame. The display area can contain
/// arbitrary children (text, images, etc.).
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/mockup_phone
/// import lustre/element/html
///
/// // Basic phone with text
/// mockup_phone.new()
/// |> mockup_phone.display_children([html.text("It's Glowtime.")])
/// |> mockup_phone.build
///
/// // With border colour and wallpaper image
/// mockup_phone.new()
/// |> mockup_phone.border_color("#ff8938")
/// |> mockup_phone.display_children([
///   html.img([attribute.src("/wallpaper.webp"), attribute.alt("wallpaper")], []),
/// ])
/// |> mockup_phone.build
/// ```
///
/// ## Reference
/// - [DaisyUI mockup-phone](https://daisyui.com/components/mockup-phone/)
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type MockupPhone(msg) {
  MockupPhone(
    border_color: String,
    display_attrs: List(Attribute(msg)),
    display_children: List(Element(msg)),
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `MockupPhone` builder with default styling.
pub fn new() -> MockupPhone(msg) {
  MockupPhone(
    border_color: "",
    display_attrs: [],
    display_children: [],
    attrs: [],
  )
}

// ---------------------------------------------------------------------------
// Options
// ---------------------------------------------------------------------------

/// Sets the phone border colour via an inline `border-color` style.
///
/// Accepts any CSS colour value, e.g. `"#ff8938"` or `"oklch(70% 0.2 60)"`.
pub fn border_color(m: MockupPhone(msg), color: String) -> MockupPhone(msg) {
  MockupPhone(..m, border_color: color)
}

/// Merges additional Lustre attributes onto the outer `<div class="mockup-phone">`.
pub fn attrs(m: MockupPhone(msg), a: List(Attribute(msg))) -> MockupPhone(msg) {
  MockupPhone(..m, attrs: a)
}

/// Merges additional Lustre attributes onto `<div class="mockup-phone-display">`.
pub fn display_attrs(
  m: MockupPhone(msg),
  a: List(Attribute(msg)),
) -> MockupPhone(msg) {
  MockupPhone(..m, display_attrs: a)
}

/// Sets the children rendered inside the display area.
pub fn display_children(
  m: MockupPhone(msg),
  c: List(Element(msg)),
) -> MockupPhone(msg) {
  MockupPhone(..m, display_children: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `MockupPhone` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <div class="mockup-phone" [style="border-color: …"] …attrs>
///   <div class="mockup-phone-camera"></div>
///   <div class="mockup-phone-display" …display_attrs>children</div>
/// </div>
/// ```
pub fn build(m: MockupPhone(msg)) -> Element(msg) {
  let outer_attrs = case m.border_color {
    "" -> [attribute.class("mockup-phone"), ..m.attrs]
    c -> [
      attribute.class("mockup-phone"),
      attribute.attribute("style", "border-color: " <> c <> ";"),
      ..m.attrs
    ]
  }

  html.div(outer_attrs, [
    html.div([attribute.class("mockup-phone-camera")], []),
    html.div(
      [attribute.class("mockup-phone-display"), ..m.display_attrs],
      m.display_children,
    ),
  ])
}
