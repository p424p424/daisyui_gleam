/// Builders for DaisyUI steps elements.
///
/// A `Steps` container holds one or more `Step` items that represent stages
/// in a process. Steps can be horizontal (default) or vertical.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/steps
///
/// steps.new()
/// |> steps.items([
///   steps.step("Register")   |> steps.step_primary |> steps.step_build,
///   steps.step("Choose plan") |> steps.step_primary |> steps.step_build,
///   steps.step("Purchase")   |> steps.step_build,
///   steps.step("Receive")    |> steps.step_build,
/// ])
/// |> steps.build
/// ```
///
/// ## Reference
/// - [DaisyUI steps](https://daisyui.com/components/steps/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Step item
// ---------------------------------------------------------------------------

/// A single `<li class="step …">` item.
pub opaque type Step(msg) {
  Step(
    label: String,
    color: Option(String),
    icon: Option(Element(msg)),
    data_content: Option(String),
    attrs: List(Attribute(msg)),
  )
}

/// Creates a new `Step` with the given label text and no colour.
pub fn step(label: String) -> Step(msg) {
  Step(label: label, color: None, icon: None, data_content: None, attrs: [])
}

// -- Colors ------------------------------------------------------------------

/// Neutral colour — `step-neutral`.
pub fn step_neutral(s: Step(msg)) -> Step(msg) {
  Step(..s, color: Some("step-neutral"))
}

/// Primary colour — `step-primary`.
pub fn step_primary(s: Step(msg)) -> Step(msg) {
  Step(..s, color: Some("step-primary"))
}

/// Secondary colour — `step-secondary`.
pub fn step_secondary(s: Step(msg)) -> Step(msg) {
  Step(..s, color: Some("step-secondary"))
}

/// Accent colour — `step-accent`.
pub fn step_accent(s: Step(msg)) -> Step(msg) {
  Step(..s, color: Some("step-accent"))
}

/// Info colour — `step-info`.
pub fn step_info(s: Step(msg)) -> Step(msg) {
  Step(..s, color: Some("step-info"))
}

/// Success colour — `step-success`.
pub fn step_success(s: Step(msg)) -> Step(msg) {
  Step(..s, color: Some("step-success"))
}

/// Warning colour — `step-warning`.
pub fn step_warning(s: Step(msg)) -> Step(msg) {
  Step(..s, color: Some("step-warning"))
}

/// Error colour — `step-error`.
pub fn step_error(s: Step(msg)) -> Step(msg) {
  Step(..s, color: Some("step-error"))
}

// -- Icon / data-content -----------------------------------------------------

/// Sets a `<span class="step-icon">` with the given content before the label.
///
/// ```gleam
/// steps.step("Step 1") |> steps.step_icon("😃")
/// ```
pub fn step_icon(s: Step(msg), content: String) -> Step(msg) {
  Step(
    ..s,
    icon: Some(
      html.span([attribute.class("step-icon")], [html.text(content)]),
    ),
  )
}

/// Sets an arbitrary element as the step icon (for SVG or complex content).
pub fn step_icon_el(s: Step(msg), el: Element(msg)) -> Step(msg) {
  Step(..s, icon: Some(el))
}

/// Sets the `data-content` attribute on the `<li>`.
///
/// ```gleam
/// steps.step("Step 1") |> steps.step_data_content("✓")
/// ```
pub fn step_data_content(s: Step(msg), content: String) -> Step(msg) {
  Step(..s, data_content: Some(content))
}

/// Merges additional Lustre attributes onto the `<li>`.
pub fn step_attrs(s: Step(msg), a: List(Attribute(msg))) -> Step(msg) {
  Step(..s, attrs: a)
}

/// Converts a `Step` builder into a `<li class="step …">` element.
pub fn step_build(s: Step(msg)) -> Element(msg) {
  let class =
    [Some("step"), s.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let data_attr = case s.data_content {
    Some(c) -> [attribute.attribute("data-content", c)]
    None -> []
  }

  let children = case s.icon {
    Some(icon) -> [icon, html.text(s.label)]
    None -> [html.text(s.label)]
  }

  html.li(
    list.flatten([[attribute.class(class)], data_attr, s.attrs]),
    children,
  )
}

// ---------------------------------------------------------------------------
// Steps container
// ---------------------------------------------------------------------------

/// A builder for the `<ul class="steps">` container.
pub opaque type Steps(msg) {
  Steps(
    direction: Option(String),
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

/// Creates a new `Steps` builder (horizontal by default).
pub fn new() -> Steps(msg) {
  Steps(direction: None, attrs: [], items: [])
}

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Vertical layout — `steps-vertical`.
pub fn vertical(s: Steps(msg)) -> Steps(msg) {
  Steps(..s, direction: Some("steps-vertical"))
}

/// Horizontal layout — `steps-horizontal`.
pub fn horizontal(s: Steps(msg)) -> Steps(msg) {
  Steps(..s, direction: Some("steps-horizontal"))
}

// ---------------------------------------------------------------------------
// Attrs / items
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<ul class="steps">`.
pub fn attrs(s: Steps(msg), a: List(Attribute(msg))) -> Steps(msg) {
  Steps(..s, attrs: a)
}

/// Sets the step children. Build each with `step_build/1`.
pub fn items(s: Steps(msg), is: List(Element(msg))) -> Steps(msg) {
  Steps(..s, items: is)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Steps` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <ul class="steps [steps-vertical|steps-horizontal]" …attrs>children</ul>
/// ```
pub fn build(s: Steps(msg)) -> Element(msg) {
  let class =
    [Some("steps"), s.direction]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.ul([attribute.class(class), ..s.attrs], s.items)
}
