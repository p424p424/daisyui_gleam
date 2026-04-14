/// A builder for DaisyUI link elements.
///
/// Tailwind CSS resets link underlines by default. The `link` class restores
/// them. The `link-hover` style shows the underline only on hover, and eight
/// colour modifiers let you match the link to your design system.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/link
///
/// link.new("Click me") |> link.build
/// link.new("Learn more") |> link.primary |> link.build
/// link.new("Terms") |> link.hover |> link.build
/// ```
///
/// ## Reference
/// - [DaisyUI link](https://daisyui.com/components/link/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder for a link element.
pub opaque type Link(msg) {
  Link(
    text: String,
    color: Option(String),
    hover_only: Bool,
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Link` builder with the given label text.
///
/// ```gleam
/// link.new("Click me") |> link.build
/// ```
pub fn new(text: String) -> Link(msg) {
  Link(text: text, color: None, hover_only: False, attrs: [])
}

// ---------------------------------------------------------------------------
// Hover style
// ---------------------------------------------------------------------------

/// Shows the underline only on hover — adds `link-hover`.
///
/// ```gleam
/// link.new("Terms of service") |> link.hover |> link.build
/// ```
pub fn hover(l: Link(msg)) -> Link(msg) {
  Link(..l, hover_only: True)
}

// ---------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------

/// Applies the `link-neutral` colour modifier.
pub fn neutral(l: Link(msg)) -> Link(msg) {
  Link(..l, color: Some("link-neutral"))
}

/// Applies the `link-primary` colour modifier.
pub fn primary(l: Link(msg)) -> Link(msg) {
  Link(..l, color: Some("link-primary"))
}

/// Applies the `link-secondary` colour modifier.
pub fn secondary(l: Link(msg)) -> Link(msg) {
  Link(..l, color: Some("link-secondary"))
}

/// Applies the `link-accent` colour modifier.
pub fn accent(l: Link(msg)) -> Link(msg) {
  Link(..l, color: Some("link-accent"))
}

/// Applies the `link-success` colour modifier.
pub fn success(l: Link(msg)) -> Link(msg) {
  Link(..l, color: Some("link-success"))
}

/// Applies the `link-info` colour modifier.
pub fn info(l: Link(msg)) -> Link(msg) {
  Link(..l, color: Some("link-info"))
}

/// Applies the `link-warning` colour modifier.
pub fn warning(l: Link(msg)) -> Link(msg) {
  Link(..l, color: Some("link-warning"))
}

/// Applies the `link-error` colour modifier.
pub fn error(l: Link(msg)) -> Link(msg) {
  Link(..l, color: Some("link-error"))
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<a>` element.
///
/// Use this for `href`, `target`, event handlers, etc.:
///
/// ```gleam
/// link.new("DaisyUI docs")
/// |> link.primary
/// |> link.attrs([attribute.href("https://daisyui.com"), attribute.target("_blank")])
/// |> link.build
/// ```
pub fn attrs(l: Link(msg), a: List(Attribute(msg))) -> Link(msg) {
  Link(..l, attrs: a)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Link` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <a class="link [link-hover] [link-color]" …attrs>text</a>
/// ```
///
/// Always call this at the end of a builder chain.
pub fn build(l: Link(msg)) -> Element(msg) {
  let hover_class = case l.hover_only {
    True -> Some("link-hover")
    False -> None
  }
  let class =
    [Some("link"), hover_class, l.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.a([attribute.class(class), ..l.attrs], [html.text(l.text)])
}
