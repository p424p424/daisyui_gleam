/// Builders for DaisyUI list elements.
///
/// A list is a vertical layout for displaying information in rows. It
/// consists of two parts:
///
/// - **`List`** — the `<ul class="list">` container.
/// - **`ListRow`** — a `<li class="list-row">` item inside the list, which
///   uses a horizontal grid layout for its children.
///
/// Two modifier classes are applied directly to children of a row — they are
/// not part of either builder:
///
/// - `list-col-grow` — makes a child fill the remaining horizontal space
///   (by default the second child grows automatically).
/// - `list-col-wrap` — pushes a child to the next line, making it span the
///   full row width below the other children.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/list
/// import lustre/element/html
/// import lustre/attribute
///
/// list.new()
/// |> list.attrs([attribute.class("bg-base-100 rounded-box shadow-md")])
/// |> list.children([
///   list.row_new()
///   |> list.row_children([
///     html.div([], [html.img([attribute.src("/avatar.webp"),
///                            attribute.class("size-10 rounded-box")])]),
///     html.div([], [
///       html.div([], [html.text("Artist Name")]),
///       html.div([attribute.class("text-xs uppercase font-semibold opacity-60")],
///                [html.text("Song Title")]),
///     ]),
///     html.button([attribute.class("btn btn-square btn-ghost")], [play_icon()]),
///   ])
///   |> list.row_build,
/// ])
/// |> list.build
/// ```
///
/// ## Reference
/// - [DaisyUI list](https://daisyui.com/components/list/)
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// List container
// ---------------------------------------------------------------------------

/// An opaque builder for the `<ul class="list">` container.
pub opaque type DaisyList(msg) {
  DaisyList(attrs: List(Attribute(msg)), children: List(Element(msg)))
}

/// Creates a new `List` container builder.
///
/// ```gleam
/// list.new()
/// |> list.attrs([attribute.class("bg-base-100 rounded-box shadow-md")])
/// |> list.children([…row elements…])
/// |> list.build
/// ```
pub fn new() -> DaisyList(msg) {
  DaisyList(attrs: [], children: [])
}

/// Merges additional Lustre attributes onto the `<ul class="list">` element.
///
/// Use this for background colour, border radius, shadow, etc.:
///
/// ```gleam
/// list.new()
/// |> list.attrs([attribute.class("bg-base-100 rounded-box shadow-md")])
/// |> list.build
/// ```
pub fn attrs(l: DaisyList(msg), a: List(Attribute(msg))) -> DaisyList(msg) {
  DaisyList(..l, attrs: a)
}

/// Sets the children of the list container.
///
/// Children are typically `list.row_build/1` elements, but can also include
/// plain `<li>` elements for headers or dividers:
///
/// ```gleam
/// list.new()
/// |> list.children([
///   html.li([attribute.class("p-4 pb-2 text-xs opacity-60 tracking-wide")],
///           [html.text("Section title")]),
///   list.row_new() |> list.row_children([…]) |> list.row_build,
/// ])
/// |> list.build
/// ```
pub fn children(l: DaisyList(msg), c: List(Element(msg))) -> DaisyList(msg) {
  DaisyList(..l, children: c)
}

/// Converts the `List` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <ul class="list" …attrs>…children</ul>
/// ```
pub fn build(l: DaisyList(msg)) -> Element(msg) {
  html.ul([attribute.class("list"), ..l.attrs], l.children)
}

// ---------------------------------------------------------------------------
// List row
// ---------------------------------------------------------------------------

/// An opaque builder for a `<li class="list-row">` element.
pub opaque type DaisyListRow(msg) {
  DaisyListRow(attrs: List(Attribute(msg)), children: List(Element(msg)))
}

/// Creates a new `ListRow` builder.
///
/// ```gleam
/// list.row_new()
/// |> list.row_children([avatar, info_div, action_button])
/// |> list.row_build
/// ```
pub fn row_new() -> DaisyListRow(msg) {
  DaisyListRow(attrs: [], children: [])
}

/// Merges additional Lustre attributes onto the `<li class="list-row">`.
pub fn row_attrs(r: DaisyListRow(msg), a: List(Attribute(msg))) -> DaisyListRow(msg) {
  DaisyListRow(..r, attrs: a)
}

/// Sets the children of the list row.
///
/// Children are displayed in a horizontal grid. By default the second child
/// fills remaining space. Add `class="list-col-grow"` to a different child to
/// change which one grows, or `class="list-col-wrap"` to push a child to the
/// next line spanning the full width.
///
/// ```gleam
/// list.row_new()
/// |> list.row_children([
///   html.div([], [html.img([attribute.src("/avatar.webp")])]),
///   // second child grows by default:
///   html.div([], [html.text("Name"), html.text("Subtitle")]),
///   html.button([attribute.class("btn btn-square btn-ghost")], [icon()]),
/// ])
/// |> list.row_build
/// ```
pub fn row_children(r: DaisyListRow(msg), c: List(Element(msg))) -> DaisyListRow(msg) {
  DaisyListRow(..r, children: c)
}

/// Converts the `ListRow` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <li class="list-row" …attrs>…children</li>
/// ```
pub fn row_build(r: DaisyListRow(msg)) -> Element(msg) {
  html.li([attribute.class("list-row"), ..r.attrs], r.children)
}
