/// A builder for DaisyUI loading elements.
///
/// Loading shows an animated indicator that something is in progress.
/// Six animation styles, five sizes, and eight colour variants are available.
/// Colour is applied via Tailwind's `text-*` utilities.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/loading
///
/// // Default spinner, medium size
/// loading.new() |> loading.build
///
/// // Small dots, primary colour
/// loading.new() |> loading.dots |> loading.sm |> loading.primary |> loading.build
/// ```
///
/// ## Reference
/// - [DaisyUI loading](https://daisyui.com/components/loading/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// Animation style for the loading indicator.
pub type LoadingStyle {
  Spinner
  Dots
  Ring
  Ball
  Bars
  Infinity
}

/// An opaque builder for a loading indicator element.
pub opaque type Loading(msg) {
  Loading(
    style: Option(LoadingStyle),
    size: Option(String),
    color: Option(String),
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Loading` builder with no style (renders bare `loading` class),
/// default size, and no colour.
///
/// Chain one of the style setters (`spinner`, `dots`, etc.) to choose an
/// animation:
///
/// ```gleam
/// loading.new() |> loading.spinner |> loading.build
/// ```
pub fn new() -> Loading(msg) {
  Loading(style: None, size: None, color: None, attrs: [])
}

// ---------------------------------------------------------------------------
// Styles
// ---------------------------------------------------------------------------

/// Spinner animation — `loading-spinner`.
pub fn spinner(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style: Some(Spinner))
}

/// Dots animation — `loading-dots`.
pub fn dots(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style: Some(Dots))
}

/// Ring animation — `loading-ring`.
pub fn ring(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style: Some(Ring))
}

/// Ball animation — `loading-ball`.
pub fn ball(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style: Some(Ball))
}

/// Bars animation — `loading-bars`.
pub fn bars(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style: Some(Bars))
}

/// Infinity animation — `loading-infinity`.
pub fn infinity(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style: Some(Infinity))
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Extra small size — `loading-xs`.
pub fn xs(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, size: Some("loading-xs"))
}

/// Small size — `loading-sm`.
pub fn sm(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, size: Some("loading-sm"))
}

/// Medium size — `loading-md` (default).
pub fn md(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, size: Some("loading-md"))
}

/// Large size — `loading-lg`.
pub fn lg(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, size: Some("loading-lg"))
}

/// Extra large size — `loading-xl`.
pub fn xl(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, size: Some("loading-xl"))
}

// ---------------------------------------------------------------------------
// Colors  (Tailwind text-* utilities)
// ---------------------------------------------------------------------------

/// Colours the indicator with `text-primary`.
pub fn primary(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, color: Some("text-primary"))
}

/// Colours the indicator with `text-secondary`.
pub fn secondary(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, color: Some("text-secondary"))
}

/// Colours the indicator with `text-accent`.
pub fn accent(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, color: Some("text-accent"))
}

/// Colours the indicator with `text-neutral`.
pub fn neutral(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, color: Some("text-neutral"))
}

/// Colours the indicator with `text-info`.
pub fn info(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, color: Some("text-info"))
}

/// Colours the indicator with `text-success`.
pub fn success(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, color: Some("text-success"))
}

/// Colours the indicator with `text-warning`.
pub fn warning(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, color: Some("text-warning"))
}

/// Colours the indicator with `text-error`.
pub fn error(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, color: Some("text-error"))
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<span class="loading …">`.
pub fn attrs(l: Loading(msg), a: List(Attribute(msg))) -> Loading(msg) {
  Loading(..l, attrs: a)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Loading` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <span class="loading [loading-spinner|…] [loading-xs|…] [text-primary|…]" …attrs></span>
/// ```
pub fn build(l: Loading(msg)) -> Element(msg) {
  let style_class = case l.style {
    Some(Spinner) -> Some("loading-spinner")
    Some(Dots) -> Some("loading-dots")
    Some(Ring) -> Some("loading-ring")
    Some(Ball) -> Some("loading-ball")
    Some(Bars) -> Some("loading-bars")
    Some(Infinity) -> Some("loading-infinity")
    None -> None
  }
  let class =
    [Some("loading"), style_class, l.size, l.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.span([attribute.class(class), ..l.attrs], [])
}
