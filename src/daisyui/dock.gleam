/// Builders for DaisyUI dock (bottom navigation bar) elements.
///
/// The dock component sticks to the bottom of the screen and provides
/// navigation items. It renders as a `<div class="dock">` containing
/// `<button>` elements, each of which can hold an icon and an optional
/// `<span class="dock-label">` text label.
///
/// This module exposes **two builders**:
///
/// - `Dock` — the outer container. Configure size and extra attributes,
///   then pass a list of built `DockItem` elements via `items/2`.
/// - `DockItem` — a single navigation button. Configure active state,
///   icon children, an optional label, and extra attributes, then call
///   `item_build/1` to turn it into an `Element`.
///
/// > **iOS note:** Add `<meta name="viewport" content="viewport-fit=cover">`
/// > to your HTML `<head>` for correct safe-area inset behaviour on iOS.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a dock piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/dock
///
/// dock.new()
/// |> dock.items([
///   dock.item_new()
///     |> dock.item_children([home_icon()])
///     |> dock.item_label("Home")
///     |> dock.item_build,
///   dock.item_new()
///     |> dock.item_active
///     |> dock.item_children([inbox_icon()])
///     |> dock.item_label("Inbox")
///     |> dock.item_build,
///   dock.item_new()
///     |> dock.item_children([settings_icon()])
///     |> dock.item_label("Settings")
///     |> dock.item_build,
/// ])
/// |> dock.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI dock](https://daisyui.com/components/dock/)
import daisyui/tokens.{type Size, size_class}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types — Dock (container)
// ---------------------------------------------------------------------------

/// An opaque builder for the dock container element.
///
/// Create with `new/0`, configure with size setters and `attrs/2`, supply
/// navigation items with `items/2`, then call `build/1`.
pub opaque type Dock(msg) {
  Dock(
    size: Option(Size),
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Types — DockItem
// ---------------------------------------------------------------------------

/// An opaque builder for a single dock navigation item (`<button>`).
///
/// Create with `item_new/0`, configure with `item_active/1`,
/// `item_children/2`, `item_label/2`, and `item_attrs/2`, then call
/// `item_build/1` to produce an `Element` to pass to `items/2`.
pub opaque type DockItem(msg) {
  DockItem(
    active: Bool,
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
    label: Option(String),
  )
}

// ---------------------------------------------------------------------------
// Dock constructor
// ---------------------------------------------------------------------------

/// Creates a new `Dock` builder with no size override, no extra attributes,
/// and an empty items list.
///
/// ```gleam
/// dock.new()
/// |> dock.sm
/// |> dock.items([…])
/// |> dock.build
/// ```
pub fn new() -> Dock(msg) {
  Dock(size: None, attrs: [], items: [])
}

// ---------------------------------------------------------------------------
// Dock size
// ---------------------------------------------------------------------------

/// Sets the dock size to `dock-xs`.
pub fn xs(d: Dock(msg)) -> Dock(msg) {
  Dock(..d, size: Some(tokens.XS))
}

/// Sets the dock size to `dock-sm`.
pub fn sm(d: Dock(msg)) -> Dock(msg) {
  Dock(..d, size: Some(tokens.SM))
}

/// Sets the dock size to `dock-md` (the default).
pub fn md(d: Dock(msg)) -> Dock(msg) {
  Dock(..d, size: Some(tokens.MD))
}

/// Sets the dock size to `dock-lg`.
pub fn lg(d: Dock(msg)) -> Dock(msg) {
  Dock(..d, size: Some(tokens.LG))
}

/// Sets the dock size to `dock-xl`.
pub fn xl(d: Dock(msg)) -> Dock(msg) {
  Dock(..d, size: Some(tokens.XL))
}

// ---------------------------------------------------------------------------
// Dock attrs / items
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<div class="dock">`.
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(d: Dock(msg), a: List(Attribute(msg))) -> Dock(msg) {
  Dock(..d, attrs: a)
}

/// Sets the list of navigation item elements rendered inside the dock.
///
/// Pass a list of elements produced by `item_build/1`.
///
/// ```gleam
/// dock.new()
/// |> dock.items([
///   dock.item_new() |> dock.item_children([icon()]) |> dock.item_build,
/// ])
/// |> dock.build
/// ```
pub fn items(d: Dock(msg), i: List(Element(msg))) -> Dock(msg) {
  Dock(..d, items: i)
}

// ---------------------------------------------------------------------------
// Dock build
// ---------------------------------------------------------------------------

/// Converts the `Dock` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <div class="dock [size]" …attrs>
///   …items…
/// </div>
/// ```
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI dock](https://daisyui.com/components/dock/)
pub fn build(d: Dock(msg)) -> Element(msg) {
  let component_class =
    [Some("dock"), option.map(d.size, size_class("dock", _))]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.div([attribute.class(component_class), ..d.attrs], d.items)
}

// ---------------------------------------------------------------------------
// DockItem constructor
// ---------------------------------------------------------------------------

/// Creates a new `DockItem` builder — inactive, no children, no label,
/// and no extra attributes.
///
/// ```gleam
/// dock.item_new()
/// |> dock.item_active
/// |> dock.item_children([icon()])
/// |> dock.item_label("Home")
/// |> dock.item_build
/// ```
pub fn item_new() -> DockItem(msg) {
  DockItem(active: False, attrs: [], children: [], label: None)
}

// ---------------------------------------------------------------------------
// DockItem modifiers
// ---------------------------------------------------------------------------

/// Marks the item as the currently active navigation destination —
/// adds `dock-active` to the `<button>`.
///
/// ## Reference
/// - [DaisyUI dock](https://daisyui.com/components/dock/)
pub fn item_active(i: DockItem(msg)) -> DockItem(msg) {
  DockItem(..i, active: True)
}

/// Merges additional Lustre attributes onto the `<button>` element.
///
/// Use this for event handlers (`event.on_click`), `aria-label`, or any
/// other attribute not covered by the builder setters.
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn item_attrs(i: DockItem(msg), a: List(Attribute(msg))) -> DockItem(msg) {
  DockItem(..i, attrs: a)
}

/// Sets the icon (or other content) rendered inside the button, before
/// the label.
///
/// Typically a single SVG element. Replaces any previously set children.
///
/// ```gleam
/// dock.item_new()
/// |> dock.item_children([html.span([attribute.class("text-xl")], [html.text("🏠")])])
/// |> dock.item_build
/// ```
pub fn item_children(
  i: DockItem(msg),
  ch: List(Element(msg)),
) -> DockItem(msg) {
  DockItem(..i, children: ch)
}

/// Adds a `<span class="dock-label">` text label below the icon.
///
/// Omit this call to render an icon-only item.
///
/// ```gleam
/// dock.item_new()
/// |> dock.item_children([icon()])
/// |> dock.item_label("Home")
/// |> dock.item_build
/// ```
///
/// ## Reference
/// - [DaisyUI dock](https://daisyui.com/components/dock/)
pub fn item_label(i: DockItem(msg), label: String) -> DockItem(msg) {
  DockItem(..i, label: Some(label))
}

// ---------------------------------------------------------------------------
// DockItem build
// ---------------------------------------------------------------------------

/// Converts the `DockItem` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <button [class="dock-active"]  …attrs>
///   …children…
///   <span class="dock-label">…label…</span>   ← only if label was set
/// </button>
/// ```
///
/// Pass the result to `items/2` on the `Dock` builder.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI dock](https://daisyui.com/components/dock/)
pub fn item_build(i: DockItem(msg)) -> Element(msg) {
  let active_attrs = case i.active {
    True -> [attribute.class("dock-active")]
    False -> []
  }

  let label_els = case i.label {
    Some(t) -> [html.span([attribute.class("dock-label")], [html.text(t)])]
    None -> []
  }

  html.button(
    list.append(active_attrs, i.attrs),
    list.append(i.children, label_els),
  )
}
