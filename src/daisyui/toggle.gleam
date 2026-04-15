/// A builder for DaisyUI toggle elements.
///
/// Toggle is a checkbox styled as a switch button.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/toggle
///
/// toggle.new()
/// |> toggle.primary
/// |> toggle.on_check(UserToggledDarkMode)
/// |> toggle.build
/// ```
///
/// ## Toggle with icons inside
///
/// DaisyUI also supports a label-based toggle with icons. Build that manually:
/// ```gleam
/// html.label([attribute.class("toggle text-base-content")], [
///   html.input([attribute.type_("checkbox")]),
///   on_icon(),
///   off_icon(),
/// ])
/// ```
///
/// ## Reference
/// - [DaisyUI toggle](https://daisyui.com/components/toggle/)
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

pub opaque type Toggle(msg) {
  Toggle(
    color: Option(String),
    size: Option(String),
    checked: Bool,
    disabled: Bool,
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Toggle` builder with no modifiers.
pub fn new() -> Toggle(msg) {
  Toggle(color: None, size: None, checked: False, disabled: False, attrs: [])
}

// ---------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------

/// Primary color — `toggle-primary`.
pub fn primary(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, color: Some("toggle-primary"))
}

/// Secondary color — `toggle-secondary`.
pub fn secondary(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, color: Some("toggle-secondary"))
}

/// Accent color — `toggle-accent`.
pub fn accent(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, color: Some("toggle-accent"))
}

/// Neutral color — `toggle-neutral`.
pub fn neutral(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, color: Some("toggle-neutral"))
}

/// Info color — `toggle-info`.
pub fn info(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, color: Some("toggle-info"))
}

/// Success color — `toggle-success`.
pub fn success(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, color: Some("toggle-success"))
}

/// Warning color — `toggle-warning`.
pub fn warning(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, color: Some("toggle-warning"))
}

/// Error color — `toggle-error`.
pub fn error(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, color: Some("toggle-error"))
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Extra small — `toggle-xs`.
pub fn xs(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, size: Some("toggle-xs"))
}

/// Small — `toggle-sm`.
pub fn sm(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, size: Some("toggle-sm"))
}

/// Medium (default) — `toggle-md`.
pub fn md(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, size: Some("toggle-md"))
}

/// Large — `toggle-lg`.
pub fn lg(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, size: Some("toggle-lg"))
}

/// Extra large — `toggle-xl`.
pub fn xl(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, size: Some("toggle-xl"))
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Marks the toggle as checked.
pub fn checked(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, checked: True)
}

/// Disables the toggle.
pub fn disabled(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, disabled: True)
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<input>`.
pub fn attrs(t: Toggle(msg), a: List(Attribute(msg))) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

/// Fires `msg(checked)` when the toggle is switched on or off.
pub fn on_check(t: Toggle(msg), msg: fn(Bool) -> msg) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, [event.on_check(msg)]))
}

/// Fires `msg` when the toggle receives focus.
pub fn on_focus(t: Toggle(msg), msg: msg) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, [event.on_focus(msg)]))
}

/// Fires `msg` when the toggle loses focus.
pub fn on_blur(t: Toggle(msg), msg: msg) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, [event.on_blur(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Toggle` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <input type="checkbox" class="toggle [color] [size]" [checked] [disabled] …attrs>
/// ```
pub fn build(t: Toggle(msg)) -> Element(msg) {
  let class =
    [Some("toggle"), t.color, t.size]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let state_attrs = list.flatten([
    case t.checked {
      True -> [attribute.checked(True)]
      False -> []
    },
    case t.disabled {
      True -> [attribute.disabled(True)]
      False -> []
    },
  ])

  html.input(
    list.flatten([[attribute.type_("checkbox"), attribute.class(class)], state_attrs, t.attrs]),
  )
}
