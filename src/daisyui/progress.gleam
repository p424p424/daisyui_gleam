/// A builder for DaisyUI progress elements.
///
/// Progress bar uses the native `<progress>` element. Omit `value` to render
/// an indeterminate (animated) bar.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/progress
///
/// // Determinate — 40 of 100
/// progress.new() |> progress.value(40) |> progress.primary |> progress.build
///
/// // Indeterminate
/// progress.new() |> progress.build
/// ```
///
/// ## Reference
/// - [DaisyUI progress](https://daisyui.com/components/progress/)
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Progress(msg) {
  Progress(
    value: Option(Int),
    max: Int,
    color: Option(String),
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Progress` builder with `max=100` and no value (indeterminate).
pub fn new() -> Progress(msg) {
  Progress(value: None, max: 100, color: None, attrs: [])
}

// ---------------------------------------------------------------------------
// Value / max
// ---------------------------------------------------------------------------

/// Sets the current progress value.
///
/// Omitting this (or not calling `value`) renders an indeterminate bar.
pub fn value(p: Progress(msg), v: Int) -> Progress(msg) {
  Progress(..p, value: Some(v))
}

/// Sets the maximum value (default `100`).
pub fn max(p: Progress(msg), m: Int) -> Progress(msg) {
  Progress(..p, max: m)
}

// ---------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------

/// Neutral colour — `progress-neutral`.
pub fn neutral(p: Progress(msg)) -> Progress(msg) {
  Progress(..p, color: Some("progress-neutral"))
}

/// Primary colour — `progress-primary`.
pub fn primary(p: Progress(msg)) -> Progress(msg) {
  Progress(..p, color: Some("progress-primary"))
}

/// Secondary colour — `progress-secondary`.
pub fn secondary(p: Progress(msg)) -> Progress(msg) {
  Progress(..p, color: Some("progress-secondary"))
}

/// Accent colour — `progress-accent`.
pub fn accent(p: Progress(msg)) -> Progress(msg) {
  Progress(..p, color: Some("progress-accent"))
}

/// Info colour — `progress-info`.
pub fn info(p: Progress(msg)) -> Progress(msg) {
  Progress(..p, color: Some("progress-info"))
}

/// Success colour — `progress-success`.
pub fn success(p: Progress(msg)) -> Progress(msg) {
  Progress(..p, color: Some("progress-success"))
}

/// Warning colour — `progress-warning`.
pub fn warning(p: Progress(msg)) -> Progress(msg) {
  Progress(..p, color: Some("progress-warning"))
}

/// Error colour — `progress-error`.
pub fn error(p: Progress(msg)) -> Progress(msg) {
  Progress(..p, color: Some("progress-error"))
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<progress>` element.
pub fn attrs(p: Progress(msg), a: List(Attribute(msg))) -> Progress(msg) {
  Progress(..p, attrs: a)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Progress` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <progress class="progress [color]" value="…" max="…" …attrs></progress>
/// ```
///
/// If no `value` was set the `value` attribute is omitted, producing an
/// indeterminate animation.
pub fn build(p: Progress(msg)) -> Element(msg) {
  let class =
    [Some("progress"), p.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let value_attrs = case p.value {
    Some(v) -> [attribute.attribute("value", int.to_string(v))]
    None -> []
  }

  let all_attrs =
    list.flatten([
      [
        attribute.class(class),
        attribute.attribute("max", int.to_string(p.max)),
      ],
      value_attrs,
      p.attrs,
    ])

  html.progress(all_attrs, [])
}
