/// Builders for DaisyUI stat elements.
///
/// A `Stats` container holds one or more `Stat` items. Each `Stat` has up to
/// five named parts: figure, title, value, desc, and actions.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/stat
/// import lustre/element/html
///
/// stat.new()
/// |> stat.shadow
/// |> stat.items([
///   stat.item()
///   |> stat.title("Total Page Views")
///   |> stat.value("89,400")
///   |> stat.desc("21% more than last month")
///   |> stat.item_build,
/// ])
/// |> stat.build
/// ```
///
/// ## Reference
/// - [DaisyUI stat](https://daisyui.com/components/stat/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Stat item
// ---------------------------------------------------------------------------

/// A builder for a single `<div class="stat">` block.
pub opaque type StatItem(msg) {
  StatItem(
    centered: Bool,
    figure: Option(Element(msg)),
    title: Option(String),
    value: Option(Element(msg)),
    desc: Option(Element(msg)),
    actions: Option(Element(msg)),
    attrs: List(Attribute(msg)),
  )
}

/// Creates a new `StatItem` builder.
pub fn item() -> StatItem(msg) {
  StatItem(
    centered: False,
    figure: None,
    title: None,
    value: None,
    desc: None,
    actions: None,
    attrs: [],
  )
}

/// Adds `place-items-center` to the stat item for centred layout.
pub fn centered(s: StatItem(msg)) -> StatItem(msg) {
  StatItem(..s, centered: True)
}

/// Sets the `stat-figure` element (icon, avatar, etc.).
pub fn figure(s: StatItem(msg), el: Element(msg)) -> StatItem(msg) {
  StatItem(..s, figure: Some(el))
}

/// Sets the `stat-title` text.
pub fn title(s: StatItem(msg), t: String) -> StatItem(msg) {
  StatItem(..s, title: Some(t))
}

/// Sets the `stat-value` from a plain string.
pub fn value(s: StatItem(msg), v: String) -> StatItem(msg) {
  StatItem(..s, value: Some(html.div([attribute.class("stat-value")], [html.text(v)])))
}

/// Sets the `stat-value` from an arbitrary element (e.g. with extra colour classes).
pub fn value_el(s: StatItem(msg), el: Element(msg)) -> StatItem(msg) {
  StatItem(..s, value: Some(el))
}

/// Sets the `stat-desc` from a plain string.
pub fn desc(s: StatItem(msg), d: String) -> StatItem(msg) {
  StatItem(..s, desc: Some(html.div([attribute.class("stat-desc")], [html.text(d)])))
}

/// Sets the `stat-desc` from an arbitrary element (e.g. with extra colour classes).
pub fn desc_el(s: StatItem(msg), el: Element(msg)) -> StatItem(msg) {
  StatItem(..s, desc: Some(el))
}

/// Sets the `stat-actions` element.
pub fn actions(s: StatItem(msg), el: Element(msg)) -> StatItem(msg) {
  StatItem(..s, actions: Some(el))
}

/// Merges additional Lustre attributes onto the `<div class="stat">`.
pub fn item_attrs(s: StatItem(msg), a: List(Attribute(msg))) -> StatItem(msg) {
  StatItem(..s, attrs: a)
}

/// Converts the `StatItem` builder into a `<div class="stat">` element.
pub fn item_build(s: StatItem(msg)) -> Element(msg) {
  let base_class = case s.centered {
    True -> "stat place-items-center"
    False -> "stat"
  }

  let parts =
    [
      option.map(s.figure, fn(el) {
        html.div([attribute.class("stat-figure")], [el])
      }),
      option.map(s.title, fn(t) {
        html.div([attribute.class("stat-title")], [html.text(t)])
      }),
      s.value,
      s.desc,
      s.actions,
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })

  html.div([attribute.class(base_class), ..s.attrs], parts)
}

// ---------------------------------------------------------------------------
// Stats container
// ---------------------------------------------------------------------------

/// A builder for the `<div class="stats">` container.
pub opaque type Stats(msg) {
  Stats(
    direction: Option(String),
    shadow: Bool,
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

/// Creates a new `Stats` builder (horizontal by default).
pub fn new() -> Stats(msg) {
  Stats(direction: None, shadow: False, attrs: [], items: [])
}

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Horizontal layout — `stats-horizontal` (default).
pub fn horizontal(s: Stats(msg)) -> Stats(msg) {
  Stats(..s, direction: Some("stats-horizontal"))
}

/// Vertical layout — `stats-vertical`.
pub fn vertical(s: Stats(msg)) -> Stats(msg) {
  Stats(..s, direction: Some("stats-vertical"))
}

// ---------------------------------------------------------------------------
// Modifiers
// ---------------------------------------------------------------------------

/// Adds a `shadow` utility class to the container.
pub fn shadow(s: Stats(msg)) -> Stats(msg) {
  Stats(..s, shadow: True)
}

// ---------------------------------------------------------------------------
// Attrs / items
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<div class="stats">`.
pub fn attrs(s: Stats(msg), a: List(Attribute(msg))) -> Stats(msg) {
  Stats(..s, attrs: a)
}

/// Sets the `<div class="stat">` children. Build each with `item_build/1`.
pub fn items(s: Stats(msg), is: List(Element(msg))) -> Stats(msg) {
  Stats(..s, items: is)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Stats` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <div class="stats [stats-vertical|stats-horizontal] [shadow]" …attrs>
///   children
/// </div>
/// ```
pub fn build(s: Stats(msg)) -> Element(msg) {
  let class =
    [
      Some("stats"),
      s.direction,
      case s.shadow {
        True -> Some("shadow")
        False -> None
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.div([attribute.class(class), ..s.attrs], s.items)
}
