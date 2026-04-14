/// A builder for DaisyUI stack elements.
///
/// Stack visually places children on top of each other. Use `w-*` / `h-*`
/// utilities (via `attrs`) to give all items a uniform size.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/stack
/// import lustre/attribute
/// import lustre/element/html
///
/// stack.new()
/// |> stack.attrs([attribute.class("size-28")])
/// |> stack.children([
///   html.div([attribute.class("card bg-base-100 border")], [...]),
///   html.div([attribute.class("card bg-base-100 border")], [...]),
///   html.div([attribute.class("card bg-base-100 border")], [...]),
/// ])
/// |> stack.build
/// ```
///
/// ## Reference
/// - [DaisyUI stack](https://daisyui.com/components/stack/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Stack(msg) {
  Stack(
    align: Option(String),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Stack` builder with default (bottom) alignment.
pub fn new() -> Stack(msg) {
  Stack(align: None, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Alignment modifiers
// ---------------------------------------------------------------------------

/// Aligns children to the top — `stack-top`.
pub fn top(s: Stack(msg)) -> Stack(msg) {
  Stack(..s, align: Some("stack-top"))
}

/// Aligns children to the bottom (default) — `stack-bottom`.
pub fn bottom(s: Stack(msg)) -> Stack(msg) {
  Stack(..s, align: Some("stack-bottom"))
}

/// Aligns children to the start horizontally — `stack-start`.
pub fn start(s: Stack(msg)) -> Stack(msg) {
  Stack(..s, align: Some("stack-start"))
}

/// Aligns children to the end horizontally — `stack-end`.
pub fn end(s: Stack(msg)) -> Stack(msg) {
  Stack(..s, align: Some("stack-end"))
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<div class="stack">`.
///
/// Use this for sizing utilities: `attribute.class("size-28")`,
/// `attribute.class("h-20 w-32")`, etc.
pub fn attrs(s: Stack(msg), a: List(Attribute(msg))) -> Stack(msg) {
  Stack(..s, attrs: a)
}

/// Sets the children to layer inside the stack.
pub fn children(s: Stack(msg), c: List(Element(msg))) -> Stack(msg) {
  Stack(..s, children: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Stack` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <div class="stack [stack-top|stack-bottom|stack-start|stack-end]" …attrs>
///   children
/// </div>
/// ```
pub fn build(s: Stack(msg)) -> Element(msg) {
  let class =
    [Some("stack"), s.align]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.div([attribute.class(class), ..s.attrs], s.children)
}
