/// A builder for DaisyUI swap elements.
///
/// Swap toggles between two elements using a hidden checkbox (default) or
/// via the `swap-active` class (JS-controlled).
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/swap
/// import lustre/element/html
///
/// // Text swap with checkbox
/// swap.new()
/// |> swap.on(html.div([], [html.text("ON")]))
/// |> swap.off(html.div([], [html.text("OFF")]))
/// |> swap.build
///
/// // Rotate effect (sun/moon theme toggle)
/// swap.new()
/// |> swap.rotate
/// |> swap.on(sun_icon())
/// |> swap.off(moon_icon())
/// |> swap.build
///
/// // JS-controlled (swap-active class)
/// swap.new()
/// |> swap.active
/// |> swap.on(html.div([], [html.text("🥳")]))
/// |> swap.off(html.div([], [html.text("😭")]))
/// |> swap.build
/// ```
///
/// ## Reference
/// - [DaisyUI swap](https://daisyui.com/components/swap/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Swap(msg) {
  Swap(
    effect: Option(String),
    active: Bool,
    on_el: Option(Element(msg)),
    off_el: Option(Element(msg)),
    indeterminate_el: Option(Element(msg)),
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Swap` builder. Uses a hidden checkbox by default.
pub fn new() -> Swap(msg) {
  Swap(
    effect: None,
    active: False,
    on_el: None,
    off_el: None,
    indeterminate_el: None,
    attrs: [],
  )
}

// ---------------------------------------------------------------------------
// Effects
// ---------------------------------------------------------------------------

/// Adds a rotate transition — `swap-rotate`.
pub fn rotate(s: Swap(msg)) -> Swap(msg) {
  Swap(..s, effect: Some("swap-rotate"))
}

/// Adds a flip transition — `swap-flip`.
pub fn flip(s: Swap(msg)) -> Swap(msg) {
  Swap(..s, effect: Some("swap-flip"))
}

// ---------------------------------------------------------------------------
// Active mode (class-controlled, no checkbox)
// ---------------------------------------------------------------------------

/// Activates the swap via `swap-active` class rather than a checkbox.
///
/// Add or remove `swap-active` with JS to control which element is shown.
pub fn active(s: Swap(msg)) -> Swap(msg) {
  Swap(..s, active: True)
}

// ---------------------------------------------------------------------------
// Slot setters
// ---------------------------------------------------------------------------

/// Sets the element shown when the swap is **on** (checked / active).
///
/// Wrap in a `<div class="swap-on">` or pass a pre-built element that
/// already carries `class="swap-on …"`.
pub fn on(s: Swap(msg), el: Element(msg)) -> Swap(msg) {
  Swap(..s, on_el: Some(el))
}

/// Sets the element shown when the swap is **off** (unchecked / inactive).
pub fn off(s: Swap(msg), el: Element(msg)) -> Swap(msg) {
  Swap(..s, off_el: Some(el))
}

/// Sets the element shown when the checkbox is **indeterminate**.
pub fn indeterminate(s: Swap(msg), el: Element(msg)) -> Swap(msg) {
  Swap(..s, indeterminate_el: Some(el))
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<label>`.
pub fn attrs(s: Swap(msg), a: List(Attribute(msg))) -> Swap(msg) {
  Swap(..s, attrs: a)
}

// ---------------------------------------------------------------------------
// Slot helpers
// ---------------------------------------------------------------------------

/// Wraps content in `<div class="swap-on">content</div>`.
pub fn on_div(content: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("swap-on")], content)
}

/// Wraps content in `<div class="swap-off">content</div>`.
pub fn off_div(content: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("swap-off")], content)
}

/// Wraps content in `<div class="swap-indeterminate">content</div>`.
pub fn indeterminate_div(content: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("swap-indeterminate")], content)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Swap` builder into a Lustre `Element(msg)`.
///
/// When `active/1` has **not** been called a hidden `<input type="checkbox">`
/// is automatically prepended. When `active/1` has been called no checkbox
/// is added — control visibility by toggling `swap-active` with JS.
///
/// Renders:
/// ```html
/// <label class="swap [swap-rotate|swap-flip] [swap-active]" …attrs>
///   [<input type="checkbox" />]
///   <div class="swap-on">…</div>
///   <div class="swap-off">…</div>
/// </label>
/// ```
pub fn build(s: Swap(msg)) -> Element(msg) {
  let class =
    [
      Some("swap"),
      s.effect,
      case s.active {
        True -> Some("swap-active")
        False -> None
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let checkbox = case s.active {
    True -> []
    False -> [html.input([attribute.type_("checkbox")])]
  }

  let slot_children =
    [s.on_el, s.off_el, s.indeterminate_el]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })

  html.label(
    [attribute.class(class), ..s.attrs],
    list.append(checkbox, slot_children),
  )
}
