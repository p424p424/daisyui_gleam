/// A builder for DaisyUI table elements.
///
/// Manages the `class` on a `<table>` element. The inner structure
/// (`<thead>`, `<tbody>`, `<tfoot>`, `<tr>`, `<th>`, `<td>`) is built by the
/// caller using standard Lustre `html.*` helpers and passed to `children/2`.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/table
/// import lustre/element/html
///
/// table.new()
/// |> table.zebra
/// |> table.children([
///   html.thead([], [ html.tr([], [html.th([], [html.text("Name")]) ]) ]),
///   html.tbody([], [
///     html.tr([], [ html.td([], [html.text("Alice")]) ]),
///   ]),
/// ])
/// |> table.build
/// ```
///
/// Use `table.wrap/1` to put the table inside a `<div class="overflow-x-auto">`.
///
/// ## Reference
/// - [DaisyUI table](https://daisyui.com/components/table/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Table(msg) {
  Table(
    zebra: Bool,
    pin_rows: Bool,
    pin_cols: Bool,
    size: Option(String),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Table` builder with no modifiers.
pub fn new() -> Table(msg) {
  Table(
    zebra: False,
    pin_rows: False,
    pin_cols: False,
    size: None,
    attrs: [],
    children: [],
  )
}

// ---------------------------------------------------------------------------
// Modifiers
// ---------------------------------------------------------------------------

/// Zebra-stripe rows — `table-zebra`.
pub fn zebra(t: Table(msg)) -> Table(msg) {
  Table(..t, zebra: True)
}

/// Sticky `<thead>` / `<tfoot>` rows — `table-pin-rows`.
pub fn pin_rows(t: Table(msg)) -> Table(msg) {
  Table(..t, pin_rows: True)
}

/// Sticky `<th>` columns — `table-pin-cols`.
pub fn pin_cols(t: Table(msg)) -> Table(msg) {
  Table(..t, pin_cols: True)
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Extra small — `table-xs`.
pub fn xs(t: Table(msg)) -> Table(msg) {
  Table(..t, size: Some("table-xs"))
}

/// Small — `table-sm`.
pub fn sm(t: Table(msg)) -> Table(msg) {
  Table(..t, size: Some("table-sm"))
}

/// Medium (default) — `table-md`.
pub fn md(t: Table(msg)) -> Table(msg) {
  Table(..t, size: Some("table-md"))
}

/// Large — `table-lg`.
pub fn lg(t: Table(msg)) -> Table(msg) {
  Table(..t, size: Some("table-lg"))
}

/// Extra large — `table-xl`.
pub fn xl(t: Table(msg)) -> Table(msg) {
  Table(..t, size: Some("table-xl"))
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<table>`.
pub fn attrs(t: Table(msg), a: List(Attribute(msg))) -> Table(msg) {
  Table(..t, attrs: a)
}

/// Sets the children of the `<table>` (`<thead>`, `<tbody>`, `<tfoot>`, …).
pub fn children(t: Table(msg), c: List(Element(msg))) -> Table(msg) {
  Table(..t, children: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Table` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <table class="table [table-zebra] [table-pin-rows] [table-pin-cols] [size]" …attrs>
///   children
/// </table>
/// ```
pub fn build(t: Table(msg)) -> Element(msg) {
  let class =
    [
      Some("table"),
      case t.zebra {
        True -> Some("table-zebra")
        False -> None
      },
      case t.pin_rows {
        True -> Some("table-pin-rows")
        False -> None
      },
      case t.pin_cols {
        True -> Some("table-pin-cols")
        False -> None
      },
      t.size,
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.table([attribute.class(class), ..t.attrs], t.children)
}

// ---------------------------------------------------------------------------
// Wrapper helper
// ---------------------------------------------------------------------------

/// Wraps an element in `<div class="overflow-x-auto">`.
///
/// Typically used around the built table:
/// ```gleam
/// table.new() |> … |> table.build |> table.wrap
/// ```
pub fn wrap(el: Element(msg)) -> Element(msg) {
  html.div([attribute.class("overflow-x-auto")], [el])
}
