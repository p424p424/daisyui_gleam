/// Helpers for DaisyUI skeleton loading placeholders.
///
/// Skeleton components show an animated placeholder while content loads.
/// There is no builder — just two lightweight functions that render the
/// most common variants directly.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/skeleton
/// import lustre/attribute
///
/// // Square / rectangle placeholder
/// skeleton.box([attribute.class("h-32 w-32")])
///
/// // Circular avatar placeholder
/// skeleton.box([attribute.class("h-16 w-16 rounded-full shrink-0")])
///
/// // Animated gradient text
/// skeleton.text("AI is thinking harder...")
/// ```
///
/// ## Reference
/// - [DaisyUI skeleton](https://daisyui.com/components/skeleton/)
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

/// Renders `<div class="skeleton" …attrs></div>`.
///
/// Pass sizing and shape utilities via `attrs`:
/// ```gleam
/// skeleton.box([attribute.class("h-32 w-full")])
/// skeleton.box([attribute.class("h-16 w-16 rounded-full shrink-0")])
/// ```
pub fn box(attrs: List(Attribute(msg))) -> Element(msg) {
  html.div([attribute.class("skeleton"), ..attrs], [])
}

/// Renders `<span class="skeleton skeleton-text">text</span>`.
///
/// Animates the text colour with a shimmer gradient — useful for "AI
/// thinking" indicators or other inline loading states.
pub fn text(content: String) -> Element(msg) {
  html.span([attribute.class("skeleton skeleton-text")], [html.text(content)])
}
