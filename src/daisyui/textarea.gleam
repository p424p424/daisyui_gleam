/// A builder for DaisyUI textarea elements.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/textarea
///
/// textarea.new()
/// |> textarea.primary
/// |> textarea.attrs([attribute.placeholder("Bio")])
/// |> textarea.build
/// ```
///
/// ## Reference
/// - [DaisyUI textarea](https://daisyui.com/components/textarea/)
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

pub opaque type Textarea(msg) {
  Textarea(
    color: Option(String),
    size: Option(String),
    ghost: Bool,
    disabled: Bool,
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Textarea` builder with no modifiers.
pub fn new() -> Textarea(msg) {
  Textarea(color: None, size: None, ghost: False, disabled: False, attrs: [])
}

// ---------------------------------------------------------------------------
// Style
// ---------------------------------------------------------------------------

/// Ghost style — `textarea-ghost`.
pub fn ghost(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, ghost: True)
}

// ---------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------

/// Neutral color — `textarea-neutral`.
pub fn neutral(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, color: Some("textarea-neutral"))
}

/// Primary color — `textarea-primary`.
pub fn primary(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, color: Some("textarea-primary"))
}

/// Secondary color — `textarea-secondary`.
pub fn secondary(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, color: Some("textarea-secondary"))
}

/// Accent color — `textarea-accent`.
pub fn accent(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, color: Some("textarea-accent"))
}

/// Info color — `textarea-info`.
pub fn info(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, color: Some("textarea-info"))
}

/// Success color — `textarea-success`.
pub fn success(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, color: Some("textarea-success"))
}

/// Warning color — `textarea-warning`.
pub fn warning(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, color: Some("textarea-warning"))
}

/// Error color — `textarea-error`.
pub fn error(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, color: Some("textarea-error"))
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Extra small — `textarea-xs`.
pub fn xs(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, size: Some("textarea-xs"))
}

/// Small — `textarea-sm`.
pub fn sm(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, size: Some("textarea-sm"))
}

/// Medium (default) — `textarea-md`.
pub fn md(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, size: Some("textarea-md"))
}

/// Large — `textarea-lg`.
pub fn lg(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, size: Some("textarea-lg"))
}

/// Extra large — `textarea-xl`.
pub fn xl(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, size: Some("textarea-xl"))
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Disables the textarea — adds the `disabled` HTML attribute.
pub fn disabled(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, disabled: True)
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<textarea>`.
pub fn attrs(t: Textarea(msg), a: List(Attribute(msg))) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

/// Fires `msg(value)` on every keystroke in the textarea.
pub fn on_input(t: Textarea(msg), msg: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_input(msg)]))
}

/// Fires `msg(value)` when the textarea value is committed (blur).
pub fn on_change(t: Textarea(msg), msg: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_change(msg)]))
}

/// Fires `msg` when the textarea receives focus.
pub fn on_focus(t: Textarea(msg), msg: msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_focus(msg)]))
}

/// Fires `msg` when the textarea loses focus.
pub fn on_blur(t: Textarea(msg), msg: msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_blur(msg)]))
}

/// Fires `msg(key)` when a key is pressed while the textarea is focused.
pub fn on_keydown(t: Textarea(msg), msg: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_keydown(msg)]))
}

/// Fires `msg(key)` when a key is released while the textarea is focused.
pub fn on_keyup(t: Textarea(msg), msg: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_keyup(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Textarea` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <textarea class="textarea [ghost] [color] [size]" [disabled] …attrs></textarea>
/// ```
pub fn build(t: Textarea(msg)) -> Element(msg) {
  let class =
    [
      Some("textarea"),
      case t.ghost {
        True -> Some("textarea-ghost")
        False -> None
      },
      t.color,
      t.size,
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let disabled_attr = case t.disabled {
    True -> [attribute.disabled(True)]
    False -> []
  }

  html.textarea(
    list.flatten([[attribute.class(class)], disabled_attr, t.attrs]),
    "",
  )
}
