/// A builder for DaisyUI radio input elements.
///
/// Each radio renders as `<input type="radio" class="radio …">`.
/// Group related radios by giving them the same `name` attribute —
/// use `radio.attrs([attribute.name("my-group")])`.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/radio
/// import lustre/attribute
/// import lustre/event
///
/// radio.new()
/// |> radio.primary
/// |> radio.attrs([
///   attribute.name("colour"),
///   attribute.value("red"),
///   event.on_check(UserPickedRed),
/// ])
/// |> radio.build
/// ```
///
/// ## Reference
/// - [DaisyUI radio](https://daisyui.com/components/radio/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Radio(msg) {
  Radio(
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

/// Creates a new `Radio` builder with no colour or size override.
pub fn new() -> Radio(msg) {
  Radio(color: None, size: None, checked: False, disabled: False, attrs: [])
}

// ---------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------

/// Neutral colour — `radio-neutral`.
pub fn neutral(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, color: Some("radio-neutral"))
}

/// Primary colour — `radio-primary`.
pub fn primary(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, color: Some("radio-primary"))
}

/// Secondary colour — `radio-secondary`.
pub fn secondary(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, color: Some("radio-secondary"))
}

/// Accent colour — `radio-accent`.
pub fn accent(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, color: Some("radio-accent"))
}

/// Success colour — `radio-success`.
pub fn success(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, color: Some("radio-success"))
}

/// Warning colour — `radio-warning`.
pub fn warning(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, color: Some("radio-warning"))
}

/// Info colour — `radio-info`.
pub fn info(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, color: Some("radio-info"))
}

/// Error colour — `radio-error`.
pub fn error(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, color: Some("radio-error"))
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Extra small size — `radio-xs`.
pub fn xs(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, size: Some("radio-xs"))
}

/// Small size — `radio-sm`.
pub fn sm(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, size: Some("radio-sm"))
}

/// Medium size — `radio-md` (default).
pub fn md(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, size: Some("radio-md"))
}

/// Large size — `radio-lg`.
pub fn lg(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, size: Some("radio-lg"))
}

/// Extra large size — `radio-xl`.
pub fn xl(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, size: Some("radio-xl"))
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Renders the radio as checked.
pub fn checked(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, checked: True)
}

/// Renders the radio as disabled.
pub fn disabled(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, disabled: True)
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<input>` element.
///
/// Use this for `name`, `value`, `id`, and event handlers:
/// ```gleam
/// radio.new()
/// |> radio.attrs([
///   attribute.name("size"),
///   attribute.value("lg"),
///   event.on_check(UserPickedLarge),
/// ])
/// |> radio.build
/// ```
pub fn attrs(r: Radio(msg), a: List(Attribute(msg))) -> Radio(msg) {
  Radio(..r, attrs: a)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Radio` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <input type="radio" class="radio [color] [size]" [checked] [disabled] …attrs />
/// ```
pub fn build(r: Radio(msg)) -> Element(msg) {
  let class =
    [Some("radio"), r.color, r.size]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let state_attrs = list.flatten([
    case r.checked {
      True -> [attribute.checked(True)]
      False -> []
    },
    case r.disabled {
      True -> [attribute.disabled(True)]
      False -> []
    },
  ])

  html.input([
    attribute.type_("radio"),
    attribute.class(class),
    ..list.append(state_attrs, r.attrs)
  ])
}
