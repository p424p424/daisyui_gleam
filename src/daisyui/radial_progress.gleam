/// A builder for DaisyUI radial progress elements.
///
/// Radial progress shows a circular progress indicator. It uses CSS custom
/// properties (`--value`, `--size`, `--thickness`) on a `<div>` because
/// browsers cannot render text or pseudo-elements inside `<progress>`.
///
/// `--value` (0–100) is required. `--size` defaults to `5rem` and
/// `--thickness` defaults to 10% of the size.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/radial_progress
///
/// // Basic — 70%
/// radial_progress.new(70) |> radial_progress.build
///
/// // Custom size and thickness
/// radial_progress.new(70)
/// |> radial_progress.size("12rem")
/// |> radial_progress.thickness("2px")
/// |> radial_progress.build
/// ```
///
/// ## Reference
/// - [DaisyUI radial-progress](https://daisyui.com/components/radial-progress/)
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

pub opaque type RadialProgress(msg) {
  RadialProgress(
    value: Int,
    size: Option(String),
    thickness: Option(String),
    color: Option(String),
    extra_classes: Option(String),
    label: Option(String),
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `RadialProgress` builder for the given value (0–100).
///
/// The label defaults to `"<value>%"`. Use `label/2` to override it.
pub fn new(value: Int) -> RadialProgress(msg) {
  RadialProgress(
    value: value,
    size: None,
    thickness: None,
    color: None,
    extra_classes: None,
    label: None,
    attrs: [],
  )
}

// ---------------------------------------------------------------------------
// Options
// ---------------------------------------------------------------------------

/// Sets `--size`, e.g. `"12rem"` or `"8rem"`. Default: `5rem`.
pub fn size(r: RadialProgress(msg), s: String) -> RadialProgress(msg) {
  RadialProgress(..r, size: Some(s))
}

/// Sets `--thickness`, e.g. `"2px"` or `"2rem"`. Default: 10% of size.
pub fn thickness(r: RadialProgress(msg), t: String) -> RadialProgress(msg) {
  RadialProgress(..r, thickness: Some(t))
}

/// Sets a Tailwind text-colour utility, e.g. `"text-primary"`.
pub fn color(r: RadialProgress(msg), c: String) -> RadialProgress(msg) {
  RadialProgress(..r, color: Some(c))
}

/// Appends extra CSS classes (e.g. `"bg-primary text-primary-content border-primary border-4"`).
pub fn classes(r: RadialProgress(msg), c: String) -> RadialProgress(msg) {
  RadialProgress(..r, extra_classes: Some(c))
}

/// Overrides the text label rendered inside the ring.
///
/// By default the label is `"<value>%"`.
pub fn label(r: RadialProgress(msg), l: String) -> RadialProgress(msg) {
  RadialProgress(..r, label: Some(l))
}

/// Merges additional Lustre attributes onto the `<div>`.
pub fn attrs(r: RadialProgress(msg), a: List(Attribute(msg))) -> RadialProgress(msg) {
  RadialProgress(..r, attrs: a)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `RadialProgress` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <div
///   class="radial-progress [color] [extra_classes]"
///   style="--value:70; [--size:…;] [--thickness:…;]"
///   aria-valuenow="70"
///   role="progressbar"
///   …attrs
/// >label</div>
/// ```
pub fn build(r: RadialProgress(msg)) -> Element(msg) {
  let class =
    [Some("radial-progress"), r.color, r.extra_classes]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let value_str = int.to_string(r.value)

  let style =
    [
      Some("--value:" <> value_str <> ";"),
      option.map(r.size, fn(s) { "--size:" <> s <> ";" }),
      option.map(r.thickness, fn(t) { "--thickness:" <> t <> ";" }),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let text = case r.label {
    Some(l) -> l
    None -> value_str <> "%"
  }

  html.div(
    [
      attribute.class(class),
      attribute.attribute("style", style),
      attribute.attribute("aria-valuenow", value_str),
      attribute.role("progressbar"),
      ..r.attrs
    ],
    [html.text(text)],
  )
}
