/// A builder for DaisyUI button elements.
///
/// Buttons allow the user to take actions or make choices. The component
/// renders as a `<button>` element and supports colours, style variants,
/// sizes, and a set of layout and behaviour modifiers.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.button`) and pass them `Attribute`
/// > and child `Element` lists. This module wraps that pattern in a builder
/// > so you can configure a button piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/button
/// import lustre/event
///
/// // A primary button that fires a message on click
/// button.new()
/// |> button.primary
/// |> button.on_click(UserClickedSave)
/// |> button.text("Save")
/// |> button.build
///
/// // A small ghost button
/// button.new()
/// |> button.ghost
/// |> button.sm
/// |> button.text("Cancel")
/// |> button.build
///
/// // A full-width disabled button
/// button.new()
/// |> button.primary
/// |> button.block
/// |> button.disabled
/// |> button.text("Loading…")
/// |> button.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI button](https://daisyui.com/components/button/)
import daisyui/tokens.{
  type Color, type Size, color_class, size_class,
}
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

/// The visual style variant for the button.
///
/// | Variant   | Class        | Effect                                    |
/// |-----------|--------------|-------------------------------------------|
/// | `Outline` | `btn-outline`| Transparent background, solid border      |
/// | `Dash`    | `btn-dash`   | Transparent background, dashed border     |
/// | `Soft`    | `btn-soft`   | Subtle tinted background                  |
/// | `Ghost`   | `btn-ghost`  | No background or border until hover/focus |
/// | `Link`    | `btn-link`   | Styled as a text hyperlink                |
///
/// Omit to use the default filled style.
pub type BtnStyle {
  /// Transparent background with a solid border. Maps to `btn-outline`.
  Outline
  /// Transparent background with a dashed border. Maps to `btn-dash`.
  Dash
  /// Subtle tinted background — lower visual weight. Maps to `btn-soft`.
  Soft
  /// No visible background or border in the resting state. Maps to
  /// `btn-ghost`.
  Ghost
  /// Renders the button with hyperlink styling. Maps to `btn-link`.
  Link
}

/// An opaque builder that accumulates button configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Button`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Button(msg) {
  Button(
    color: Option(Color),
    style: Option(BtnStyle),
    size: Option(Size),
    active: Bool,
    disabled: Bool,
    wide: Bool,
    block: Bool,
    square: Bool,
    circle: Bool,
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Button` builder with no classes applied.
///
/// Defaults to a plain `btn` with no colour, style variant, size, or
/// modifier. Chain setter functions to configure it, then call `build/1`
/// to produce a Lustre element.
///
/// ```gleam
/// button.new()
/// |> button.primary
/// |> button.lg
/// |> button.text("Get started")
/// |> button.build
/// ```
pub fn new() -> Button(msg) {
  Button(
    color: None,
    style: None,
    size: None,
    active: False,
    disabled: False,
    wide: False,
    block: False,
    square: False,
    circle: False,
    attrs: [],
    children: [],
  )
}

// ---------------------------------------------------------------------------
// Color
// ---------------------------------------------------------------------------

/// Sets the button colour to `btn-neutral`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn neutral(b: Button(msg)) -> Button(msg) {
  Button(..b, color: Some(tokens.Neutral))
}

/// Sets the button colour to `btn-primary`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn primary(b: Button(msg)) -> Button(msg) {
  Button(..b, color: Some(tokens.Primary))
}

/// Sets the button colour to `btn-secondary`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn secondary(b: Button(msg)) -> Button(msg) {
  Button(..b, color: Some(tokens.Secondary))
}

/// Sets the button colour to `btn-accent`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn accent(b: Button(msg)) -> Button(msg) {
  Button(..b, color: Some(tokens.Accent))
}

/// Sets the button colour to `btn-info` — informational blue.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn info(b: Button(msg)) -> Button(msg) {
  Button(..b, color: Some(tokens.Info))
}

/// Sets the button colour to `btn-success` — success green.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn success(b: Button(msg)) -> Button(msg) {
  Button(..b, color: Some(tokens.Success))
}

/// Sets the button colour to `btn-warning` — warning yellow/orange.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn warning(b: Button(msg)) -> Button(msg) {
  Button(..b, color: Some(tokens.Warning))
}

/// Sets the button colour to `btn-error` — error red.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn error(b: Button(msg)) -> Button(msg) {
  Button(..b, color: Some(tokens.Error))
}

// ---------------------------------------------------------------------------
// Style
// ---------------------------------------------------------------------------

/// Applies `btn-outline` — transparent background with a solid border.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn outline(b: Button(msg)) -> Button(msg) {
  Button(..b, style: Some(Outline))
}

/// Applies `btn-dash` — transparent background with a dashed border.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn dash(b: Button(msg)) -> Button(msg) {
  Button(..b, style: Some(Dash))
}

/// Applies `btn-soft` — a subtle tinted background.
///
/// Lower visual weight than a filled button. Good for secondary actions.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn soft(b: Button(msg)) -> Button(msg) {
  Button(..b, style: Some(Soft))
}

/// Applies `btn-ghost` — no background or border in the resting state.
///
/// The button only becomes visually prominent on hover or focus. Useful
/// for toolbar actions or low-priority controls.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn ghost(b: Button(msg)) -> Button(msg) {
  Button(..b, style: Some(Ghost))
}

/// Applies `btn-link` — styles the button as a text hyperlink.
///
/// The button still behaves as a button (focusable, fires `on_click`)
/// but looks like an `<a>` element. Useful when you need button semantics
/// with link visual styling.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn link(b: Button(msg)) -> Button(msg) {
  Button(..b, style: Some(Link))
}

// ---------------------------------------------------------------------------
// Size
// ---------------------------------------------------------------------------

/// Sets the button size to `btn-xs` — extra small.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn xs(b: Button(msg)) -> Button(msg) {
  Button(..b, size: Some(tokens.XS))
}

/// Sets the button size to `btn-sm` — small.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn sm(b: Button(msg)) -> Button(msg) {
  Button(..b, size: Some(tokens.SM))
}

/// Sets the button size to `btn-md` — the default medium size.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn md(b: Button(msg)) -> Button(msg) {
  Button(..b, size: Some(tokens.MD))
}

/// Sets the button size to `btn-lg` — large.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn lg(b: Button(msg)) -> Button(msg) {
  Button(..b, size: Some(tokens.LG))
}

/// Sets the button size to `btn-xl` — extra large.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn xl(b: Button(msg)) -> Button(msg) {
  Button(..b, size: Some(tokens.XL))
}

// ---------------------------------------------------------------------------
// Behaviour
// ---------------------------------------------------------------------------

/// Applies the `btn-active` class — forces the pressed/active appearance.
///
/// Use when the button represents a currently selected or active state,
/// such as a toggle that is on.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn active(b: Button(msg)) -> Button(msg) {
  Button(..b, active: True)
}

/// Applies the `btn-disabled` class and the HTML `disabled` attribute.
///
/// Both the visual state and the interactive state are disabled. Screen
/// readers will announce the button as unavailable.
///
/// > **Note:** Attaching an `event.on_click` handler via `attrs/2` will
/// > have no effect while the button is disabled, as browsers suppress
/// > click events on disabled form elements.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn disabled(b: Button(msg)) -> Button(msg) {
  Button(..b, disabled: True)
}

// ---------------------------------------------------------------------------
// Layout modifiers
// ---------------------------------------------------------------------------

/// Applies `btn-wide` — adds extra horizontal padding.
///
/// Good for prominent call-to-action buttons that should be visually
/// wider than their label alone would make them.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn wide(b: Button(msg)) -> Button(msg) {
  Button(..b, wide: True)
}

/// Applies `btn-block` — stretches the button to full container width.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn block(b: Button(msg)) -> Button(msg) {
  Button(..b, block: True)
}

/// Applies `btn-square` — forces a 1:1 aspect ratio.
///
/// Use for icon-only buttons where the label should be visually hidden
/// or absent.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn square(b: Button(msg)) -> Button(msg) {
  Button(..b, square: True)
}

/// Applies `btn-circle` — forces a 1:1 aspect ratio with fully rounded
/// corners.
///
/// Use for circular icon buttons, such as floating action buttons.
///
/// ## Reference
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn circle(b: Button(msg)) -> Button(msg) {
  Button(..b, circle: True)
}

// ---------------------------------------------------------------------------
// Attrs / Children
// ---------------------------------------------------------------------------

/// Appends additional Lustre attributes to the button element.
///
/// Multiple calls accumulate — later calls do not replace earlier ones.
/// Use to attach event handlers, IDs, `type` overrides, ARIA attributes,
/// or any other HTML attribute not covered by the builder functions.
///
/// ```gleam
/// import lustre/event
///
/// button.new()
/// |> button.primary
/// |> button.attrs([
///   attribute.type_("submit"),
///   event.on_click(UserSubmittedForm),
/// ])
/// |> button.text("Submit")
/// |> button.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(b: Button(msg), extra: List(Attribute(msg))) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, extra))
}

/// Sets the children to an arbitrary list of Lustre elements.
///
/// Replaces any children previously set by `children/2` or `text/2`. Use
/// when the button label includes an icon or other inline elements.
///
/// ```gleam
/// button.new()
/// |> button.primary
/// |> button.children([my_icon, html.text("Save")])
/// |> button.build
/// ```
///
/// ## Reference
/// - [Lustre element module](https://hexdocs.pm/lustre/)
pub fn children(b: Button(msg), ch: List(Element(msg))) -> Button(msg) {
  Button(..b, children: ch)
}

/// Sets the children to a single plain text node.
///
/// Shorthand for the common case of a text-only button label. Replaces
/// any children previously set by `children/2` or a prior `text/2` call.
///
/// ```gleam
/// button.new()
/// |> button.error
/// |> button.text("Delete")
/// |> button.build
/// ```
pub fn text(b: Button(msg), label: String) -> Button(msg) {
  Button(..b, children: [html.text(label)])
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

/// Fires `msg` when the button is clicked.
pub fn on_click(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_click(msg)]))
}

/// Fires `msg` when a mouse button is pressed down over the button.
pub fn on_mouse_down(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_mouse_down(msg)]))
}

/// Fires `msg` when a mouse button is released over the button.
pub fn on_mouse_up(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_mouse_up(msg)]))
}

/// Fires `msg` when the pointer enters the button's bounding box.
pub fn on_mouse_enter(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_mouse_enter(msg)]))
}

/// Fires `msg` when the pointer leaves the button's bounding box.
pub fn on_mouse_leave(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_mouse_leave(msg)]))
}

/// Fires `msg` when the button receives focus.
pub fn on_focus(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_focus(msg)]))
}

/// Fires `msg` when the button loses focus.
pub fn on_blur(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_blur(msg)]))
}

/// Fires `msg(key)` when a key is pressed while the button is focused.
pub fn on_keydown(b: Button(msg), msg: fn(String) -> msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_keydown(msg)]))
}

/// Fires `msg(key)` when a key is released while the button is focused.
pub fn on_keyup(b: Button(msg), msg: fn(String) -> msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_keyup(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Button` builder into a Lustre `Element(msg)`.
///
/// Assembles the DaisyUI class string from the `btn` base class plus all
/// configured modifiers, applies the HTML `disabled` attribute when
/// `disabled/1` was called, then renders a `<button>` element.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ```gleam
/// // In your Lustre view function:
/// pub fn view(model: Model) -> Element(Msg) {
///   html.div([attribute.class("flex gap-2")], [
///     button.new()
///     |> button.primary
///     |> button.on_click(UserSaved)
///     |> button.text("Save")
///     |> button.build,
///
///     button.new()
///     |> button.ghost
///     |> button.on_click(UserCancelled)
///     |> button.text("Cancel")
///     |> button.build,
///   ])
/// }
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI button](https://daisyui.com/components/button/)
pub fn build(b: Button(msg)) -> Element(msg) {
  let classes =
    [
      Some("btn"),
      option.map(b.color, color_class("btn", _)),
      option.map(b.style, fn(s) {
        case s {
          Outline -> "btn-outline"
          Dash -> "btn-dash"
          Soft -> "btn-soft"
          Ghost -> "btn-ghost"
          Link -> "btn-link"
        }
      }),
      option.map(b.size, size_class("btn", _)),
      case b.active { True -> Some("btn-active") False -> None },
      case b.disabled { True -> Some("btn-disabled") False -> None },
      case b.wide { True -> Some("btn-wide") False -> None },
      case b.block { True -> Some("btn-block") False -> None },
      case b.square { True -> Some("btn-square") False -> None },
      case b.circle { True -> Some("btn-circle") False -> None },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let disabled_attrs = case b.disabled {
    True -> [attribute.disabled(True)]
    False -> []
  }

  html.button(
    [attribute.class(classes), ..list.append(disabled_attrs, b.attrs)],
    b.children,
  )
}
