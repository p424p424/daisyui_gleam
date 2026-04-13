/// A builder for DaisyUI FAB (Floating Action Button) and Speed Dial elements.
///
/// The FAB component renders a floating button fixed to the corner of the
/// screen. When the trigger is focused or clicked, additional speed-dial
/// buttons appear either in a **vertical stack** (default) or a **quarter-
/// circle flower** arrangement.
///
/// The component renders as:
///
/// ```html
/// <div class="fab [fab-flower]">
///   …trigger…                        ← focusable div with tabindex="0"
///   <div class="fab-close">…</div>   ← optional (mutually exclusive with main_action)
///   <div class="fab-main-action">…</div>  ← optional (mutually exclusive with close)
///   …items…                          ← speed-dial buttons
/// </div>
/// ```
///
/// > **Trigger must be a `<div tabindex="0" role="button">`**, not a
/// > `<button>`. Safari has a long-standing bug that prevents `<button>`
/// > elements from receiving focus, so the CSS-focus mechanism used by
/// > FAB would not work there.
///
/// > **`fab-close` vs `fab-main-action`**: use one or the other, not both.
/// > `fab-close` shows a close button in place of the trigger while the FAB
/// > is open. `fab-main-action` replaces the trigger with a different action
/// > button. Call `close/2` or `main_action/2` but not both.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a FAB piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/fab
///
/// // Vertical speed dial
/// fab.new()
/// |> fab.trigger([
///   html.div(
///     [attribute.attribute("tabindex", "0"), attribute.attribute("role", "button"),
///      attribute.class("btn btn-lg btn-circle btn-primary")],
///     [html.text("F")],
///   ),
/// ])
/// |> fab.items([
///   html.button([attribute.class("btn btn-lg btn-circle")], [html.text("A")]),
///   html.button([attribute.class("btn btn-lg btn-circle")], [html.text("B")]),
///   html.button([attribute.class("btn btn-lg btn-circle")], [html.text("C")]),
/// ])
/// |> fab.build
///
/// // Flower speed dial
/// fab.new()
/// |> fab.flower
/// |> fab.trigger([…])
/// |> fab.main_action([html.button([attribute.class("btn btn-circle btn-lg btn-primary")], [html.text("M")])])
/// |> fab.items([…])
/// |> fab.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI FAB](https://daisyui.com/components/fab/)
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates FAB configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Fab`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
pub opaque type Fab(msg) {
  Fab(
    flower: Bool,
    attrs: List(Attribute(msg)),
    trigger: List(Element(msg)),
    close: Option(List(Element(msg))),
    main_action: Option(List(Element(msg))),
    items: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Fab` builder with vertical layout, no trigger, no
/// close/main-action slot, no speed-dial items, and no extra attributes.
///
/// ```gleam
/// fab.new()
/// |> fab.trigger([html.div([attribute.attribute("tabindex", "0"), attribute.attribute("role", "button"), attribute.class("btn btn-lg btn-circle btn-primary")], [html.text("F")])])
/// |> fab.items([html.button([attribute.class("btn btn-lg btn-circle")], [html.text("A")])])
/// |> fab.build
/// ```
pub fn new() -> Fab(msg) {
  Fab(
    flower: False,
    attrs: [],
    trigger: [],
    close: None,
    main_action: None,
    items: [],
  )
}

// ---------------------------------------------------------------------------
// Layout
// ---------------------------------------------------------------------------

/// Use the **flower** layout — speed-dial buttons open in a quarter-circle
/// arrangement rather than a vertical stack. Adds `fab-flower`.
///
/// Flower mode fits 1–4 speed-dial items (not counting the trigger,
/// `fab-close`, or `fab-main-action`).
///
/// ## Reference
/// - [DaisyUI FAB](https://daisyui.com/components/fab/)
pub fn flower(f: Fab(msg)) -> Fab(msg) {
  Fab(..f, flower: True)
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<div class="fab">`.
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(f: Fab(msg), a: List(Attribute(msg))) -> Fab(msg) {
  Fab(..f, attrs: a)
}

// ---------------------------------------------------------------------------
// Slots
// ---------------------------------------------------------------------------

/// Sets the trigger — the always-visible focusable button.
///
/// Must be a `<div tabindex="0" role="button">`, not a `<button>`, to work
/// correctly in Safari. Apply `btn btn-circle` (and optionally a size and
/// colour) directly on the div.
///
/// ```gleam
/// fab.new()
/// |> fab.trigger([
///   html.div(
///     [attribute.attribute("tabindex", "0"), attribute.attribute("role", "button"),
///      attribute.class("btn btn-lg btn-circle btn-primary")],
///     [html.text("F")],
///   ),
/// ])
/// ```
pub fn trigger(f: Fab(msg), t: List(Element(msg))) -> Fab(msg) {
  Fab(..f, trigger: t)
}

/// Sets the **close slot** — shown in place of the trigger while the FAB
/// is open. Wrapped automatically in `<div class="fab-close">`.
///
/// The close button should not be focusable (it is a visual placeholder
/// that closes the FAB by removing focus). Mutually exclusive with
/// `main_action/2` — use one or the other.
///
/// ```gleam
/// fab.new()
/// |> fab.close([
///   html.text("Close "),
///   html.span([attribute.class("btn btn-circle btn-lg btn-error")], [html.text("✕")]),
/// ])
/// ```
///
/// ## Reference
/// - [DaisyUI FAB](https://daisyui.com/components/fab/)
pub fn close(f: Fab(msg), ch: List(Element(msg))) -> Fab(msg) {
  Fab(..f, close: Some(ch))
}

/// Sets the **main-action slot** — shown in place of the trigger while
/// the FAB is open. Wrapped automatically in `<div class="fab-main-action">`.
///
/// Mutually exclusive with `close/2` — use one or the other.
///
/// ```gleam
/// fab.new()
/// |> fab.main_action([
///   html.text("Main "),
///   html.button([attribute.class("btn btn-circle btn-secondary btn-lg")], [html.text("M")]),
/// ])
/// ```
///
/// ## Reference
/// - [DaisyUI FAB](https://daisyui.com/components/fab/)
pub fn main_action(f: Fab(msg), ch: List(Element(msg))) -> Fab(msg) {
  Fab(..f, main_action: Some(ch))
}

/// Sets the speed-dial items — the buttons revealed when the FAB opens.
///
/// Each item is a fully built `Element` — a `<button>`, a labeled `<div>`,
/// or a tooltip wrapper. For vertical layout, any number of items is
/// supported. For `fab-flower` layout, 1–4 items are recommended.
///
/// ```gleam
/// fab.new()
/// |> fab.items([
///   html.button([attribute.class("btn btn-lg btn-circle")], [html.text("A")]),
///   html.button([attribute.class("btn btn-lg btn-circle")], [html.text("B")]),
///   html.button([attribute.class("btn btn-lg btn-circle")], [html.text("C")]),
/// ])
/// ```
pub fn items(f: Fab(msg), i: List(Element(msg))) -> Fab(msg) {
  Fab(..f, items: i)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Fab` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <div class="fab [fab-flower]" …attrs>
///   …trigger…
///   <div class="fab-close">…close children…</div>      ← if close set
///   <div class="fab-main-action">…main_action children…</div>  ← if main_action set
///   …items…
/// </div>
/// ```
///
/// If both `close` and `main_action` are set both are emitted — DaisyUI
/// documents them as mutually exclusive, so only call one.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI FAB](https://daisyui.com/components/fab/)
pub fn build(f: Fab(msg)) -> Element(msg) {
  let container_class = case f.flower {
    True -> "fab fab-flower"
    False -> "fab"
  }

  let close_el =
    option.map(f.close, fn(ch) {
      html.div([attribute.class("fab-close")], ch)
    })

  let main_action_el =
    option.map(f.main_action, fn(ch) {
      html.div([attribute.class("fab-main-action")], ch)
    })

  let middle_els =
    [close_el, main_action_el]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })

  html.div(
    [attribute.class(container_class), ..f.attrs],
    f.trigger
      |> list.append(middle_els)
      |> list.append(f.items),
  )
}
