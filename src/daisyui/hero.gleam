/// A builder for DaisyUI hero elements.
///
/// The hero component is a full-width section for displaying a large title,
/// description, and call-to-action. It supports a plain background colour,
/// a background image with an optional overlay, and flexible content layout
/// via the `hero-content` wrapper.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/hero
/// import lustre/attribute
/// import lustre/element/html
///
/// // Centered hero
/// hero.new()
/// |> hero.attrs([attribute.class("bg-base-200 min-h-screen")])
/// |> hero.children([
///   hero.content([attribute.class("text-center")], [
///     html.div([attribute.class("max-w-md")], [
///       html.h1([attribute.class("text-5xl font-bold")], [html.text("Hello there")]),
///       html.p([attribute.class("py-6")], [html.text("…")]),
///       html.button([attribute.class("btn btn-primary")], [html.text("Get Started")]),
///     ]),
///   ]),
/// ])
/// |> hero.build
///
/// // Hero with background image and overlay
/// hero.new()
/// |> hero.bg_image("url('/my-image.webp')")
/// |> hero.overlay
/// |> hero.children([
///   hero.content([attribute.class("text-neutral-content text-center")], […]),
/// ])
/// |> hero.build
/// ```
///
/// ## Reference
/// - [DaisyUI hero](https://daisyui.com/components/hero/)
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates hero configuration before being
/// converted to a Lustre element by `build/1`.
pub opaque type Hero(msg) {
  Hero(
    bg_image: Option(String),
    overlay: Bool,
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Hero` builder with no background image, no overlay,
/// no extra attributes, and no children.
///
/// ```gleam
/// hero.new()
/// |> hero.attrs([attribute.class("bg-base-200 min-h-screen")])
/// |> hero.children([…])
/// |> hero.build
/// ```
pub fn new() -> Hero(msg) {
  Hero(bg_image: None, overlay: False, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Background image
// ---------------------------------------------------------------------------

/// Sets a CSS `background-image` on the hero container.
///
/// Pass a full CSS value string, e.g. `"url('/photo.webp')"`.
///
/// ```gleam
/// hero.new()
/// |> hero.bg_image("url('/hero-bg.webp')")
/// |> hero.build
/// ```
pub fn bg_image(h: Hero(msg), url: String) -> Hero(msg) {
  Hero(..h, bg_image: Some(url))
}

// ---------------------------------------------------------------------------
// Overlay
// ---------------------------------------------------------------------------

/// Adds a `<div class="hero-overlay">` before the content.
///
/// Used together with `bg_image/2` to darken the background image.
///
/// ```gleam
/// hero.new()
/// |> hero.bg_image("url('/photo.webp')")
/// |> hero.overlay
/// |> hero.children([…])
/// |> hero.build
/// ```
pub fn overlay(h: Hero(msg)) -> Hero(msg) {
  Hero(..h, overlay: True)
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<div class="hero">`.
///
/// Use this for background colour, min-height, and other Tailwind utilities:
///
/// ```gleam
/// hero.new()
/// |> hero.attrs([attribute.class("bg-base-200 min-h-screen")])
/// |> hero.build
/// ```
pub fn attrs(h: Hero(msg), a: List(Attribute(msg))) -> Hero(msg) {
  Hero(..h, attrs: a)
}

/// Sets the child elements rendered inside the hero container (after the
/// optional overlay).
///
/// Typically a single `hero.content(…)` element.
///
/// ```gleam
/// hero.new()
/// |> hero.children([
///   hero.content([attribute.class("text-center")], […]),
/// ])
/// |> hero.build
/// ```
pub fn children(h: Hero(msg), c: List(Element(msg))) -> Hero(msg) {
  Hero(..h, children: c)
}

// ---------------------------------------------------------------------------
// Content helper
// ---------------------------------------------------------------------------

/// Renders a `<div class="hero-content" …attrs>children</div>` element.
///
/// Use `attrs` for layout modifiers such as `"flex-col lg:flex-row"` or
/// `"text-center"`.
///
/// ```gleam
/// hero.content([attribute.class("flex-col lg:flex-row")], [
///   html.img([attribute.src("…"), attribute.class("max-w-sm rounded-lg shadow-2xl")]),
///   html.div([], [
///     html.h1([attribute.class("text-5xl font-bold")], [html.text("Hello")]),
///   ]),
/// ])
/// ```
pub fn content(
  attrs: List(Attribute(msg)),
  children: List(Element(msg)),
) -> Element(msg) {
  html.div([attribute.class("hero-content"), ..attrs], children)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Hero` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <div class="hero" [style="background-image: …;"] …attrs>
///   [<div class="hero-overlay"></div>]
///   …children
/// </div>
/// ```
///
/// Always call this at the end of a builder chain.
///
/// ## Reference
/// - [DaisyUI hero](https://daisyui.com/components/hero/)
pub fn build(h: Hero(msg)) -> Element(msg) {
  let bg_attr = case h.bg_image {
    Some(url) -> [attribute.attribute("style", "background-image: " <> url <> ";")]
    None -> []
  }
  let overlay_el = case h.overlay {
    True -> [html.div([attribute.class("hero-overlay")], [])]
    False -> []
  }
  html.div(
    [attribute.class("hero"), ..list.append(bg_attr, h.attrs)],
    list.append(overlay_el, h.children),
  )
}
