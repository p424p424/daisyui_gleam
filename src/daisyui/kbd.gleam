/// A builder for DaisyUI kbd elements.
///
/// Kbd displays a keyboard key or shortcut key. It renders as
/// `<kbd class="kbd [size]">content</kbd>` and supports five size variants.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/kbd
///
/// // Single key
/// kbd.new("K") |> kbd.build
///
/// // Small key in running text
/// kbd.new("F") |> kbd.sm |> kbd.build
///
/// // Key combination — compose multiple kbd elements inline
/// [kbd.new("ctrl") |> kbd.build,
///  html.text(" + "),
///  kbd.new("shift") |> kbd.build,
///  html.text(" + "),
///  kbd.new("del") |> kbd.build]
/// ```
///
/// ## Reference
/// - [DaisyUI kbd](https://daisyui.com/components/kbd/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder for a keyboard key element.
pub opaque type Kbd(msg) {
  Kbd(
    content: String,
    size: Option(String),
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Kbd` builder with the given key label.
///
/// ```gleam
/// kbd.new("⌘") |> kbd.build
/// kbd.new("ctrl") |> kbd.build
/// kbd.new("F") |> kbd.sm |> kbd.build
/// ```
pub fn new(content: String) -> Kbd(msg) {
  Kbd(content: content, size: None, attrs: [])
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Applies the `kbd-xs` size modifier — extra small.
pub fn xs(k: Kbd(msg)) -> Kbd(msg) {
  Kbd(..k, size: Some("kbd-xs"))
}

/// Applies the `kbd-sm` size modifier — small.
pub fn sm(k: Kbd(msg)) -> Kbd(msg) {
  Kbd(..k, size: Some("kbd-sm"))
}

/// Applies the `kbd-md` size modifier — medium (default).
pub fn md(k: Kbd(msg)) -> Kbd(msg) {
  Kbd(..k, size: Some("kbd-md"))
}

/// Applies the `kbd-lg` size modifier — large.
pub fn lg(k: Kbd(msg)) -> Kbd(msg) {
  Kbd(..k, size: Some("kbd-lg"))
}

/// Applies the `kbd-xl` size modifier — extra large.
pub fn xl(k: Kbd(msg)) -> Kbd(msg) {
  Kbd(..k, size: Some("kbd-xl"))
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<kbd>` element.
pub fn attrs(k: Kbd(msg), a: List(Attribute(msg))) -> Kbd(msg) {
  Kbd(..k, attrs: a)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Kbd` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <kbd class="kbd [size]" …attrs>content</kbd>
/// ```
///
/// Always call this at the end of a builder chain.
pub fn build(k: Kbd(msg)) -> Element(msg) {
  let class =
    [Some("kbd"), k.size]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.kbd([attribute.class(class), ..k.attrs], [html.text(k.content)])
}
