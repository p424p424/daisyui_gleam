/// A builder for DaisyUI navbar elements.
///
/// Navbar provides a horizontal navigation bar. Its children are typically
/// `navbar.start`, `navbar.center`, and `navbar.end` divs that split the
/// bar into layout zones, though any content works.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/navbar
/// import lustre/element/html
/// import lustre/attribute
///
/// // Simple title-only navbar
/// navbar.new()
/// |> navbar.bg("bg-base-100")
/// |> navbar.children([
///   html.a([attribute.class("btn btn-ghost text-xl")], [html.text("daisyUI")]),
/// ])
/// |> navbar.build
///
/// // Navbar with start / center / end zones
/// navbar.new()
/// |> navbar.bg("bg-base-100")
/// |> navbar.children([
///   navbar.start([html.a([attribute.class("btn btn-ghost text-xl")], [html.text("daisyUI")])]),
///   navbar.center([...]),
///   navbar.end([...]),
/// ])
/// |> navbar.build
/// ```
///
/// ## Reference
/// - [DaisyUI navbar](https://daisyui.com/components/navbar/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Navbar(msg) {
  Navbar(
    bg: Option(String),
    color: Option(String),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Navbar` builder with no background or colour override.
pub fn new() -> Navbar(msg) {
  Navbar(bg: None, color: None, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Styling
// ---------------------------------------------------------------------------

/// Sets the background utility class, e.g. `"bg-base-100"`, `"bg-primary"`,
/// `"bg-neutral"`.
pub fn bg(n: Navbar(msg), class: String) -> Navbar(msg) {
  Navbar(..n, bg: Some(class))
}

/// Sets the text colour utility class, e.g. `"text-primary-content"`,
/// `"text-neutral-content"`.
pub fn color(n: Navbar(msg), class: String) -> Navbar(msg) {
  Navbar(..n, color: Some(class))
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<div class="navbar">`.
pub fn attrs(n: Navbar(msg), a: List(Attribute(msg))) -> Navbar(msg) {
  Navbar(..n, attrs: a)
}

/// Sets the children of the navbar.
pub fn children(n: Navbar(msg), c: List(Element(msg))) -> Navbar(msg) {
  Navbar(..n, children: c)
}

// ---------------------------------------------------------------------------
// Zone helpers
// ---------------------------------------------------------------------------

/// Renders `<div class="navbar-start">children</div>`.
///
/// Fills the first 50% of the navbar width.
pub fn start(c: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("navbar-start")], c)
}

/// Renders `<div class="navbar-center">children</div>`.
///
/// Centres content horizontally in the navbar.
pub fn center(c: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("navbar-center")], c)
}

/// Renders `<div class="navbar-end">children</div>`.
///
/// Fills the second 50% of the navbar width (right side).
pub fn end(c: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("navbar-end")], c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Navbar` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <div class="navbar [bg] [color]" …attrs>children</div>
/// ```
pub fn build(n: Navbar(msg)) -> Element(msg) {
  let class =
    [Some("navbar"), n.bg, n.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.div([attribute.class(class), ..n.attrs], n.children)
}
