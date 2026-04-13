/// A builder for DaisyUI dropdown elements.
///
/// A dropdown wraps a trigger element and a content panel inside a
/// `<div class="dropdown">` container. The content panel is shown or
/// hidden by CSS when the trigger receives focus (the default CSS-focus
/// method) or hover.
///
/// The builder handles **only the container** — you supply both the trigger
/// and the content as lists of Lustre elements. This keeps the API flexible
/// enough to cover any trigger (a styled button, an icon, a navbar item)
/// and any content (a menu list, a card, a custom panel).
///
/// **CSS-focus trigger pattern** (recommended — works in all browsers):
///
/// ```html
/// <div tabindex="0" role="button" class="btn">Click</div>
/// ```
///
/// Use a `<div>` rather than `<button>` — Safari has a long-standing bug
/// that prevents `<button>` from receiving focus, so the CSS-focus method
/// would not work there.
///
/// **Details/summary trigger pattern** (no JS, native HTML):
///
/// Wrap everything in `<details>` / `<summary>` instead of using this
/// builder — or supply them as the trigger children.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a dropdown piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/dropdown
///
/// // Basic CSS-focus dropdown with a menu list
/// dropdown.new()
/// |> dropdown.trigger([
///   html.div(
///     [attribute.attribute("tabindex", "0"), attribute.attribute("role", "button"), attribute.class("btn m-1")],
///     [html.text("Click")],
///   ),
/// ])
/// |> dropdown.content([
///   html.ul(
///     [attribute.attribute("tabindex", "-1"), attribute.class("dropdown-content menu bg-base-100 rounded-box z-1 w-52 p-2 shadow-sm")],
///     [
///       html.li([], [html.a([], [html.text("Item 1")])]),
///       html.li([], [html.a([], [html.text("Item 2")])]),
///     ],
///   ),
/// ])
/// |> dropdown.build
///
/// // Top-right dropdown with hover
/// dropdown.new()
/// |> dropdown.top
/// |> dropdown.align_end
/// |> dropdown.hover
/// |> dropdown.trigger([…])
/// |> dropdown.content([…])
/// |> dropdown.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI dropdown](https://daisyui.com/components/dropdown/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// The direction the dropdown panel opens relative to the trigger.
///
/// | Constructor | Class              | Opens…        |
/// |-------------|--------------------|---------------|
/// | `Top`       | `dropdown-top`     | upward        |
/// | `Bottom`    | `dropdown-bottom`  | downward      |
/// | `Left`      | `dropdown-left`    | to the left   |
/// | `Right`     | `dropdown-right`   | to the right  |
///
/// The default (no modifier) is downward, equivalent to `Bottom`.
pub type DropdownDirection {
  /// Opens upward. Maps to `dropdown-top`.
  Top
  /// Opens downward. Maps to `dropdown-bottom`. This is the DaisyUI default.
  Bottom
  /// Opens to the left. Maps to `dropdown-left`.
  Left
  /// Opens to the right. Maps to `dropdown-right`.
  Right
}

/// How the dropdown panel is aligned relative to the trigger on the
/// cross-axis.
///
/// For `Top` / `Bottom` directions this controls **horizontal** alignment;
/// for `Left` / `Right` directions it controls **vertical** alignment.
///
/// | Constructor     | Class              | Aligns to…             |
/// |-----------------|--------------------|------------------------|
/// | `AlignStart`    | `dropdown-start`   | leading edge (default) |
/// | `AlignCenter`   | `dropdown-center`  | centre                 |
/// | `AlignEnd`      | `dropdown-end`     | trailing edge          |
pub type DropdownAlign {
  /// Aligns the panel to the leading edge. Maps to `dropdown-start`.
  AlignStart
  /// Aligns the panel to the centre. Maps to `dropdown-center`.
  AlignCenter
  /// Aligns the panel to the trailing edge. Maps to `dropdown-end`.
  AlignEnd
}

/// Forces the dropdown panel open or closed regardless of focus state.
///
/// | Constructor    | Class             | Effect              |
/// |----------------|-------------------|---------------------|
/// | `ForceOpen`    | `dropdown-open`   | Always show panel   |
/// | `ForceClose`   | `dropdown-close`  | Always hide panel   |
pub type DropdownState {
  /// Always show the panel. Maps to `dropdown-open`.
  ForceOpen
  /// Always hide the panel. Maps to `dropdown-close`.
  ForceClose
}

/// An opaque builder that accumulates dropdown configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Dropdown`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
pub opaque type Dropdown(msg) {
  Dropdown(
    direction: Option(DropdownDirection),
    align: Option(DropdownAlign),
    hover: Bool,
    state: Option(DropdownState),
    attrs: List(Attribute(msg)),
    trigger: List(Element(msg)),
    content: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Dropdown` builder with default settings.
///
/// Defaults to downward opening, start alignment, no hover, no forced
/// state, and empty trigger and content slots. Chain setters to configure,
/// then call `build/1` to produce a Lustre element.
///
/// ```gleam
/// dropdown.new()
/// |> dropdown.trigger([html.div([attribute.attribute("tabindex", "0"), attribute.attribute("role", "button"), attribute.class("btn")], [html.text("Click")])])
/// |> dropdown.content([html.ul([attribute.attribute("tabindex", "-1"), attribute.class("dropdown-content menu bg-base-100 rounded-box z-1 w-52 p-2 shadow-sm")], [])])
/// |> dropdown.build
/// ```
pub fn new() -> Dropdown(msg) {
  Dropdown(
    direction: None,
    align: None,
    hover: False,
    state: None,
    attrs: [],
    trigger: [],
    content: [],
  )
}

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Open the panel **upward** — `dropdown-top`.
pub fn top(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, direction: Some(Top))
}

/// Open the panel **downward** — `dropdown-bottom`.
///
/// This is the DaisyUI default; call it explicitly only when overriding a
/// previously set direction.
pub fn bottom(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, direction: Some(Bottom))
}

/// Open the panel to the **left** — `dropdown-left`.
pub fn left(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, direction: Some(Left))
}

/// Open the panel to the **right** — `dropdown-right`.
pub fn right(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, direction: Some(Right))
}

// ---------------------------------------------------------------------------
// Alignment
// ---------------------------------------------------------------------------

/// Align the panel to the **leading** edge — `dropdown-start`.
///
/// This is the DaisyUI default; call it explicitly only when overriding a
/// previously set alignment.
pub fn align_start(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, align: Some(AlignStart))
}

/// Align the panel to the **centre** — `dropdown-center`.
pub fn align_center(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, align: Some(AlignCenter))
}

/// Align the panel to the **trailing** edge — `dropdown-end`.
pub fn align_end(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, align: Some(AlignEnd))
}

// ---------------------------------------------------------------------------
// Modifiers
// ---------------------------------------------------------------------------

/// Also open the dropdown on **hover** — adds `dropdown-hover`.
///
/// ## Reference
/// - [DaisyUI dropdown](https://daisyui.com/components/dropdown/)
pub fn hover(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, hover: True)
}

/// Force the dropdown **open** — `dropdown-open`.
pub fn force_open(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, state: Some(ForceOpen))
}

/// Force the dropdown **closed** — `dropdown-close`.
pub fn force_close(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, state: Some(ForceClose))
}

// ---------------------------------------------------------------------------
// Attrs / slots
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<div class="dropdown">`.
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(d: Dropdown(msg), a: List(Attribute(msg))) -> Dropdown(msg) {
  Dropdown(..d, attrs: a)
}

/// Sets the trigger element(s) rendered before the content panel.
///
/// Typically a single element — either a `<div tabindex="0" role="button">`
/// for CSS-focus behaviour, or a `<summary>` if you are wrapping in
/// `<details>`. Any DaisyUI `btn` classes can be added to the trigger.
///
/// ```gleam
/// dropdown.new()
/// |> dropdown.trigger([
///   html.div(
///     [attribute.attribute("tabindex", "0"), attribute.attribute("role", "button"), attribute.class("btn m-1")],
///     [html.text("Open")],
///   ),
/// ])
/// ```
pub fn trigger(d: Dropdown(msg), t: List(Element(msg))) -> Dropdown(msg) {
  Dropdown(..d, trigger: t)
}

/// Sets the dropdown content panel.
///
/// The content element should carry `class="dropdown-content"` plus any
/// styling you need (menu, card, etc.). Add `tabindex="-1"` to allow focus
/// to move into the panel without immediately closing it.
///
/// ```gleam
/// dropdown.new()
/// |> dropdown.content([
///   html.ul(
///     [attribute.attribute("tabindex", "-1"), attribute.class("dropdown-content menu bg-base-100 rounded-box z-1 w-52 p-2 shadow-sm")],
///     [html.li([], [html.a([], [html.text("Item 1")])])],
///   ),
/// ])
/// ```
pub fn content(d: Dropdown(msg), c: List(Element(msg))) -> Dropdown(msg) {
  Dropdown(..d, content: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Dropdown` builder into a Lustre `Element(msg)`.
///
/// Assembles the class string and renders:
///
/// ```html
/// <div class="dropdown [direction] [align] [hover] [open|close]" …attrs>
///   …trigger…
///   …content…
/// </div>
/// ```
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI dropdown](https://daisyui.com/components/dropdown/)
pub fn build(d: Dropdown(msg)) -> Element(msg) {
  let component_class =
    [
      Some("dropdown"),
      option.map(d.direction, fn(dir) {
        case dir {
          Top -> "dropdown-top"
          Bottom -> "dropdown-bottom"
          Left -> "dropdown-left"
          Right -> "dropdown-right"
        }
      }),
      option.map(d.align, fn(a) {
        case a {
          AlignStart -> "dropdown-start"
          AlignCenter -> "dropdown-center"
          AlignEnd -> "dropdown-end"
        }
      }),
      case d.hover {
        True -> Some("dropdown-hover")
        False -> None
      },
      option.map(d.state, fn(s) {
        case s {
          ForceOpen -> "dropdown-open"
          ForceClose -> "dropdown-close"
        }
      }),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.div(
    [attribute.class(component_class), ..d.attrs],
    list.append(d.trigger, d.content),
  )
}
