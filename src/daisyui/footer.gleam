/// A builder for DaisyUI footer elements.
///
/// The footer component is a layout container for site footers. It uses a
/// CSS grid layout to arrange columns of navigation links, aside content,
/// and other sections.
///
/// There are two direction modifiers:
/// - **Vertical** (default) — columns stacked vertically
/// - **Horizontal** — columns placed side by side
///
/// Use `footer-center` to center all content within the footer.
///
/// Section titles (the `footer-title` class) are rendered using the `title/1`
/// helper, which produces a `<h6 class="footer-title">` element.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/footer
/// import lustre/element/html
/// import lustre/attribute
///
/// footer.new()
/// |> footer.attrs([attribute.class("bg-neutral text-neutral-content p-10")])
/// |> footer.children([
///   html.nav([], [
///     footer.title("Services"),
///     html.a([attribute.class("link link-hover")], [html.text("Branding")]),
///     html.a([attribute.class("link link-hover")], [html.text("Design")]),
///   ]),
/// ])
/// |> footer.build
/// ```
///
/// ## Reference
/// - [DaisyUI footer](https://daisyui.com/components/footer/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// The direction modifier for the footer layout.
///
/// | Variant      | Class               | Effect                             |
/// |--------------|---------------------|------------------------------------|
/// | `Horizontal` | `footer-horizontal` | Columns placed side by side        |
/// | `Vertical`   | `footer-vertical`   | Columns stacked vertically         |
pub type FooterDirection {
  /// Columns placed side by side — `footer-horizontal`.
  Horizontal
  /// Columns stacked vertically — `footer-vertical`.
  Vertical
}

/// An opaque builder that accumulates footer configuration before being
/// converted to a Lustre element by `build/1`.
pub opaque type Footer(msg) {
  Footer(
    center: Bool,
    direction: Option(FooterDirection),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Footer` builder with no direction modifier, no centering,
/// no extra attributes, and no children.
///
/// ```gleam
/// footer.new()
/// |> footer.children([…])
/// |> footer.build
/// ```
pub fn new() -> Footer(msg) {
  Footer(center: False, direction: None, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Adds the `footer-horizontal` class — columns placed side by side.
///
/// ## Reference
/// - [DaisyUI footer](https://daisyui.com/components/footer/)
pub fn horizontal(f: Footer(msg)) -> Footer(msg) {
  Footer(..f, direction: Some(Horizontal))
}

/// Adds the `footer-vertical` class — columns stacked vertically.
///
/// This is DaisyUI's default rendering; use this only when explicitly
/// overriding a previously set `horizontal/1`.
///
/// ## Reference
/// - [DaisyUI footer](https://daisyui.com/components/footer/)
pub fn vertical(f: Footer(msg)) -> Footer(msg) {
  Footer(..f, direction: Some(Vertical))
}

// ---------------------------------------------------------------------------
// Placement
// ---------------------------------------------------------------------------

/// Adds the `footer-center` class — centers all footer content.
///
/// ```gleam
/// footer.new()
/// |> footer.horizontal
/// |> footer.center
/// |> footer.children([…])
/// |> footer.build
/// ```
///
/// ## Reference
/// - [DaisyUI footer](https://daisyui.com/components/footer/)
pub fn center(f: Footer(msg)) -> Footer(msg) {
  Footer(..f, center: True)
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<footer>` element.
///
/// Use this for background colour, padding, and other Tailwind utilities:
///
/// ```gleam
/// footer.new()
/// |> footer.attrs([attribute.class("bg-neutral text-neutral-content p-10")])
/// |> footer.build
/// ```
pub fn attrs(f: Footer(msg), a: List(Attribute(msg))) -> Footer(msg) {
  Footer(..f, attrs: a)
}

/// Sets the child elements of the footer.
///
/// Typically a list of `<nav>`, `<aside>`, or `<form>` elements.
///
/// ```gleam
/// footer.new()
/// |> footer.children([
///   html.nav([], [footer.title("Services"), …]),
///   html.aside([], [html.text("© 2024 ACME")]),
/// ])
/// |> footer.build
/// ```
pub fn children(f: Footer(msg), c: List(Element(msg))) -> Footer(msg) {
  Footer(..f, children: c)
}

// ---------------------------------------------------------------------------
// Title helper
// ---------------------------------------------------------------------------

/// Renders a `<h6 class="footer-title">` element for use as a section header
/// inside a footer column.
///
/// ```gleam
/// html.nav([], [
///   footer.title("Services"),
///   html.a([attribute.class("link link-hover")], [html.text("Branding")]),
/// ])
/// ```
pub fn title(text: String) -> Element(msg) {
  html.h6([attribute.class("footer-title")], [html.text(text)])
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Footer` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <footer class="footer [footer-horizontal|footer-vertical] [footer-center]" …attrs>
///   …children
/// </footer>
/// ```
///
/// Always call this at the end of a builder chain.
///
/// ## Reference
/// - [DaisyUI footer](https://daisyui.com/components/footer/)
pub fn build(f: Footer(msg)) -> Element(msg) {
  let direction_class = case f.direction {
    Some(Horizontal) -> Some("footer-horizontal")
    Some(Vertical) -> Some("footer-vertical")
    None -> None
  }
  let center_class = case f.center {
    True -> Some("footer-center")
    False -> None
  }
  let class =
    [Some("footer"), direction_class, center_class]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.footer([attribute.class(class), ..f.attrs], f.children)
}
