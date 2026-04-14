/// Builders for DaisyUI timeline elements.
///
/// A `Timeline` is a `<ul class="timeline">` containing `<li>` items. Each
/// item has up to three named slots (`timeline-start`, `timeline-middle`,
/// `timeline-end`) and optional `<hr>` connectors before/after to draw the
/// connecting line between items.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/timeline
/// import lustre/element/html
///
/// // Vertical timeline, text on both sides, icon in the middle
/// timeline.new()
/// |> timeline.vertical
/// |> timeline.items([
///   timeline.item()
///     |> timeline.item_start([html.text("1984")])
///     |> timeline.item_middle(check_icon())
///     |> timeline.item_end_box([html.text("Macintosh")])
///     |> timeline.item_hr_after([])
///     |> timeline.item_build,
///   timeline.item()
///     |> timeline.item_hr_before([])
///     |> timeline.item_start([html.text("1998")])
///     |> timeline.item_middle(check_icon())
///     |> timeline.item_end_box([html.text("iMac")])
///     |> timeline.item_build,
/// ])
/// |> timeline.build
/// ```
///
/// Pass `attribute.class("bg-primary")` to `item_hr_before`/`item_hr_after`
/// to colour the connecting line.
///
/// ## Reference
/// - [DaisyUI timeline](https://daisyui.com/components/timeline/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Timeline item
// ---------------------------------------------------------------------------

pub opaque type TimelineItem(msg) {
  TimelineItem(
    hr_before: Option(List(Attribute(msg))),
    start: Option(Element(msg)),
    middle: Option(Element(msg)),
    end: Option(Element(msg)),
    hr_after: Option(List(Attribute(msg))),
    attrs: List(Attribute(msg)),
  )
}

/// Creates a new empty `TimelineItem`.
pub fn item() -> TimelineItem(msg) {
  TimelineItem(
    hr_before: None,
    start: None,
    middle: None,
    end: None,
    hr_after: None,
    attrs: [],
  )
}

// -- Hr connectors -----------------------------------------------------------

/// Prepends an `<hr attrs>` to the item (connects to the previous item).
///
/// Pass `[]` for a plain connector, or e.g. `[attribute.class("bg-primary")]`
/// for a coloured one.
pub fn item_hr_before(
  i: TimelineItem(msg),
  a: List(Attribute(msg)),
) -> TimelineItem(msg) {
  TimelineItem(..i, hr_before: Some(a))
}

/// Appends an `<hr attrs>` to the item (connects to the next item).
pub fn item_hr_after(
  i: TimelineItem(msg),
  a: List(Attribute(msg)),
) -> TimelineItem(msg) {
  TimelineItem(..i, hr_after: Some(a))
}

// -- Slots -------------------------------------------------------------------

/// Sets `<div class="timeline-start">children</div>`.
pub fn item_start(
  i: TimelineItem(msg),
  children: List(Element(msg)),
) -> TimelineItem(msg) {
  TimelineItem(..i, start: Some(html.div([attribute.class("timeline-start")], children)))
}

/// Sets `<div class="timeline-start timeline-box">children</div>`.
pub fn item_start_box(
  i: TimelineItem(msg),
  children: List(Element(msg)),
) -> TimelineItem(msg) {
  TimelineItem(
    ..i,
    start: Some(
      html.div([attribute.class("timeline-start timeline-box")], children),
    ),
  )
}

/// Sets `<div class="timeline-middle">el</div>` (typically an icon).
pub fn item_middle(i: TimelineItem(msg), el: Element(msg)) -> TimelineItem(msg) {
  TimelineItem(..i, middle: Some(html.div([attribute.class("timeline-middle")], [el])))
}

/// Sets `<div class="timeline-end">children</div>`.
pub fn item_end(
  i: TimelineItem(msg),
  children: List(Element(msg)),
) -> TimelineItem(msg) {
  TimelineItem(..i, end: Some(html.div([attribute.class("timeline-end")], children)))
}

/// Sets `<div class="timeline-end timeline-box">children</div>`.
pub fn item_end_box(
  i: TimelineItem(msg),
  children: List(Element(msg)),
) -> TimelineItem(msg) {
  TimelineItem(
    ..i,
    end: Some(
      html.div([attribute.class("timeline-end timeline-box")], children),
    ),
  )
}

/// Merges additional Lustre attributes onto the `<li>` element.
pub fn item_attrs(
  i: TimelineItem(msg),
  a: List(Attribute(msg)),
) -> TimelineItem(msg) {
  TimelineItem(..i, attrs: a)
}

/// Converts a `TimelineItem` builder into a `<li>` element.
pub fn item_build(i: TimelineItem(msg)) -> Element(msg) {
  let hr_before_el = case i.hr_before {
    Some(a) -> [html.hr(a)]
    None -> []
  }
  let hr_after_el = case i.hr_after {
    Some(a) -> [html.hr(a)]
    None -> []
  }
  let slots =
    [i.start, i.middle, i.end]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })

  html.li(
    i.attrs,
    list.flatten([hr_before_el, slots, hr_after_el]),
  )
}

// ---------------------------------------------------------------------------
// Timeline container
// ---------------------------------------------------------------------------

pub opaque type Timeline(msg) {
  Timeline(
    direction: Option(String),
    snap_icon: Bool,
    compact: Bool,
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

/// Creates a new `Timeline` builder (horizontal by default).
pub fn new() -> Timeline(msg) {
  Timeline(
    direction: None,
    snap_icon: False,
    compact: False,
    attrs: [],
    items: [],
  )
}

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Vertical layout — `timeline-vertical`.
pub fn vertical(t: Timeline(msg)) -> Timeline(msg) {
  Timeline(..t, direction: Some("timeline-vertical"))
}

/// Horizontal layout — `timeline-horizontal` (default).
pub fn horizontal(t: Timeline(msg)) -> Timeline(msg) {
  Timeline(..t, direction: Some("timeline-horizontal"))
}

// ---------------------------------------------------------------------------
// Modifiers
// ---------------------------------------------------------------------------

/// Snaps the icon to the start edge — `timeline-snap-icon`.
pub fn snap_icon(t: Timeline(msg)) -> Timeline(msg) {
  Timeline(..t, snap_icon: True)
}

/// Forces all items to one side — `timeline-compact`.
pub fn compact(t: Timeline(msg)) -> Timeline(msg) {
  Timeline(..t, compact: True)
}

// ---------------------------------------------------------------------------
// Attrs / items
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<ul>`.
pub fn attrs(t: Timeline(msg), a: List(Attribute(msg))) -> Timeline(msg) {
  Timeline(..t, attrs: a)
}

/// Sets the `<li>` children. Build each with `item_build/1`.
pub fn items(t: Timeline(msg), is: List(Element(msg))) -> Timeline(msg) {
  Timeline(..t, items: is)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Timeline` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <ul class="timeline [direction] [snap-icon] [compact]" …attrs>
///   items…
/// </ul>
/// ```
pub fn build(t: Timeline(msg)) -> Element(msg) {
  let class =
    [
      Some("timeline"),
      t.direction,
      case t.snap_icon {
        True -> Some("timeline-snap-icon")
        False -> None
      },
      case t.compact {
        True -> Some("timeline-compact")
        False -> None
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.ul([attribute.class(class), ..t.attrs], t.items)
}
