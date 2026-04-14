/// Builders for DaisyUI indicator elements.
///
/// An indicator places a small overlay element (badge, status dot, button,
/// text) on the corner of another element. It consists of two parts:
///
/// - **`Indicator`** — the `<div class="indicator">` container, which holds
///   both the indicator items and the main content.
/// - **`IndicatorItem`** — a `<span class="indicator-item …">` element with
///   horizontal (`start` / `center` / `end`) and vertical (`top` / `middle` /
///   `bottom`) placement modifiers.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/indicator
/// import lustre/element/html
/// import lustre/attribute
///
/// indicator.new()
/// |> indicator.children([
///   indicator.item_new([html.text("New")])
///     |> indicator.item_build,
///   html.div([attribute.class("bg-base-300 grid h-32 w-32 place-items-center")], [
///     html.text("content"),
///   ]),
/// ])
/// |> indicator.build
/// ```
///
/// ## Reference
/// - [DaisyUI indicator](https://daisyui.com/components/indicator/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// Horizontal placement of the indicator item.
///
/// | Variant | Class              | Effect                          |
/// |---------|--------------------|---------------------------------|
/// | `Start` | `indicator-start`  | Align to the start (left in LTR)|
/// | `Center`| `indicator-center` | Align to the center             |
/// | `End`   | `indicator-end`    | Align to the end [Default]      |
pub type IndicatorH {
  Start
  HCenter
  End
}

/// Vertical placement of the indicator item.
///
/// | Variant  | Class               | Effect                      |
/// |----------|---------------------|-----------------------------|
/// | `Top`    | `indicator-top`     | Align to the top [Default]  |
/// | `Middle` | `indicator-middle`  | Align to the middle         |
/// | `Bottom` | `indicator-bottom`  | Align to the bottom         |
pub type IndicatorV {
  Top
  VMiddle
  Bottom
}

/// An opaque builder for the indicator container (`<div class="indicator">`).
pub opaque type Indicator(msg) {
  Indicator(attrs: List(Attribute(msg)), children: List(Element(msg)))
}

/// An opaque builder for a single indicator item
/// (`<span class="indicator-item …">`).
pub opaque type IndicatorItem(msg) {
  IndicatorItem(
    h: Option(IndicatorH),
    v: Option(IndicatorV),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Indicator constructor
// ---------------------------------------------------------------------------

/// Creates a new `Indicator` container builder.
///
/// ```gleam
/// indicator.new()
/// |> indicator.children([
///   indicator.item_new([html.text("12")])
///     |> indicator.item_build,
///   html.button([attribute.class("btn")], [html.text("inbox")]),
/// ])
/// |> indicator.build
/// ```
pub fn new() -> Indicator(msg) {
  Indicator(attrs: [], children: [])
}

/// Merges additional Lustre attributes onto the `<div class="indicator">`.
///
/// Use this to add extra classes such as `"avatar"` when combining indicator
/// with other DaisyUI components:
///
/// ```gleam
/// indicator.new()
/// |> indicator.attrs([attribute.class("avatar")])
/// |> indicator.children([…])
/// |> indicator.build
/// ```
pub fn attrs(ind: Indicator(msg), a: List(Attribute(msg))) -> Indicator(msg) {
  Indicator(..ind, attrs: a)
}

/// Sets all children of the indicator container.
///
/// Children should include both the indicator item elements (built with
/// `item_build/1`) and the main content element.
///
/// ```gleam
/// indicator.new()
/// |> indicator.children([
///   indicator.item_new([html.text("New")])
///     |> indicator.item_top
///     |> indicator.item_end
///     |> indicator.item_build,
///   html.div([attribute.class("card …")], […]),
/// ])
/// |> indicator.build
/// ```
pub fn children(
  ind: Indicator(msg),
  c: List(Element(msg)),
) -> Indicator(msg) {
  Indicator(..ind, children: c)
}

/// Converts the `Indicator` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <div class="indicator" …attrs>
///   …children
/// </div>
/// ```
pub fn build(ind: Indicator(msg)) -> Element(msg) {
  html.div([attribute.class("indicator"), ..ind.attrs], ind.children)
}

// ---------------------------------------------------------------------------
// IndicatorItem constructor
// ---------------------------------------------------------------------------

/// Creates a new `IndicatorItem` builder with the given children.
///
/// By default the item renders at the top-end corner (DaisyUI defaults).
/// Use the placement setters to override.
///
/// ```gleam
/// indicator.item_new([html.text("12")])
/// |> indicator.item_attrs([attribute.class("badge badge-secondary")])
/// |> indicator.item_build
/// ```
pub fn item_new(children: List(Element(msg))) -> IndicatorItem(msg) {
  IndicatorItem(h: None, v: None, attrs: [], children: children)
}

// ---------------------------------------------------------------------------
// IndicatorItem — horizontal placement
// ---------------------------------------------------------------------------

/// Aligns the item to the **start** (left in LTR) — adds `indicator-start`.
pub fn item_start(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, h: Some(Start))
}

/// Aligns the item to the **horizontal center** — adds `indicator-center`.
pub fn item_h_center(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, h: Some(HCenter))
}

/// Aligns the item to the **end** (right in LTR) — adds `indicator-end`.
///
/// This is DaisyUI's default; call it only when overriding a previously set
/// `item_start/1` or `item_h_center/1`.
pub fn item_end(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, h: Some(End))
}

// ---------------------------------------------------------------------------
// IndicatorItem — vertical placement
// ---------------------------------------------------------------------------

/// Aligns the item to the **top** — adds `indicator-top`.
///
/// This is DaisyUI's default; call it only when overriding a previously set
/// vertical modifier.
pub fn item_top(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, v: Some(Top))
}

/// Aligns the item to the **vertical middle** — adds `indicator-middle`.
pub fn item_v_middle(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, v: Some(VMiddle))
}

/// Aligns the item to the **bottom** — adds `indicator-bottom`.
pub fn item_bottom(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, v: Some(Bottom))
}

// ---------------------------------------------------------------------------
// IndicatorItem — attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<span class="indicator-item …">`.
///
/// Use this to apply badge classes or other styling:
///
/// ```gleam
/// indicator.item_new([html.text("12")])
/// |> indicator.item_attrs([attribute.class("badge badge-secondary")])
/// |> indicator.item_build
/// ```
pub fn item_attrs(
  i: IndicatorItem(msg),
  a: List(Attribute(msg)),
) -> IndicatorItem(msg) {
  IndicatorItem(..i, attrs: a)
}

// ---------------------------------------------------------------------------
// IndicatorItem — build
// ---------------------------------------------------------------------------

/// Converts the `IndicatorItem` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <span class="indicator-item [indicator-top|middle|bottom] [indicator-start|center|end]" …attrs>
///   …children
/// </span>
/// ```
pub fn item_build(i: IndicatorItem(msg)) -> Element(msg) {
  let h_class = case i.h {
    Some(Start) -> Some("indicator-start")
    Some(HCenter) -> Some("indicator-center")
    Some(End) -> Some("indicator-end")
    None -> None
  }
  let v_class = case i.v {
    Some(Top) -> Some("indicator-top")
    Some(VMiddle) -> Some("indicator-middle")
    Some(Bottom) -> Some("indicator-bottom")
    None -> None
  }
  let class =
    [Some("indicator-item"), v_class, h_class]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.span([attribute.class(class), ..i.attrs], i.children)
}
