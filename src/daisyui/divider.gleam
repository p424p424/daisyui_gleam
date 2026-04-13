/// A builder for DaisyUI divider elements.
///
/// A divider draws a line that separates content, with an optional label
/// centred on the line. By default it is **vertical** (separates elements
/// stacked on top of each other); use `horizontal/1` when the siblings sit
/// side-by-side in a flex row.
///
/// The component renders as a single `<div class="divider …">` element.
/// Any children you supply appear as the centred label — typically a short
/// text node like `"OR"` — but you can pass arbitrary elements.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a divider piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/divider
///
/// // Plain divider with no label
/// divider.new()
/// |> divider.build
///
/// // Vertical divider with a text label
/// divider.new()
/// |> divider.text("OR")
/// |> divider.build
///
/// // Horizontal primary divider, label pushed to the start
/// divider.new()
/// |> divider.horizontal
/// |> divider.primary
/// |> divider.placement_start
/// |> divider.text("Section")
/// |> divider.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI divider](https://daisyui.com/components/divider/)
import daisyui/tokens.{type Color, color_class}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// The axis along which the divider separates its siblings.
///
/// | Constructor  | Class               | Use when siblings are…          |
/// |--------------|---------------------|---------------------------------|
/// | `Vertical`   | *(default — none)*  | stacked (flex column / block)   |
/// | `Horizontal` | `divider-horizontal`| side-by-side (flex row)         |
pub type Direction {
  /// Separates vertically stacked elements. This is the DaisyUI default —
  /// no extra class is emitted.
  Vertical
  /// Separates horizontally adjacent elements. Maps to `divider-horizontal`.
  Horizontal
}

/// Where the divider label is placed relative to the line.
///
/// | Constructor | Class           | Effect                           |
/// |-------------|-----------------|----------------------------------|
/// | `Start`     | `divider-start` | Pushes label to the leading end  |
/// | `End`       | `divider-end`   | Pushes label to the trailing end |
///
/// Omit both (the default) to centre the label.
pub type DividerPlacement {
  /// Pushes the label to the leading end of the line. Maps to `divider-start`.
  Start
  /// Pushes the label to the trailing end of the line. Maps to `divider-end`.
  End
}

/// An opaque builder that accumulates divider configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Divider`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Divider(msg) {
  Divider(
    color: Option(Color),
    direction: Direction,
    placement: Option(DividerPlacement),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Divider` builder with vertical direction, no colour, no
/// label, and no extra attributes.
///
/// Chain setter functions to configure, then call `build/1` to produce a
/// Lustre element.
///
/// ```gleam
/// divider.new()
/// |> divider.primary
/// |> divider.text("OR")
/// |> divider.build
/// ```
pub fn new() -> Divider(msg) {
  Divider(
    color: None,
    direction: Vertical,
    placement: None,
    attrs: [],
    children: [],
  )
}

// ---------------------------------------------------------------------------
// Color
// ---------------------------------------------------------------------------

/// Sets the divider colour to `divider-neutral`.
pub fn neutral(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, color: Some(tokens.Neutral))
}

/// Sets the divider colour to `divider-primary`.
pub fn primary(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, color: Some(tokens.Primary))
}

/// Sets the divider colour to `divider-secondary`.
pub fn secondary(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, color: Some(tokens.Secondary))
}

/// Sets the divider colour to `divider-accent`.
pub fn accent(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, color: Some(tokens.Accent))
}

/// Sets the divider colour to `divider-success`.
pub fn success(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, color: Some(tokens.Success))
}

/// Sets the divider colour to `divider-warning`.
pub fn warning(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, color: Some(tokens.Warning))
}

/// Sets the divider colour to `divider-info`.
pub fn info(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, color: Some(tokens.Info))
}

/// Sets the divider colour to `divider-error`.
pub fn error(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, color: Some(tokens.Error))
}

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Use the **vertical** direction — separates elements stacked on top of
/// each other (flex column / block layout).
///
/// This is the default; call it explicitly only when overriding a previously
/// set `horizontal/1`.
///
/// ## Reference
/// - [DaisyUI divider](https://daisyui.com/components/divider/)
pub fn vertical(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, direction: Vertical)
}

/// Use the **horizontal** direction — separates elements sitting
/// side-by-side in a flex row. Maps to `divider-horizontal`.
///
/// ## Reference
/// - [DaisyUI divider](https://daisyui.com/components/divider/)
pub fn horizontal(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, direction: Horizontal)
}

// ---------------------------------------------------------------------------
// Placement
// ---------------------------------------------------------------------------

/// Push the divider label to the **start** of the line — `divider-start`.
///
/// ## Reference
/// - [DaisyUI divider](https://daisyui.com/components/divider/)
pub fn placement_start(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, placement: Some(Start))
}

/// Push the divider label to the **end** of the line — `divider-end`.
///
/// ## Reference
/// - [DaisyUI divider](https://daisyui.com/components/divider/)
pub fn placement_end(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, placement: Some(End))
}

// ---------------------------------------------------------------------------
// Attrs / Children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<div class="divider">` element.
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(d: Divider(msg), a: List(Attribute(msg))) -> Divider(msg) {
  Divider(..d, attrs: a)
}

/// Sets the label content to a single plain text node.
///
/// Shorthand for the common case of a short text label like `"OR"`.
/// Replaces any content previously set by `children/2`.
///
/// ```gleam
/// divider.new()
/// |> divider.text("OR")
/// |> divider.build
/// ```
pub fn text(d: Divider(msg), content: String) -> Divider(msg) {
  Divider(..d, children: [html.text(content)])
}

/// Sets the label content to an arbitrary list of Lustre elements.
///
/// Replaces any content previously set by `text/2`.
///
/// ## Reference
/// - [Lustre element module](https://hexdocs.pm/lustre/)
pub fn children(d: Divider(msg), ch: List(Element(msg))) -> Divider(msg) {
  Divider(..d, children: ch)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Divider` builder into a Lustre `Element(msg)`.
///
/// Assembles the class string from the direction, optional colour, and
/// optional placement, then renders:
///
/// ```html
/// <div class="divider [direction] [color] [placement]" …attrs>
///   …children…
/// </div>
/// ```
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI divider](https://daisyui.com/components/divider/)
pub fn build(d: Divider(msg)) -> Element(msg) {
  let direction_class = case d.direction {
    Vertical -> None
    Horizontal -> Some("divider-horizontal")
  }

  let component_class =
    [
      Some("divider"),
      direction_class,
      option.map(d.color, color_class("divider", _)),
      option.map(d.placement, fn(p) {
        case p {
          Start -> "divider-start"
          End -> "divider-end"
        }
      }),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.div([attribute.class(component_class), ..d.attrs], d.children)
}
