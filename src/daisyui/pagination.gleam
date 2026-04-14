/// A builder for DaisyUI pagination controls.
///
/// Pagination uses the `join` component to group page buttons. Each page
/// is represented by a `PageItem` that can be marked active or disabled and
/// can carry arbitrary Lustre attributes (e.g. `event.on_click`).
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/pagination
/// import lustre/event
///
/// pagination.new()
/// |> pagination.items([
///   pagination.page("1") |> pagination.page_attrs([event.on_click(GoToPage(1))]),
///   pagination.page("2") |> pagination.active,
///   pagination.page("3") |> pagination.page_attrs([event.on_click(GoToPage(3))]),
///   pagination.page("4") |> pagination.page_attrs([event.on_click(GoToPage(4))]),
/// ])
/// |> pagination.build
/// ```
///
/// ## Prev / Next layout
///
/// ```gleam
/// pagination.new()
/// |> pagination.grid_2
/// |> pagination.items([
///   pagination.page("Previous page") |> pagination.outline,
///   pagination.page("Next page")     |> pagination.outline,
/// ])
/// |> pagination.build
/// ```
///
/// ## Reference
/// - [DaisyUI pagination](https://daisyui.com/components/pagination/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// PageItem
// ---------------------------------------------------------------------------

/// A single page button inside the pagination control.
pub opaque type PageItem(msg) {
  PageItem(
    label: String,
    active: Bool,
    disabled: Bool,
    outline: Bool,
    attrs: List(Attribute(msg)),
  )
}

/// Creates a new page item with the given label.
pub fn page(label: String) -> PageItem(msg) {
  PageItem(label: label, active: False, disabled: False, outline: False, attrs: [])
}

/// Marks the page item as active — adds `btn-active`.
pub fn active(p: PageItem(msg)) -> PageItem(msg) {
  PageItem(..p, active: True)
}

/// Marks the page item as disabled — adds `btn-disabled`.
pub fn disabled(p: PageItem(msg)) -> PageItem(msg) {
  PageItem(..p, disabled: True)
}

/// Applies the outline style — adds `btn-outline`.
pub fn outline(p: PageItem(msg)) -> PageItem(msg) {
  PageItem(..p, outline: True)
}

/// Merges additional Lustre attributes onto the page `<button>` element.
///
/// Use this to attach click handlers:
/// ```gleam
/// pagination.page("3") |> pagination.page_attrs([event.on_click(GoTo(3))])
/// ```
pub fn page_attrs(p: PageItem(msg), a: List(Attribute(msg))) -> PageItem(msg) {
  PageItem(..p, attrs: a)
}

// ---------------------------------------------------------------------------
// Pagination builder
// ---------------------------------------------------------------------------

pub opaque type Pagination(msg) {
  Pagination(
    size: Option(String),
    grid_2: Bool,
    attrs: List(Attribute(msg)),
    items: List(PageItem(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Pagination` builder.
pub fn new() -> Pagination(msg) {
  Pagination(size: None, grid_2: False, attrs: [], items: [])
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Extra small buttons — `btn-xs`.
pub fn xs(p: Pagination(msg)) -> Pagination(msg) {
  Pagination(..p, size: Some("btn-xs"))
}

/// Small buttons — `btn-sm`.
pub fn sm(p: Pagination(msg)) -> Pagination(msg) {
  Pagination(..p, size: Some("btn-sm"))
}

/// Medium buttons — `btn-md` (default).
pub fn md(p: Pagination(msg)) -> Pagination(msg) {
  Pagination(..p, size: Some("btn-md"))
}

/// Large buttons — `btn-lg`.
pub fn lg(p: Pagination(msg)) -> Pagination(msg) {
  Pagination(..p, size: Some("btn-lg"))
}

/// Extra large buttons — `btn-xl`.
pub fn xl(p: Pagination(msg)) -> Pagination(msg) {
  Pagination(..p, size: Some("btn-xl"))
}

// ---------------------------------------------------------------------------
// Layout
// ---------------------------------------------------------------------------

/// Adds `grid grid-cols-2` to the join container — useful for a
/// Previous / Next layout where both buttons share equal width.
pub fn grid_2(p: Pagination(msg)) -> Pagination(msg) {
  Pagination(..p, grid_2: True)
}

// ---------------------------------------------------------------------------
// Attrs / items
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<div class="join">`.
pub fn attrs(p: Pagination(msg), a: List(Attribute(msg))) -> Pagination(msg) {
  Pagination(..p, attrs: a)
}

/// Sets the list of `PageItem` values to render.
pub fn items(p: Pagination(msg), is: List(PageItem(msg))) -> Pagination(msg) {
  Pagination(..p, items: is)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Pagination` builder into a Lustre `Element(msg)`.
///
/// Each `PageItem` is rendered as:
/// ```html
/// <button class="join-item btn [size] [btn-active] [btn-disabled] [btn-outline]" …attrs>
///   label
/// </button>
/// ```
pub fn build(p: Pagination(msg)) -> Element(msg) {
  let container_class =
    [Some("join"), case p.grid_2 {
      True -> Some("grid grid-cols-2")
      False -> None
    }]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let buttons =
    list.map(p.items, fn(item) {
      let btn_class =
        [
          Some("join-item"),
          Some("btn"),
          p.size,
          case item.active {
            True -> Some("btn-active")
            False -> None
          },
          case item.disabled {
            True -> Some("btn-disabled")
            False -> None
          },
          case item.outline {
            True -> Some("btn-outline")
            False -> None
          },
        ]
        |> list.filter_map(fn(x) { option.to_result(x, Nil) })
        |> string.join(" ")

      html.button(
        [attribute.class(btn_class), ..item.attrs],
        [html.text(item.label)],
      )
    })

  html.div([attribute.class(container_class), ..p.attrs], buttons)
}
