/// A builder for DaisyUI status elements.
///
/// Status is a tiny coloured dot used to indicate online/offline/error states.
/// Supports ping and bounce animations via Tailwind `animate-*` utilities.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/status
///
/// // Online indicator
/// status.new() |> status.success |> status.build
///
/// // Pinging error dot
/// status.new() |> status.error |> status.animate_ping |> status.build
/// ```
///
/// ## Ping animation (two overlapping elements)
///
/// DaisyUI's ping pattern requires two stacked elements:
/// ```gleam
/// status.ping(status.new() |> status.error)
/// ```
/// This renders:
/// ```html
/// <div class="inline-grid *:[grid-area:1/1]">
///   <div class="status status-error animate-ping"></div>
///   <div class="status status-error"></div>
/// </div>
/// ```
///
/// ## Reference
/// - [DaisyUI status](https://daisyui.com/components/status/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Status(msg) {
  Status(
    color: Option(String),
    size: Option(String),
    animation: Option(String),
    label: Option(String),
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Status` builder with no colour, size, or animation.
pub fn new() -> Status(msg) {
  Status(color: None, size: None, animation: None, label: None, attrs: [])
}

// ---------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------

/// Neutral colour — `status-neutral`.
pub fn neutral(s: Status(msg)) -> Status(msg) {
  Status(..s, color: Some("status-neutral"))
}

/// Primary colour — `status-primary`.
pub fn primary(s: Status(msg)) -> Status(msg) {
  Status(..s, color: Some("status-primary"))
}

/// Secondary colour — `status-secondary`.
pub fn secondary(s: Status(msg)) -> Status(msg) {
  Status(..s, color: Some("status-secondary"))
}

/// Accent colour — `status-accent`.
pub fn accent(s: Status(msg)) -> Status(msg) {
  Status(..s, color: Some("status-accent"))
}

/// Info colour — `status-info`.
pub fn info(s: Status(msg)) -> Status(msg) {
  Status(..s, color: Some("status-info"))
}

/// Success colour — `status-success`.
pub fn success(s: Status(msg)) -> Status(msg) {
  Status(..s, color: Some("status-success"))
}

/// Warning colour — `status-warning`.
pub fn warning(s: Status(msg)) -> Status(msg) {
  Status(..s, color: Some("status-warning"))
}

/// Error colour — `status-error`.
pub fn error(s: Status(msg)) -> Status(msg) {
  Status(..s, color: Some("status-error"))
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Extra small — `status-xs`.
pub fn xs(s: Status(msg)) -> Status(msg) {
  Status(..s, size: Some("status-xs"))
}

/// Small — `status-sm`.
pub fn sm(s: Status(msg)) -> Status(msg) {
  Status(..s, size: Some("status-sm"))
}

/// Medium (default) — `status-md`.
pub fn md(s: Status(msg)) -> Status(msg) {
  Status(..s, size: Some("status-md"))
}

/// Large — `status-lg`.
pub fn lg(s: Status(msg)) -> Status(msg) {
  Status(..s, size: Some("status-lg"))
}

/// Extra large — `status-xl`.
pub fn xl(s: Status(msg)) -> Status(msg) {
  Status(..s, size: Some("status-xl"))
}

// ---------------------------------------------------------------------------
// Animation
// ---------------------------------------------------------------------------

/// Adds `animate-ping` — use with `ping/1` for the full two-layer effect.
pub fn animate_ping(s: Status(msg)) -> Status(msg) {
  Status(..s, animation: Some("animate-ping"))
}

/// Adds `animate-bounce`.
pub fn animate_bounce(s: Status(msg)) -> Status(msg) {
  Status(..s, animation: Some("animate-bounce"))
}

// ---------------------------------------------------------------------------
// Accessibility label
// ---------------------------------------------------------------------------

/// Sets an `aria-label` attribute on the element.
pub fn label(s: Status(msg), l: String) -> Status(msg) {
  Status(..s, label: Some(l))
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<div>`.
pub fn attrs(s: Status(msg), a: List(Attribute(msg))) -> Status(msg) {
  Status(..s, attrs: a)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Status` builder into a Lustre `Element(msg)`.
///
/// Renders `<div class="status [color] [size] [animation]" [aria-label] …attrs></div>`.
pub fn build(s: Status(msg)) -> Element(msg) {
  let class =
    [Some("status"), s.color, s.size, s.animation]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let label_attr = case s.label {
    Some(l) -> [attribute.attribute("aria-label", l)]
    None -> []
  }

  html.div(
    list.flatten([[attribute.class(class)], label_attr, s.attrs]),
    [],
  )
}

// ---------------------------------------------------------------------------
// Ping helper
// ---------------------------------------------------------------------------

/// Wraps a `Status` in the two-layer ping pattern:
///
/// ```html
/// <div class="inline-grid *:[grid-area:1/1]">
///   <div class="status … animate-ping"></div>
///   <div class="status …"></div>
/// </div>
/// ```
///
/// The `s` builder should have colour (and optionally size) set but
/// **not** an animation — `ping/1` adds `animate-ping` to the back layer
/// automatically.
pub fn ping(s: Status(msg)) -> Element(msg) {
  let back = Status(..s, animation: Some("animate-ping"))
  let front = Status(..s, animation: None)
  html.div(
    [attribute.class("inline-grid *:[grid-area:1/1]")],
    [build(back), build(front)],
  )
}
