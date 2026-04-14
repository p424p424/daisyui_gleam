/// A builder for DaisyUI toast elements.
///
/// Toast stacks children (typically `<div class="alert …">`) in a fixed
/// corner of the page.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/toast
/// import lustre/element/html
///
/// // Bottom-end (default)
/// toast.new()
/// |> toast.children([
///   html.div([attribute.class("alert alert-info")], [html.text("New message.")]),
/// ])
/// |> toast.build
///
/// // Top-center
/// toast.new()
/// |> toast.top
/// |> toast.center
/// |> toast.children([…])
/// |> toast.build
/// ```
///
/// ## Reference
/// - [DaisyUI toast](https://daisyui.com/components/toast/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Toast(msg) {
  Toast(
    horiz: Option(String),
    vert: Option(String),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Toast` builder.
/// Defaults to `toast-end` + `toast-bottom` (DaisyUI defaults).
pub fn new() -> Toast(msg) {
  Toast(horiz: None, vert: None, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Horizontal placement
// ---------------------------------------------------------------------------

/// Align to the left — `toast-start`.
pub fn start(t: Toast(msg)) -> Toast(msg) {
  Toast(..t, horiz: Some("toast-start"))
}

/// Align to the centre — `toast-center`.
pub fn center(t: Toast(msg)) -> Toast(msg) {
  Toast(..t, horiz: Some("toast-center"))
}

/// Align to the right — `toast-end` (default).
pub fn end(t: Toast(msg)) -> Toast(msg) {
  Toast(..t, horiz: Some("toast-end"))
}

// ---------------------------------------------------------------------------
// Vertical placement
// ---------------------------------------------------------------------------

/// Align to the top — `toast-top`.
pub fn top(t: Toast(msg)) -> Toast(msg) {
  Toast(..t, vert: Some("toast-top"))
}

/// Align to the middle — `toast-middle`.
pub fn middle(t: Toast(msg)) -> Toast(msg) {
  Toast(..t, vert: Some("toast-middle"))
}

/// Align to the bottom — `toast-bottom` (default).
pub fn bottom(t: Toast(msg)) -> Toast(msg) {
  Toast(..t, vert: Some("toast-bottom"))
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<div class="toast …">`.
pub fn attrs(t: Toast(msg), a: List(Attribute(msg))) -> Toast(msg) {
  Toast(..t, attrs: a)
}

/// Sets the children (typically `<div class="alert …">` elements).
pub fn children(t: Toast(msg), c: List(Element(msg))) -> Toast(msg) {
  Toast(..t, children: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Toast` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <div class="toast [toast-start|toast-center|toast-end] [toast-top|toast-middle|toast-bottom]" …attrs>
///   children
/// </div>
/// ```
pub fn build(t: Toast(msg)) -> Element(msg) {
  let class =
    [Some("toast"), t.horiz, t.vert]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.div([attribute.class(class), ..t.attrs], t.children)
}
