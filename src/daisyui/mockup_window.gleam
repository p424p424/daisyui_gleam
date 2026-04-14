/// A builder for DaisyUI window mockup elements.
///
/// Window mockup shows a box styled like an operating system window with
/// traffic-light buttons in the title bar.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/mockup_window
/// import lustre/attribute
/// import lustre/element/html
///
/// // With border
/// mockup_window.new()
/// |> mockup_window.bordered
/// |> mockup_window.content_attrs([attribute.class("grid place-content-center h-80")])
/// |> mockup_window.content_children([html.text("Hello!")])
/// |> mockup_window.build
///
/// // With background colour
/// mockup_window.new()
/// |> mockup_window.bg("bg-base-100")
/// |> mockup_window.bordered
/// |> mockup_window.content_attrs([attribute.class("grid place-content-center h-80")])
/// |> mockup_window.content_children([html.text("Hello!")])
/// |> mockup_window.build
/// ```
///
/// ## Reference
/// - [DaisyUI mockup-window](https://daisyui.com/components/mockup-window/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type MockupWindow(msg) {
  MockupWindow(
    bg: Option(String),
    bordered: Bool,
    attrs: List(Attribute(msg)),
    content_attrs: List(Attribute(msg)),
    content_children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `MockupWindow` builder with no border and no background.
pub fn new() -> MockupWindow(msg) {
  MockupWindow(
    bg: None,
    bordered: False,
    attrs: [],
    content_attrs: [],
    content_children: [],
  )
}

// ---------------------------------------------------------------------------
// Options
// ---------------------------------------------------------------------------

/// Adds `border border-base-300` to the outer element and
/// `border-t border-base-300` to the content area (matching the DaisyUI
/// bordered variant).
pub fn bordered(m: MockupWindow(msg)) -> MockupWindow(msg) {
  MockupWindow(..m, bordered: True)
}

/// Sets a background colour utility on the outer element, e.g. `"bg-base-100"`.
pub fn bg(m: MockupWindow(msg), class: String) -> MockupWindow(msg) {
  MockupWindow(..m, bg: Some(class))
}

/// Merges additional Lustre attributes onto the outer `<div class="mockup-window">`.
pub fn attrs(m: MockupWindow(msg), a: List(Attribute(msg))) -> MockupWindow(msg) {
  MockupWindow(..m, attrs: a)
}

/// Merges additional Lustre attributes onto the inner content `<div>`.
pub fn content_attrs(
  m: MockupWindow(msg),
  a: List(Attribute(msg)),
) -> MockupWindow(msg) {
  MockupWindow(..m, content_attrs: a)
}

/// Sets the children rendered inside the window content area.
pub fn content_children(
  m: MockupWindow(msg),
  c: List(Element(msg)),
) -> MockupWindow(msg) {
  MockupWindow(..m, content_children: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `MockupWindow` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <div class="mockup-window [bg] [border border-base-300]" …attrs>
///   <div [class="border-t border-base-300"] …content_attrs>children</div>
/// </div>
/// ```
pub fn build(m: MockupWindow(msg)) -> Element(msg) {
  let outer_class =
    [
      Some("mockup-window"),
      m.bg,
      case m.bordered {
        True -> Some("border border-base-300")
        False -> None
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let inner_border_attrs = case m.bordered {
    True -> [attribute.class("border-t border-base-300")]
    False -> []
  }

  let inner_attrs = list.append(inner_border_attrs, m.content_attrs)

  html.div(
    [attribute.class(outer_class), ..m.attrs],
    [html.div(inner_attrs, m.content_children)],
  )
}
