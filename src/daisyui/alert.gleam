/// A builder for DaisyUI alert elements.
///
/// Alerts inform users about important events — errors, warnings, success
/// confirmations, or general information. The component is a single
/// `<div role="alert">` wrapper; you supply the icon and message as
/// children.
///
/// Style, colour, and layout direction are all controlled by modifier
/// classes from DaisyUI's token system, keeping alerts visually consistent
/// with other components in the library.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure an alert piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/alert
/// import lustre/element/html
///
/// // A soft success alert
/// alert.new()
/// |> alert.success
/// |> alert.soft
/// |> alert.children([html.span([], [html.text("Changes saved.")])])
/// |> alert.build
///
/// // A dashed error alert laid out vertically
/// alert.new()
/// |> alert.error
/// |> alert.dash
/// |> alert.vertical
/// |> alert.children([html.span([], [html.text("Something went wrong.")])])
/// |> alert.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI alert](https://daisyui.com/components/alert/)
import daisyui/tokens.{type Color, type Variant, color_class, variant_class}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// Controls whether the alert lays its children out horizontally or
/// vertically.
///
/// - `Horizontal` — children are arranged in a row. Maps to
///   `alert-horizontal`. A good default for wider screens.
/// - `Vertical` — children stack in a column. Maps to `alert-vertical`.
///   Better suited to narrow viewports or mobile layouts.
///
/// When neither is set the browser's default flex direction is used (which
/// DaisyUI currently renders as horizontal).
pub type AlertDirection {
  /// Children arranged in a row. Maps to `alert-horizontal`.
  Horizontal
  /// Children stacked in a column. Maps to `alert-vertical`.
  Vertical
}

/// An opaque builder that accumulates alert configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match an `Alert`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Alert(msg) {
  Alert(
    color: Option(Color),
    variant: Option(Variant),
    direction: Option(AlertDirection),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Alert` builder with no classes applied.
///
/// Defaults to a plain `alert` with no colour, style variant, layout
/// direction, extra attributes, or children. Chain setter functions to
/// configure it, then call `build/1` to produce a Lustre element.
///
/// ```gleam
/// alert.new()
/// |> alert.info
/// |> alert.children([html.span([], [html.text("3 messages waiting.")])])
/// |> alert.build
/// ```
pub fn new() -> Alert(msg) {
  Alert(color: None, variant: None, direction: None, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Color
// ---------------------------------------------------------------------------

/// Sets the alert colour to `alert-info` — informational blue.
///
/// Use for tips, hints, and non-critical messages that give the user
/// useful context. Resolves via `--color-info`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn info(a: Alert(msg)) -> Alert(msg) {
  Alert(..a, color: Some(tokens.Info))
}

/// Sets the alert colour to `alert-success` — success green.
///
/// Use to confirm that an action completed successfully. Resolves via
/// `--color-success`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn success(a: Alert(msg)) -> Alert(msg) {
  Alert(..a, color: Some(tokens.Success))
}

/// Sets the alert colour to `alert-warning` — warning yellow/orange.
///
/// Use to signal caution or a recoverable issue the user should be aware
/// of. Resolves via `--color-warning`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn warning(a: Alert(msg)) -> Alert(msg) {
  Alert(..a, color: Some(tokens.Warning))
}

/// Sets the alert colour to `alert-error` — error red.
///
/// Use for validation failures, destructive confirmations, or any
/// unrecoverable error state. Resolves via `--color-error`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn error(a: Alert(msg)) -> Alert(msg) {
  Alert(..a, color: Some(tokens.Error))
}

// ---------------------------------------------------------------------------
// Variant
// ---------------------------------------------------------------------------

/// Applies the `alert-soft` style — a subtle tinted background.
///
/// Lower visual weight than the default filled alert. Good for inline
/// notices that should not dominate the page.
///
/// ## Reference
/// - [DaisyUI alert](https://daisyui.com/components/alert/)
pub fn soft(a: Alert(msg)) -> Alert(msg) {
  Alert(..a, variant: Some(tokens.Soft))
}

/// Applies the `alert-outline` style — transparent background with a
/// solid border.
///
/// ## Reference
/// - [DaisyUI alert](https://daisyui.com/components/alert/)
pub fn outline(a: Alert(msg)) -> Alert(msg) {
  Alert(..a, variant: Some(tokens.Outline))
}

/// Applies the `alert-dash` style — transparent background with a dashed
/// border.
///
/// ## Reference
/// - [DaisyUI alert](https://daisyui.com/components/alert/)
pub fn dash(a: Alert(msg)) -> Alert(msg) {
  Alert(..a, variant: Some(tokens.Dash))
}

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Lays out alert children in a row (`alert-horizontal`).
///
/// A good default for wider viewports — icon and message sit side by side.
///
/// ## Reference
/// - [DaisyUI alert](https://daisyui.com/components/alert/)
pub fn horizontal(a: Alert(msg)) -> Alert(msg) {
  Alert(..a, direction: Some(Horizontal))
}

/// Stacks alert children in a column (`alert-vertical`).
///
/// Suits narrow viewports and mobile layouts where a horizontal arrangement
/// would feel cramped.
///
/// ## Reference
/// - [DaisyUI alert](https://daisyui.com/components/alert/)
pub fn vertical(a: Alert(msg)) -> Alert(msg) {
  Alert(..a, direction: Some(Vertical))
}

// ---------------------------------------------------------------------------
// Attrs / Children
// ---------------------------------------------------------------------------

/// Appends additional Lustre attributes to the alert element.
///
/// Multiple calls accumulate — later calls do not replace earlier ones.
/// Useful for attaching event handlers, IDs, ARIA attributes, or any other
/// HTML attribute not covered by the builder functions.
///
/// ```gleam
/// import lustre/attribute
///
/// alert.new()
/// |> alert.warning
/// |> alert.attrs([attribute.id("disk-space-warning")])
/// |> alert.children([html.span([], [html.text("Low disk space.")])])
/// |> alert.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(a: Alert(msg), extra: List(Attribute(msg))) -> Alert(msg) {
  Alert(..a, attrs: list.append(a.attrs, extra))
}

/// Sets the children of the alert element.
///
/// Replaces any previously set children. Typically you would pass an icon
/// element and one or more text nodes.
///
/// ```gleam
/// alert.new()
/// |> alert.info
/// |> alert.children([
///   html.span([], [html.text("12 unread messages. Tap to see.")]),
/// ])
/// |> alert.build
/// ```
pub fn children(a: Alert(msg), ch: List(Element(msg))) -> Alert(msg) {
  Alert(..a, children: ch)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Alert` builder into a Lustre `Element(msg)`.
///
/// Assembles the DaisyUI class string from the `alert` base class plus any
/// colour, variant, and direction modifiers, then renders a
/// `<div role="alert">` with the configured attributes and children.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ```gleam
/// // In your Lustre view function:
/// pub fn view(model: Model) -> Element(Msg) {
///   html.div([], [
///     alert.new()
///     |> alert.error
///     |> alert.soft
///     |> alert.children([
///       html.span([], [html.text(model.error_message)]),
///     ])
///     |> alert.build,
///   ])
/// }
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI alert](https://daisyui.com/components/alert/)
pub fn build(a: Alert(msg)) -> Element(msg) {
  let classes =
    [
      Some("alert"),
      option.map(a.color, color_class("alert", _)),
      option.map(a.variant, variant_class("alert", _)),
      option.map(a.direction, fn(d) {
        case d {
          Horizontal -> "alert-horizontal"
          Vertical -> "alert-vertical"
        }
      }),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let all_attrs = [attribute.class(classes), attribute.role("alert"), ..a.attrs]

  html.div(all_attrs, a.children)
}
