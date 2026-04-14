/// A builder for DaisyUI join (group items) elements.
///
/// Join groups multiple items — buttons, inputs, selects, etc. — and applies
/// border radius only to the first and last child, creating a seamless
/// connected group. Items can flow horizontally (default) or vertically.
///
/// Apply `class="join-item"` directly to each child element to opt it into
/// the group styling. The `join-item` class works even when the item is not
/// a direct child of the join container.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/join
/// import lustre/attribute
/// import lustre/element/html
///
/// join.new()
/// |> join.children([
///   html.button([attribute.class("btn join-item")], [html.text("One")]),
///   html.button([attribute.class("btn join-item")], [html.text("Two")]),
///   html.button([attribute.class("btn join-item")], [html.text("Three")]),
/// ])
/// |> join.build
/// ```
///
/// ## Reference
/// - [DaisyUI join](https://daisyui.com/components/join/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// Direction of the join group.
///
/// | Variant      | Class              | Effect                       |
/// |--------------|--------------------|------------------------------|
/// | `Horizontal` | `join-horizontal`  | Items placed side by side    |
/// | `Vertical`   | `join-vertical`    | Items stacked vertically     |
pub type JoinDirection {
  /// Items placed side by side — `join-horizontal`.
  Horizontal
  /// Items stacked vertically — `join-vertical`.
  Vertical
}

/// An opaque builder that accumulates join configuration before being
/// converted to a Lustre element by `build/1`.
pub opaque type Join(msg) {
  Join(
    direction: Option(JoinDirection),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Join` builder with no direction modifier (horizontal by
/// default in DaisyUI), no extra attributes, and no children.
///
/// ```gleam
/// join.new()
/// |> join.children([
///   html.button([attribute.class("btn join-item")], [html.text("A")]),
///   html.button([attribute.class("btn join-item")], [html.text("B")]),
/// ])
/// |> join.build
/// ```
pub fn new() -> Join(msg) {
  Join(direction: None, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Stacks items vertically — adds `join-vertical`.
///
/// ```gleam
/// join.new()
/// |> join.vertical
/// |> join.children([…])
/// |> join.build
/// ```
pub fn vertical(j: Join(msg)) -> Join(msg) {
  Join(..j, direction: Some(Vertical))
}

/// Places items side by side — adds `join-horizontal`.
///
/// DaisyUI's default behaviour; call this only when overriding a previously
/// set `vertical/1`.
pub fn horizontal(j: Join(msg)) -> Join(msg) {
  Join(..j, direction: Some(Horizontal))
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<div class="join …">`.
///
/// Use this for responsive direction modifiers or other Tailwind utilities:
///
/// ```gleam
/// // Vertical on small screens, horizontal on large
/// join.new()
/// |> join.vertical
/// |> join.attrs([attribute.class("lg:join-horizontal")])
/// |> join.children([…])
/// |> join.build
/// ```
pub fn attrs(j: Join(msg), a: List(Attribute(msg))) -> Join(msg) {
  Join(..j, attrs: a)
}

/// Sets the child elements of the join group.
///
/// Add `class="join-item"` to each child that should participate in the
/// grouped border-radius treatment. Children that don't have `join-item`
/// act as transparent wrappers — `join-item` on a nested element still works.
///
/// ```gleam
/// join.new()
/// |> join.children([
///   html.input([attribute.class("input join-item"), attribute.placeholder("Search")]),
///   html.button([attribute.class("btn btn-primary join-item")], [html.text("Go")]),
/// ])
/// |> join.build
/// ```
pub fn children(j: Join(msg), c: List(Element(msg))) -> Join(msg) {
  Join(..j, children: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Join` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <div class="join [join-vertical|join-horizontal]" …attrs>
///   …children
/// </div>
/// ```
///
/// Always call this at the end of a builder chain.
///
/// ## Reference
/// - [DaisyUI join](https://daisyui.com/components/join/)
pub fn build(j: Join(msg)) -> Element(msg) {
  let direction_class = case j.direction {
    Some(Vertical) -> Some("join-vertical")
    Some(Horizontal) -> Some("join-horizontal")
    None -> None
  }
  let class =
    [Some("join"), direction_class]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.div([attribute.class(class), ..j.attrs], j.children)
}
