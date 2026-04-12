/// A builder for DaisyUI badge elements.
///
/// Badges inform the user of the status of specific data — counts,
/// labels, states, and tags. The component renders as a single
/// `<span class="badge">` with optional colour, style variant, and size
/// modifiers.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.span`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a badge piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/badge
///
/// // A small primary badge
/// badge.new()
/// |> badge.primary
/// |> badge.sm
/// |> badge.text("New")
/// |> badge.build
///
/// // A ghost outline badge at default size
/// badge.new()
/// |> badge.ghost
/// |> badge.text("Draft")
/// |> badge.build
///
/// // A soft error badge
/// badge.new()
/// |> badge.error
/// |> badge.soft
/// |> badge.text("Failed")
/// |> badge.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
import daisyui/tokens.{
  type Color, type Size, type Variant, color_class, size_class, variant_class,
}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates badge configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Badge`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Badge(msg) {
  Badge(
    color: Option(Color),
    variant: Option(Variant),
    size: Option(Size),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Badge` builder with no classes applied.
///
/// Defaults to a plain `badge` with no colour, style variant, size, extra
/// attributes, or children. Chain setter functions to configure it, then
/// call `build/1` to produce a Lustre element.
///
/// ```gleam
/// badge.new()
/// |> badge.success
/// |> badge.sm
/// |> badge.text("Active")
/// |> badge.build
/// ```
pub fn new() -> Badge(msg) {
  Badge(color: None, variant: None, size: None, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Color
// ---------------------------------------------------------------------------

/// Sets the badge colour to `badge-neutral`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn neutral(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, color: Some(tokens.Neutral))
}

/// Sets the badge colour to `badge-primary`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn primary(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, color: Some(tokens.Primary))
}

/// Sets the badge colour to `badge-secondary`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn secondary(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, color: Some(tokens.Secondary))
}

/// Sets the badge colour to `badge-accent`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn accent(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, color: Some(tokens.Accent))
}

/// Sets the badge colour to `badge-info` — informational blue.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn info(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, color: Some(tokens.Info))
}

/// Sets the badge colour to `badge-success` — success green.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn success(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, color: Some(tokens.Success))
}

/// Sets the badge colour to `badge-warning` — warning yellow/orange.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn warning(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, color: Some(tokens.Warning))
}

/// Sets the badge colour to `badge-error` — error red.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn error(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, color: Some(tokens.Error))
}

// ---------------------------------------------------------------------------
// Variant
// ---------------------------------------------------------------------------

/// Applies the `badge-outline` style — transparent background with a
/// solid border.
///
/// ## Reference
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
pub fn outline(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, variant: Some(tokens.Outline))
}

/// Applies the `badge-dash` style — transparent background with a dashed
/// border.
///
/// ## Reference
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
pub fn dash(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, variant: Some(tokens.Dash))
}

/// Applies the `badge-soft` style — a subtle tinted background.
///
/// ## Reference
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
pub fn soft(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, variant: Some(tokens.Soft))
}

/// Applies the `badge-ghost` style — no background or border by default.
///
/// ## Reference
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
pub fn ghost(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, variant: Some(tokens.Ghost))
}

// ---------------------------------------------------------------------------
// Size
// ---------------------------------------------------------------------------

/// Sets the badge size to `badge-xs` — extra small.
///
/// ## Reference
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
pub fn xs(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, size: Some(tokens.XS))
}

/// Sets the badge size to `badge-sm` — small.
///
/// ## Reference
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
pub fn sm(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, size: Some(tokens.SM))
}

/// Sets the badge size to `badge-md` — the default medium size.
///
/// ## Reference
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
pub fn md(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, size: Some(tokens.MD))
}

/// Sets the badge size to `badge-lg` — large.
///
/// ## Reference
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
pub fn lg(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, size: Some(tokens.LG))
}

/// Sets the badge size to `badge-xl` — extra large.
///
/// ## Reference
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
pub fn xl(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, size: Some(tokens.XL))
}

// ---------------------------------------------------------------------------
// Attrs / Children
// ---------------------------------------------------------------------------

/// Appends additional Lustre attributes to the badge element.
///
/// Multiple calls accumulate — later calls do not replace earlier ones.
/// Useful for attaching event handlers, IDs, ARIA attributes, or any other
/// HTML attribute not covered by the builder functions.
///
/// ```gleam
/// import lustre/attribute
///
/// badge.new()
/// |> badge.primary
/// |> badge.attrs([attribute.id("notif-count")])
/// |> badge.text("3")
/// |> badge.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(b: Badge(msg), extra: List(Attribute(msg))) -> Badge(msg) {
  Badge(..b, attrs: list.append(b.attrs, extra))
}

/// Sets the children to an arbitrary list of Lustre elements.
///
/// Replaces any children previously set by `children/2` or `text/2`.
/// Use when you need to nest elements inside the badge — for example,
/// an icon alongside a label.
///
/// ```gleam
/// badge.new()
/// |> badge.success
/// |> badge.children([
///   html.span([attribute.class("icon")], []),
///   html.text("Verified"),
/// ])
/// |> badge.build
/// ```
///
/// ## Reference
/// - [Lustre element module](https://hexdocs.pm/lustre/)
pub fn children(b: Badge(msg), ch: List(Element(msg))) -> Badge(msg) {
  Badge(..b, children: ch)
}

/// Sets the children to a single plain text node.
///
/// Shorthand for the common case of rendering a string label. Replaces
/// any children previously set by `children/2` or a prior `text/2` call.
///
/// ```gleam
/// badge.new()
/// |> badge.info
/// |> badge.text("Beta")
/// |> badge.build
/// ```
pub fn text(b: Badge(msg), content: String) -> Badge(msg) {
  Badge(..b, children: [html.text(content)])
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Badge` builder into a Lustre `Element(msg)`.
///
/// Assembles the DaisyUI class string from the `badge` base class plus
/// any colour, variant, and size modifiers, then renders a `<span>` with
/// the configured attributes and children.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ```gleam
/// // In your Lustre view function:
/// pub fn view(model: Model) -> Element(Msg) {
///   html.div([], [
///     html.span([], [html.text("Status")]),
///     badge.new()
///     |> badge.success
///     |> badge.soft
///     |> badge.sm
///     |> badge.text("Online")
///     |> badge.build,
///   ])
/// }
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
pub fn build(b: Badge(msg)) -> Element(msg) {
  let classes =
    [
      Some("badge"),
      option.map(b.color, color_class("badge", _)),
      option.map(b.variant, variant_class("badge", _)),
      option.map(b.size, size_class("badge", _)),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.span([attribute.class(classes), ..b.attrs], b.children)
}
