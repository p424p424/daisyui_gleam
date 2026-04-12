/// A builder for DaisyUI collapse/accordion elements.
///
/// The collapse component hides or reveals content when a trigger is
/// activated. It supports three variants: a plain checkbox (default), a
/// radio group (only one open at a time), and a native `<details>` element
/// (no JavaScript required). An optional icon — arrow or plus — can be
/// shown on the trigger.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a collapse piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/accordion
///
/// // A simple checkbox collapse with an arrow icon
/// accordion.new()
/// |> accordion.arrow
/// |> accordion.title(attrs: [], children: [html.text("Click me")])
/// |> accordion.content(attrs: [], children: [html.text("Hidden content")])
/// |> accordion.build
///
/// // A native <details> collapse, open by default
/// accordion.new()
/// |> accordion.details("section-1", True)
/// |> accordion.title(attrs: [], children: [html.text("Open by default")])
/// |> accordion.content(attrs: [], children: [html.text("Always visible on load")])
/// |> accordion.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// The decorative icon shown on the collapse trigger.
///
/// - `Arrow` — renders a chevron that rotates when the panel opens.
///   Maps to the `collapse-arrow` DaisyUI class.
/// - `Plus` — renders a plus/minus icon. Maps to `collapse-plus`.
///
/// Omit both (the default) to show no icon at all.
pub type CollapseIcon {
  /// A rotating chevron arrow. Maps to `collapse-arrow`.
  Arrow
  /// A plus/minus toggle icon. Maps to `collapse-plus`.
  Plus
}

/// Forces the collapse open or closed regardless of user interaction.
///
/// Useful for controlled components where open/closed state is managed
/// externally (e.g. driven by your Lustre model).
///
/// - `ForceOpen` — maps to `collapse-open`.
/// - `ForceClose` — maps to `collapse-close`.
pub type CollapseState {
  /// Always show the content panel. Maps to `collapse-open`.
  ForceOpen
  /// Always hide the content panel. Maps to `collapse-close`.
  ForceClose
}

/// Determines the underlying HTML mechanism used to toggle the collapse.
///
/// - `Radio` — uses a hidden `<input type="radio">`. Multiple collapses
///   sharing the same `name` behave like an accordion: opening one closes
///   the others.
/// - `Details` — uses a native `<details>`/`<summary>` element. Works
///   without JavaScript and is accessible by default.
///
/// When no variant is set (`None`), a hidden `<input type="checkbox">` is
/// used and each collapse toggles independently.
pub type CollapseVariant {
  /// Hidden radio input — share `name` across items for accordion behaviour.
  Radio(name: String, checked: Bool)
  /// Native `<details>` element — no JavaScript needed.
  Details(name: String, open: Bool)
}

/// An opaque builder that accumulates collapse configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Collapse`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Collapse(msg) {
  Collapse(
    icon: Option(CollapseIcon),
    state: Option(CollapseState),
    variant: Option(CollapseVariant),
    attrs: List(Attribute(msg)),
    title_attrs: List(Attribute(msg)),
    title_children: List(Element(msg)),
    content_attrs: List(Attribute(msg)),
    content_children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Collapse` builder with no classes or variant applied.
///
/// Defaults to a checkbox-based collapse with no icon, no forced state,
/// no extra attributes, and empty title and content slots. Chain setter
/// functions to configure it, then call `build/1` to produce a Lustre element.
///
/// ```gleam
/// accordion.new()
/// |> accordion.arrow
/// |> accordion.title(attrs: [], children: [html.text("Title")])
/// |> accordion.content(attrs: [], children: [html.text("Body")])
/// |> accordion.build
/// ```
pub fn new() -> Collapse(msg) {
  Collapse(
    icon: None,
    state: None,
    variant: None,
    attrs: [],
    title_attrs: [],
    title_children: [],
    content_attrs: [],
    content_children: [],
  )
}

// ---------------------------------------------------------------------------
// Icon
// ---------------------------------------------------------------------------

/// Adds a rotating chevron arrow icon to the collapse trigger.
///
/// Applies the `collapse-arrow` DaisyUI class to the wrapper element.
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn arrow(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, icon: Some(Arrow))
}

/// Adds a plus/minus icon to the collapse trigger.
///
/// Applies the `collapse-plus` DaisyUI class to the wrapper element.
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn plus(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, icon: Some(Plus))
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Forces the collapse panel open regardless of user interaction.
///
/// Applies the `collapse-open` DaisyUI class. Use when open/closed state
/// is controlled externally by your Lustre model.
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn force_open(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, state: Some(ForceOpen))
}

/// Forces the collapse panel closed regardless of user interaction.
///
/// Applies the `collapse-close` DaisyUI class. Use when open/closed state
/// is controlled externally by your Lustre model.
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn force_close(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, state: Some(ForceClose))
}

// ---------------------------------------------------------------------------
// Variant
// ---------------------------------------------------------------------------

/// Switches the collapse to use a hidden `<input type="radio">`.
///
/// Multiple collapses that share the same `name` behave like an accordion:
/// selecting one automatically closes the others. Set `checked: True` to
/// have this item open on initial render.
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn radio(c: Collapse(msg), name: String, checked: Bool) -> Collapse(msg) {
  Collapse(..c, variant: Some(Radio(name: name, checked: checked)))
}

/// Switches the collapse to use a native `<details>`/`<summary>` element.
///
/// This variant requires no JavaScript and is accessible by default —
/// the browser handles toggle behaviour natively. Set `open: True` to
/// have the panel visible on initial render.
///
/// The `name` parameter is reserved for future use (grouping `<details>`
/// elements is not yet universally supported).
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
/// - [MDN: `<details>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details)
pub fn details(c: Collapse(msg), name: String, open: Bool) -> Collapse(msg) {
  Collapse(..c, variant: Some(Details(name: name, open: open)))
}

// ---------------------------------------------------------------------------
// Attrs / Parts
// ---------------------------------------------------------------------------

/// Appends additional Lustre attributes to the outer wrapper element.
///
/// Multiple calls accumulate — later calls do not replace earlier ones.
/// Useful for attaching event handlers, IDs, ARIA attributes, or any other
/// HTML attribute not covered by the builder functions.
///
/// ```gleam
/// import lustre/attribute
///
/// accordion.new()
/// |> accordion.attrs([attribute.id("faq-1")])
/// |> accordion.title(attrs: [], children: [html.text("Question")])
/// |> accordion.content(attrs: [], children: [html.text("Answer")])
/// |> accordion.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(c: Collapse(msg), a: List(Attribute(msg))) -> Collapse(msg) {
  Collapse(..c, attrs: list.append(c.attrs, a))
}

/// Sets the title slot — the always-visible trigger area.
///
/// `attrs` are appended to the title element; `children` replace any
/// previously set title children. In the `Details` variant the title is
/// rendered as a `<summary>` element; in all other variants it is rendered
/// as a `<div class="collapse-title">`.
///
/// ```gleam
/// accordion.new()
/// |> accordion.title(
///   attrs: [attribute.class("font-semibold")],
///   children: [html.text("Section heading")],
/// )
/// ```
pub fn title(
  c: Collapse(msg),
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Collapse(msg) {
  Collapse(..c, title_attrs: list.append(c.title_attrs, a), title_children: ch)
}

/// Sets the content slot — the panel that is shown or hidden.
///
/// `attrs` are appended to the `<div class="collapse-content">` element;
/// `children` replace any previously set content children.
///
/// ```gleam
/// accordion.new()
/// |> accordion.content(
///   attrs: [],
///   children: [html.p([], [html.text("Detailed explanation here.")])],
/// )
/// ```
pub fn content(
  c: Collapse(msg),
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Collapse(msg) {
  Collapse(
    ..c,
    content_attrs: list.append(c.content_attrs, a),
    content_children: ch,
  )
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Collapse` builder into a Lustre `Element(msg)`.
///
/// Assembles the DaisyUI class string, constructs the appropriate inner
/// elements (title, content, and hidden input or summary), then delegates
/// to the correct HTML constructor based on the chosen variant:
///
/// - No variant / `Radio` → `<div class="collapse …">` wrapping a hidden
///   input, a title `<div>`, and a content `<div>`.
/// - `Details` → `<details class="collapse …">` wrapping a `<summary>`
///   and a content `<div>`.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ```gleam
/// // In your Lustre view function:
/// pub fn view(model: Model) -> Element(Msg) {
///   html.div([], [
///     accordion.new()
///     |> accordion.arrow
///     |> accordion.radio("faq", model.open_item == 1)
///     |> accordion.title(attrs: [], children: [html.text("What is DaisyUI?")])
///     |> accordion.content(attrs: [], children: [html.text("A Tailwind component library.")])
///     |> accordion.build,
///   ])
/// }
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn build(c: Collapse(msg)) -> Element(msg) {
  let component_class =
    [
      Some("collapse"),
      option.map(c.icon, fn(i) {
        case i {
          Arrow -> "collapse-arrow"
          Plus -> "collapse-plus"
        }
      }),
      option.map(c.state, fn(s) {
        case s {
          ForceOpen -> "collapse-open"
          ForceClose -> "collapse-close"
        }
      }),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let title_el =
    html.div(
      [attribute.class("collapse-title"), ..c.title_attrs],
      c.title_children,
    )

  let content_el =
    html.div(
      [attribute.class("collapse-content"), ..c.content_attrs],
      c.content_children,
    )

  case c.variant {
    Some(Details(name: _, open: is_open)) -> {
      let open_attr = case is_open {
        True -> [attribute.attribute("open", "")]
        False -> []
      }
      let summary_el =
        html.summary(c.title_attrs, c.title_children)
      html.details(
        list.append([attribute.class(component_class)], open_attr)
          |> list.append(c.attrs),
        [summary_el, content_el],
      )
    }

    Some(Radio(name: radio_name, checked: is_checked)) -> {
      let input_attrs =
        [
          attribute.type_("radio"),
          attribute.name(radio_name),
          attribute.checked(is_checked),
        ]
      let input_el = html.input(input_attrs)
      html.div(
        [attribute.class(component_class), ..c.attrs],
        [input_el, title_el, content_el],
      )
    }

    None -> {
      let input_el = html.input([attribute.type_("checkbox")])
      html.div(
        [attribute.class(component_class), ..c.attrs],
        [input_el, title_el, content_el],
      )
    }
  }
}
