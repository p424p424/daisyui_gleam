/// A builder for DaisyUI hover-3d elements.
///
/// The hover-3d component wraps content in a container that applies a smooth
/// 3D tilt effect as the user moves their mouse over it. The effect is driven
/// by 8 invisible overlay divs that detect mouse position — this builder
/// appends them automatically so callers never need to add them manually.
///
/// > **Content restriction** — only use non-interactive content inside the
/// > wrapper. If you need the whole card to be clickable, pass an `href` via
/// > `link/2` to render the wrapper as an `<a>` instead of a `<div>`.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/hover_3d
/// import lustre/element/html
/// import lustre/attribute
///
/// // Image card
/// hover_3d.new()
/// |> hover_3d.children([
///   html.figure([attribute.class("max-w-100 rounded-2xl")], [
///     html.img([attribute.src("/card.webp"), attribute.alt("3D card")]),
///   ]),
/// ])
/// |> hover_3d.build
///
/// // Fully clickable card (rendered as <a>)
/// hover_3d.new()
/// |> hover_3d.link("#")
/// |> hover_3d.attrs([attribute.class("cursor-pointer")])
/// |> hover_3d.children([…])
/// |> hover_3d.build
/// ```
///
/// ## Reference
/// - [DaisyUI hover-3d](https://daisyui.com/components/hover-3d/)
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates hover-3d configuration before being
/// converted to a Lustre element by `build/1`.
pub opaque type Hover3d(msg) {
  Hover3d(
    link: Option(String),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Hover3d` builder that renders as a `<div class="hover-3d">`.
///
/// ```gleam
/// hover_3d.new()
/// |> hover_3d.children([…])
/// |> hover_3d.build
/// ```
pub fn new() -> Hover3d(msg) {
  Hover3d(link: None, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Link variant
// ---------------------------------------------------------------------------

/// Renders the wrapper as `<a class="hover-3d" href="…">` instead of a div.
///
/// Use this when the entire card should be a clickable link. Do **not** place
/// interactive elements (buttons, links) inside the wrapper when using this —
/// nested interactive elements are invalid HTML and break accessibility.
///
/// ```gleam
/// hover_3d.new()
/// |> hover_3d.link("/product/42")
/// |> hover_3d.children([…])
/// |> hover_3d.build
/// ```
pub fn link(h: Hover3d(msg), href: String) -> Hover3d(msg) {
  Hover3d(..h, link: Some(href))
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the wrapper element.
///
/// ```gleam
/// hover_3d.new()
/// |> hover_3d.attrs([attribute.class("my-12 mx-2 cursor-pointer")])
/// |> hover_3d.build
/// ```
pub fn attrs(h: Hover3d(msg), a: List(Attribute(msg))) -> Hover3d(msg) {
  Hover3d(..h, attrs: a)
}

/// Sets the content children rendered inside the wrapper.
///
/// The 8 overlay divs required for the 3D effect are appended automatically
/// by `build/1` — do not add them here.
///
/// ```gleam
/// hover_3d.new()
/// |> hover_3d.children([
///   html.figure([attribute.class("w-60 rounded-2xl")], [
///     html.img([attribute.src("/photo.webp"), attribute.alt("…")]),
///   ]),
/// ])
/// |> hover_3d.build
/// ```
pub fn children(h: Hover3d(msg), c: List(Element(msg))) -> Hover3d(msg) {
  Hover3d(..h, children: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Hover3d` builder into a Lustre `Element(msg)`.
///
/// Renders the wrapper with `class="hover-3d"` and automatically appends
/// the 8 empty divs required for the 3D hover effect:
///
/// ```html
/// <div class="hover-3d" …attrs>
///   …children
///   <div></div> × 8
/// </div>
/// ```
///
/// Or, when `link/2` is used:
///
/// ```html
/// <a class="hover-3d" href="…" …attrs>
///   …children
///   <div></div> × 8
/// </a>
/// ```
///
/// Always call this at the end of a builder chain.
///
/// ## Reference
/// - [DaisyUI hover-3d](https://daisyui.com/components/hover-3d/)
pub fn build(h: Hover3d(msg)) -> Element(msg) {
  let overlay_divs =
    list.repeat(html.div([], []), 8)
  let all_children = list.append(h.children, overlay_divs)

  case h.link {
    None ->
      html.div([attribute.class("hover-3d"), ..h.attrs], all_children)
    Some(href) ->
      html.a(
        [attribute.class("hover-3d"), attribute.href(href), ..h.attrs],
        all_children,
      )
  }
}
