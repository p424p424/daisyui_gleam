/// A builder for DaisyUI range slider elements.
///
/// Range slider uses `<input type="range">`. Optionally add tick marks and
/// labels below the slider with `range.with_steps/3`.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/range
/// import lustre/attribute
/// import lustre/event
///
/// // Basic slider
/// range.new() |> range.primary |> range.build
///
/// // With step value and event handler
/// range.new()
/// |> range.value(40)
/// |> range.step(10)
/// |> range.primary
/// |> range.on_input(UserMovedSlider)
/// |> range.build
/// ```
///
/// ## Reference
/// - [DaisyUI range](https://daisyui.com/components/range/)
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Range(msg) {
  Range(
    min: Int,
    max: Int,
    value: Option(Int),
    step: Option(Int),
    color: Option(String),
    size: Option(String),
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Range` builder with `min=0`, `max=100`, no preset value,
/// and no colour or size override.
pub fn new() -> Range(msg) {
  Range(min: 0, max: 100, value: None, step: None, color: None, size: None, attrs: [])
}

// ---------------------------------------------------------------------------
// Value / range / step
// ---------------------------------------------------------------------------

/// Sets the initial value. Defaults to browser midpoint if omitted.
pub fn value(r: Range(msg), v: Int) -> Range(msg) {
  Range(..r, value: Some(v))
}

/// Sets the `min` attribute (default `0`).
pub fn min(r: Range(msg), m: Int) -> Range(msg) {
  Range(..r, min: m)
}

/// Sets the `max` attribute (default `100`).
pub fn max(r: Range(msg), m: Int) -> Range(msg) {
  Range(..r, max: m)
}

/// Sets the `step` attribute.
pub fn step(r: Range(msg), s: Int) -> Range(msg) {
  Range(..r, step: Some(s))
}

// ---------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------

/// Neutral colour — `range-neutral`.
pub fn neutral(r: Range(msg)) -> Range(msg) {
  Range(..r, color: Some("range-neutral"))
}

/// Primary colour — `range-primary`.
pub fn primary(r: Range(msg)) -> Range(msg) {
  Range(..r, color: Some("range-primary"))
}

/// Secondary colour — `range-secondary`.
pub fn secondary(r: Range(msg)) -> Range(msg) {
  Range(..r, color: Some("range-secondary"))
}

/// Accent colour — `range-accent`.
pub fn accent(r: Range(msg)) -> Range(msg) {
  Range(..r, color: Some("range-accent"))
}

/// Success colour — `range-success`.
pub fn success(r: Range(msg)) -> Range(msg) {
  Range(..r, color: Some("range-success"))
}

/// Warning colour — `range-warning`.
pub fn warning(r: Range(msg)) -> Range(msg) {
  Range(..r, color: Some("range-warning"))
}

/// Info colour — `range-info`.
pub fn info(r: Range(msg)) -> Range(msg) {
  Range(..r, color: Some("range-info"))
}

/// Error colour — `range-error`.
pub fn error(r: Range(msg)) -> Range(msg) {
  Range(..r, color: Some("range-error"))
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Extra small size — `range-xs`.
pub fn xs(r: Range(msg)) -> Range(msg) {
  Range(..r, size: Some("range-xs"))
}

/// Small size — `range-sm`.
pub fn sm(r: Range(msg)) -> Range(msg) {
  Range(..r, size: Some("range-sm"))
}

/// Medium size — `range-md` (default).
pub fn md(r: Range(msg)) -> Range(msg) {
  Range(..r, size: Some("range-md"))
}

/// Large size — `range-lg`.
pub fn lg(r: Range(msg)) -> Range(msg) {
  Range(..r, size: Some("range-lg"))
}

/// Extra large size — `range-xl`.
pub fn xl(r: Range(msg)) -> Range(msg) {
  Range(..r, size: Some("range-xl"))
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<input>` element.
///
/// Use for event handlers or extra classes (e.g. custom CSS variables):
/// ```gleam
/// range.new()
/// |> range.attrs([
///   event.on_input(UserMoved),
///   attribute.class("[--range-fill:0]"),
/// ])
/// |> range.build
/// ```
pub fn attrs(r: Range(msg), a: List(Attribute(msg))) -> Range(msg) {
  Range(..r, attrs: list.append(r.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

/// Fires `msg(value)` on every movement of the range thumb.
pub fn on_input(r: Range(msg), msg: fn(String) -> msg) -> Range(msg) {
  Range(..r, attrs: list.append(r.attrs, [event.on_input(msg)]))
}

/// Fires `msg(value)` when the range value is committed (mouse/touch release).
pub fn on_change(r: Range(msg), msg: fn(String) -> msg) -> Range(msg) {
  Range(..r, attrs: list.append(r.attrs, [event.on_change(msg)]))
}

/// Fires `msg` when the range receives focus.
pub fn on_focus(r: Range(msg), msg: msg) -> Range(msg) {
  Range(..r, attrs: list.append(r.attrs, [event.on_focus(msg)]))
}

/// Fires `msg` when the range loses focus.
pub fn on_blur(r: Range(msg), msg: msg) -> Range(msg) {
  Range(..r, attrs: list.append(r.attrs, [event.on_blur(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Range` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <input type="range" class="range [color] [size]"
///        min="…" max="…" [value="…"] [step="…"] …attrs />
/// ```
pub fn build(r: Range(msg)) -> Element(msg) {
  let class =
    [Some("range"), r.color, r.size]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let optional_attrs = list.flatten([
    case r.value {
      Some(v) -> [attribute.value(int.to_string(v))]
      None -> []
    },
    case r.step {
      Some(s) -> [attribute.attribute("step", int.to_string(s))]
      None -> []
    },
  ])

  html.input(list.flatten([
    [
      attribute.type_("range"),
      attribute.class(class),
      attribute.attribute("min", int.to_string(r.min)),
      attribute.attribute("max", int.to_string(r.max)),
    ],
    optional_attrs,
    r.attrs,
  ]))
}

// ---------------------------------------------------------------------------
// Step-marks helper
// ---------------------------------------------------------------------------

/// Wraps the slider in a container with tick marks and text labels beneath.
///
/// `labels` is the list of strings shown under each tick (one per step stop).
///
/// ```gleam
/// range.with_steps(
///   range.new() |> range.value(25) |> range.step(25),
///   ["|", "|", "|", "|", "|"],
///   ["0", "25", "50", "75", "100"],
/// )
/// ```
pub fn with_steps(
  r: Range(msg),
  ticks: List(String),
  labels: List(String),
) -> Element(msg) {
  html.div([attribute.class("w-full")], [
    build(r),
    html.div(
      [attribute.class("flex justify-between px-2.5 mt-2 text-xs")],
      list.map(ticks, fn(t) { html.span([], [html.text(t)]) }),
    ),
    html.div(
      [attribute.class("flex justify-between px-2.5 mt-2 text-xs")],
      list.map(labels, fn(l) { html.span([], [html.text(l)]) }),
    ),
  ])
}
