/// A builder for DaisyUI select elements.
///
/// Select lets users choose one option from a dropdown list. The component
/// renders as a `<select>` element with optional colour, size, and style
/// modifiers.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.select`) and pass them `Attribute`
/// > and child `Element` lists. This module wraps that pattern in a builder
/// > so you can configure a select piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/select
/// import lustre/element/html
/// import lustre/attribute
/// import lustre/event
///
/// // A primary select with two options
/// select.new()
/// |> select.primary
/// |> select.on_change(UserChangedOption)
/// |> select.children([
///   html.option([attribute.value("a")], [html.text("Option A")]),
///   html.option([attribute.value("b")], [html.text("Option B")]),
/// ])
/// |> select.build
///
/// // A ghost select at small size
/// select.new()
/// |> select.ghost
/// |> select.sm
/// |> select.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI select](https://daisyui.com/components/select/)
import daisyui/tokens.{type Color, type Size, color_class, size_class}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates select configuration before being
/// converted to a Lustre element by `build/1`.
///
/// Create one with `new/0`, apply modifiers with the setter functions,
/// then call `build/1` to produce the final `Element(msg)`.
pub opaque type Select(msg) {
  Select(
    color: Option(Color),
    size: Option(Size),
    ghost: Bool,
    disabled: Bool,
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Create a new `Select` builder with no modifiers set.
///
/// Call setter functions to configure the select, then call `build/1`
/// to produce a Lustre element.
///
/// ```gleam
/// select.new()
/// |> select.primary
/// |> select.children([html.option([], [html.text("A")])])
/// |> select.build
/// ```
pub fn new() -> Select(msg) {
  Select(
    color: None,
    size: None,
    ghost: False,
    disabled: False,
    attrs: [],
    children: [],
  )
}

// ---------------------------------------------------------------------------
// Color modifiers
// ---------------------------------------------------------------------------

/// Apply the `neutral` colour — `select-neutral`.
pub fn neutral(s: Select(msg)) -> Select(msg) {
  Select(..s, color: Some(tokens.Neutral))
}

/// Apply the `primary` colour — `select-primary`.
pub fn primary(s: Select(msg)) -> Select(msg) {
  Select(..s, color: Some(tokens.Primary))
}

/// Apply the `secondary` colour — `select-secondary`.
pub fn secondary(s: Select(msg)) -> Select(msg) {
  Select(..s, color: Some(tokens.Secondary))
}

/// Apply the `accent` colour — `select-accent`.
pub fn accent(s: Select(msg)) -> Select(msg) {
  Select(..s, color: Some(tokens.Accent))
}

/// Apply the `info` colour — `select-info`.
pub fn info(s: Select(msg)) -> Select(msg) {
  Select(..s, color: Some(tokens.Info))
}

/// Apply the `success` colour — `select-success`.
pub fn success(s: Select(msg)) -> Select(msg) {
  Select(..s, color: Some(tokens.Success))
}

/// Apply the `warning` colour — `select-warning`.
pub fn warning(s: Select(msg)) -> Select(msg) {
  Select(..s, color: Some(tokens.Warning))
}

/// Apply the `error` colour — `select-error`.
pub fn error(s: Select(msg)) -> Select(msg) {
  Select(..s, color: Some(tokens.Error))
}

// ---------------------------------------------------------------------------
// Size modifiers
// ---------------------------------------------------------------------------

/// Apply extra-small size — `select-xs`.
pub fn xs(s: Select(msg)) -> Select(msg) {
  Select(..s, size: Some(tokens.XS))
}

/// Apply small size — `select-sm`.
pub fn sm(s: Select(msg)) -> Select(msg) {
  Select(..s, size: Some(tokens.SM))
}

/// Apply medium (default) size — `select-md`.
pub fn md(s: Select(msg)) -> Select(msg) {
  Select(..s, size: Some(tokens.MD))
}

/// Apply large size — `select-lg`.
pub fn lg(s: Select(msg)) -> Select(msg) {
  Select(..s, size: Some(tokens.LG))
}

/// Apply extra-large size — `select-xl`.
pub fn xl(s: Select(msg)) -> Select(msg) {
  Select(..s, size: Some(tokens.XL))
}

// ---------------------------------------------------------------------------
// Style modifiers
// ---------------------------------------------------------------------------

/// Apply the ghost style — `select-ghost`.
///
/// Ghost removes the border/background in the resting state.
pub fn ghost(s: Select(msg)) -> Select(msg) {
  Select(..s, ghost: True)
}

/// Mark the select as disabled.
///
/// This sets the `select-disabled` CSS class **and** the HTML `disabled`
/// attribute so the element is correctly inert for both CSS and assistive
/// technology.
pub fn disabled(s: Select(msg)) -> Select(msg) {
  Select(..s, disabled: True)
}

// ---------------------------------------------------------------------------
// Content / attribute modifiers
// ---------------------------------------------------------------------------

/// Merge additional Lustre attributes onto the `<select>` element.
///
/// Use this to attach event handlers, `id`, `name`, `value`, or any other
/// attribute that the builder doesn't have a dedicated setter for.
///
/// ```gleam
/// select.new()
/// |> select.attrs([
///   attribute.name("theme"),
///   event.on_input(UserChangedTheme),
/// ])
/// |> select.build
/// ```
pub fn attrs(s: Select(msg), a: List(Attribute(msg))) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, a))
}

/// Set the child `<option>` (or `<optgroup>`) elements.
///
/// ```gleam
/// select.new()
/// |> select.children([
///   html.option([attribute.value("light")], [html.text("Light")]),
///   html.option([attribute.value("dark")], [html.text("Dark")]),
/// ])
/// |> select.build
/// ```
pub fn children(s: Select(msg), c: List(Element(msg))) -> Select(msg) {
  Select(..s, children: c)
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

/// Fires `msg(value)` when the selected option changes.
pub fn on_change(s: Select(msg), msg: fn(String) -> msg) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, [event.on_change(msg)]))
}

/// Fires `msg` when the select receives focus.
pub fn on_focus(s: Select(msg), msg: msg) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, [event.on_focus(msg)]))
}

/// Fires `msg` when the select loses focus.
pub fn on_blur(s: Select(msg), msg: msg) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, [event.on_blur(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Convert the `Select` builder into a Lustre `Element`.
///
/// Renders a `<select class="select [color] [size] [ghost] [disabled]">` with
/// the configured children and attributes. When `disabled` is set, the HTML
/// `disabled` attribute is also applied.
pub fn build(s: Select(msg)) -> Element(msg) {
  let color_cls = option.map(s.color, color_class("select", _))
  let size_cls = option.map(s.size, size_class("select", _))
  let ghost_cls = case s.ghost {
    True -> Some("select-ghost")
    False -> None
  }
  let disabled_cls = case s.disabled {
    True -> Some("select-disabled")
    False -> None
  }

  let extra_classes =
    [color_cls, size_cls, ghost_cls, disabled_cls]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let class_str = case extra_classes {
    "" -> "select"
    _ -> "select " <> extra_classes
  }

  let base_attrs = [attribute.class(class_str), ..s.attrs]
  let all_attrs = case s.disabled {
    True -> [attribute.disabled(True), ..base_attrs]
    False -> base_attrs
  }

  html.select(all_attrs, s.children)
}
