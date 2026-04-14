/// A builder for DaisyUI text-rotate elements.
///
/// Text Rotate cycles through up to 6 `<span>` items with an infinite loop
/// animation (10 s by default). The animation pauses on hover.
///
/// ## Structure
///
/// ```html
/// <span class="text-rotate [extra]">
///   <span [inner-attrs]>
///     <span>ONE</span>
///     <span>TWO</span>
///   </span>
/// </span>
/// ```
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/text_rotate
///
/// // Basic
/// text_rotate.new()
/// |> text_rotate.items([
///   text_rotate.item("ONE"),
///   text_rotate.item("TWO"),
///   text_rotate.item("THREE"),
/// ])
/// |> text_rotate.build
///
/// // Big, centred, 6-second cycle
/// text_rotate.new()
/// |> text_rotate.attrs([attribute.class("text-7xl duration-6000")])
/// |> text_rotate.inner_attrs([attribute.class("justify-items-center")])
/// |> text_rotate.items([
///   text_rotate.item("BLAZING"),
///   text_rotate.item_el([attribute.class("font-bold italic")], [html.text("FAST")]),
/// ])
/// |> text_rotate.build
/// ```
///
/// ## Reference
/// - [DaisyUI text-rotate](https://daisyui.com/components/text-rotate/)
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type TextRotate(msg) {
  TextRotate(
    attrs: List(Attribute(msg)),
    inner_attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `TextRotate` builder.
pub fn new() -> TextRotate(msg) {
  TextRotate(attrs: [], inner_attrs: [], items: [])
}

// ---------------------------------------------------------------------------
// Modifiers
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<span class="text-rotate">`.
///
/// Use this for sizing (`text-7xl`), duration (`duration-6000`), line-height
/// (`leading-[2]`), or any other Tailwind utilities.
pub fn attrs(t: TextRotate(msg), a: List(Attribute(msg))) -> TextRotate(msg) {
  TextRotate(..t, attrs: a)
}

/// Merges additional Lustre attributes onto the inner grouping `<span>`.
///
/// Use `[attribute.class("justify-items-center")]` to centre items.
pub fn inner_attrs(
  t: TextRotate(msg),
  a: List(Attribute(msg)),
) -> TextRotate(msg) {
  TextRotate(..t, inner_attrs: a)
}

/// Sets the list of item `<span>` elements to rotate through (up to 6).
///
/// Build each item with `item/1` or `item_el/2`.
pub fn items(t: TextRotate(msg), is: List(Element(msg))) -> TextRotate(msg) {
  TextRotate(..t, items: is)
}

// ---------------------------------------------------------------------------
// Item helpers
// ---------------------------------------------------------------------------

/// Creates a plain `<span>text</span>` rotation item.
pub fn item(text: String) -> Element(msg) {
  html.span([], [html.text(text)])
}

/// Creates a `<span attrs>children</span>` rotation item with custom attrs/content.
pub fn item_el(
  a: List(Attribute(msg)),
  children: List(Element(msg)),
) -> Element(msg) {
  html.span(a, children)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `TextRotate` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <span class="text-rotate" …attrs>
///   <span …inner_attrs>
///     items…
///   </span>
/// </span>
/// ```
pub fn build(t: TextRotate(msg)) -> Element(msg) {
  html.span(
    [attribute.class("text-rotate"), ..t.attrs],
    [html.span(t.inner_attrs, t.items)],
  )
}
