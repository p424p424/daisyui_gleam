/// A builder for DaisyUI collapse elements.
///
/// The collapse component hides or reveals a content panel. This module
/// covers three toggle mechanisms:
///
/// - **Focus** (default) — the container has `tabindex="0"` and toggles open
///   when it receives focus, closing again when it loses focus. No hidden
///   input is needed and no JavaScript is required. Best for simple
///   interactive disclosures.
/// - **Checkbox** — a hidden `<input type="checkbox">` toggles the panel.
///   The state persists across focus changes and survives re-renders.
/// - **Details** — uses native `<details>` / `<summary>` elements. Works
///   without JavaScript, is accessible by default, and makes content
///   findable by browser in-page search.
///
/// For **accordion groups** (opening one item closes the others), use
/// `daisyui/accordion` instead — it wraps the radio-input variant.
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
/// import daisyui/collapse
///
/// // Focus-based collapse — opens on focus, closes on blur
/// collapse.new()
/// |> collapse.title(attrs: [], children: [html.text("How do I create an account?")])
/// |> collapse.content(attrs: [], children: [
///   html.text("Click Sign Up and follow the registration process."),
/// ])
/// |> collapse.build
///
/// // Checkbox collapse with an arrow icon
/// collapse.new()
/// |> collapse.checkbox
/// |> collapse.arrow
/// |> collapse.title(attrs: [], children: [html.text("Click to toggle")])
/// |> collapse.content(attrs: [], children: [html.text("Persistent content")])
/// |> collapse.build
///
/// // Details collapse, open on load
/// collapse.new()
/// |> collapse.details(open: True)
/// |> collapse.title(attrs: [], children: [html.text("Open by default")])
/// |> collapse.content(attrs: [], children: [html.text("Searcheable content")])
/// |> collapse.build
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

/// The underlying HTML mechanism used to toggle the collapse panel.
///
/// | Variant      | Mechanism                              | Notes                              |
/// |--------------|----------------------------------------|------------------------------------|
/// | `Focus`      | `tabindex="0"` on the container div    | Default; no input, pure CSS        |
/// | `Checkbox`   | Hidden `<input type="checkbox">`       | State persists across focus cycles |
/// | `Details`    | Native `<details>` / `<summary>`       | Accessible, browser-searcheable    |
///
/// For radio-based accordion groups (only one open at a time) use
/// `daisyui/accordion` instead.
pub type CollapseVariant {
  /// Focus-based — `tabindex="0"` on the container. Opens on focus, closes
  /// on blur. No hidden input required. This is the default variant.
  Focus
  /// Checkbox-based — a hidden `<input type="checkbox">` toggles the panel.
  /// State persists when the user clicks elsewhere and returns.
  Checkbox
  /// Details — uses a native `<details>` / `<summary>` pair. The `open`
  /// field controls whether the panel starts expanded.
  Details(open: Bool)
}

/// The decorative icon shown on the collapse title trigger.
///
/// | Constructor | Class            | Effect                                  |
/// |-------------|------------------|-----------------------------------------|
/// | `Arrow`     | `collapse-arrow` | A chevron that rotates when panel opens |
/// | `Plus`      | `collapse-plus`  | A `+` / `−` toggle icon                |
///
/// Omit both (the default) to show no icon.
pub type CollapseIcon {
  /// A rotating chevron arrow. Maps to `collapse-arrow`.
  Arrow
  /// A plus/minus toggle icon. Maps to `collapse-plus`.
  Plus
}

/// Forces the collapse open or closed regardless of user interaction.
///
/// | Constructor  | Class            | Effect                            |
/// |--------------|------------------|-----------------------------------|
/// | `ForceOpen`  | `collapse-open`  | Always show the content panel     |
/// | `ForceClose` | `collapse-close` | Always hide the content panel     |
///
/// Useful when open/closed state is driven by your Lustre model.
pub type CollapseState {
  /// Always show the content panel. Maps to `collapse-open`.
  ForceOpen
  /// Always hide the content panel. Maps to `collapse-close`.
  ForceClose
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
    variant: CollapseVariant,
    icon: Option(CollapseIcon),
    state: Option(CollapseState),
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

/// Creates a new `Collapse` builder with focus-based toggling and no icon.
///
/// Defaults to `Focus` variant (open on focus, close on blur), no icon, no
/// forced state, and empty title and content slots. Chain setter functions
/// to configure it, then call `build/1` to produce a Lustre element.
///
/// ```gleam
/// collapse.new()
/// |> collapse.title(attrs: [], children: [html.text("Question")])
/// |> collapse.content(attrs: [], children: [html.text("Answer")])
/// |> collapse.build
/// ```
pub fn new() -> Collapse(msg) {
  Collapse(
    variant: Focus,
    icon: None,
    state: None,
    attrs: [],
    title_attrs: [],
    title_children: [],
    content_attrs: [],
    content_children: [],
  )
}

// ---------------------------------------------------------------------------
// Variant
// ---------------------------------------------------------------------------

/// Use the **focus** toggle mechanism — the container gets `tabindex="0"` and
/// the panel opens on focus, closing when the element loses focus.
///
/// This is the default variant; call it explicitly only when you want to
/// override a previously set variant.
///
/// ## Reference
/// - [DaisyUI collapse with focus](https://daisyui.com/components/collapse/)
pub fn focus(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, variant: Focus)
}

/// Use the **checkbox** toggle mechanism — a hidden `<input type="checkbox">`
/// is inserted before the title. State persists when the container loses focus.
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn checkbox(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, variant: Checkbox)
}

/// Use the **details / summary** toggle mechanism.
///
/// `open` sets whether the panel is initially expanded. Use `True` to
/// render the collapse open on first paint.
///
/// The `<details>` element works without JavaScript and makes the content
/// findable by the browser's built-in in-page search (Ctrl/Cmd-F).
///
/// ```gleam
/// collapse.new()
/// |> collapse.details(open: False)
/// |> collapse.title(attrs: [], children: [html.text("Show source")])
/// |> collapse.content(attrs: [], children: [html.text("…")])
/// |> collapse.build
/// ```
///
/// ## Reference
/// - [DaisyUI collapse using details and summary](https://daisyui.com/components/collapse/)
pub fn details(c: Collapse(msg), open o: Bool) -> Collapse(msg) {
  Collapse(..c, variant: Details(open: o))
}

// ---------------------------------------------------------------------------
// Icon
// ---------------------------------------------------------------------------

/// Show a rotating chevron arrow on the title — `collapse-arrow`.
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn arrow(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, icon: Some(Arrow))
}

/// Show a plus/minus toggle icon on the title — `collapse-plus`.
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn plus(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, icon: Some(Plus))
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Force the collapse **open** regardless of user interaction — `collapse-open`.
///
/// Useful when the open/closed state is driven externally by your Lustre model.
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn force_open(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, state: Some(ForceOpen))
}

/// Force the collapse **closed** regardless of user interaction — `collapse-close`.
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn force_close(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, state: Some(ForceClose))
}

// ---------------------------------------------------------------------------
// Slots / Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer container element.
///
/// For `Focus` and `Checkbox` variants this is the `<div class="collapse">`
/// element. For `Details` it is the `<details class="collapse">` element.
///
/// ```gleam
/// collapse.new()
/// |> collapse.attrs([attribute.class("bg-base-100 border border-base-300")])
/// |> collapse.title(attrs: [], children: [html.text("Title")])
/// |> collapse.content(attrs: [], children: [html.text("Body")])
/// |> collapse.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(c: Collapse(msg), a: List(Attribute(msg))) -> Collapse(msg) {
  Collapse(..c, attrs: a)
}

/// Sets the title slot — the always-visible trigger for the collapse.
///
/// `attrs` are merged onto the `<div class="collapse-title">` (or `<summary>`
/// for the Details variant). `children` replace any previously set title content.
///
/// ```gleam
/// collapse.new()
/// |> collapse.title(
///   attrs: [attribute.class("font-semibold")],
///   children: [html.text("How do I reset my password?")],
/// )
/// |> collapse.content(attrs: [], children: [html.text("Click Forgot password.")])
/// |> collapse.build
/// ```
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn title(
  c: Collapse(msg),
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Collapse(msg) {
  Collapse(..c, title_attrs: a, title_children: ch)
}

/// Sets the content slot — the panel that is shown or hidden.
///
/// `attrs` are merged onto the `<div class="collapse-content">` element.
/// `children` replace any previously set content.
///
/// ```gleam
/// collapse.new()
/// |> collapse.title(attrs: [], children: [html.text("Details")])
/// |> collapse.content(
///   attrs: [attribute.class("text-sm")],
///   children: [html.p([], [html.text("Extended information here.")])],
/// )
/// |> collapse.build
/// ```
///
/// ## Reference
/// - [DaisyUI collapse](https://daisyui.com/components/collapse/)
pub fn content(
  c: Collapse(msg),
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Collapse(msg) {
  Collapse(..c, content_attrs: a, content_children: ch)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Collapse` builder into a Lustre `Element(msg)`.
///
/// Assembles the DaisyUI class string, then delegates to the correct HTML
/// structure based on the chosen variant:
///
/// - **Focus** → `<div tabindex="0" class="collapse …">` with title and content divs.
/// - **Checkbox** → `<div class="collapse …">` with a hidden checkbox input,
///   title div, and content div.
/// - **Details** → `<details class="collapse …">` with a `<summary>` (title)
///   and content div. The `open` attribute is set when `Details(open: True)`.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
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

  let content_el =
    html.div(
      [attribute.class("collapse-content"), ..c.content_attrs],
      c.content_children,
    )

  case c.variant {
    Focus -> {
      let title_el =
        html.div(
          [attribute.class("collapse-title"), ..c.title_attrs],
          c.title_children,
        )
      html.div(
        [
          attribute.class(component_class),
          attribute.attribute("tabindex", "0"),
          ..c.attrs
        ],
        [title_el, content_el],
      )
    }

    Checkbox -> {
      let title_el =
        html.div(
          [attribute.class("collapse-title"), ..c.title_attrs],
          c.title_children,
        )
      html.div(
        [attribute.class(component_class), ..c.attrs],
        [html.input([attribute.type_("checkbox")]), title_el, content_el],
      )
    }

    Details(open: is_open) -> {
      let summary_el =
        html.summary(
          [attribute.class("collapse-title"), ..c.title_attrs],
          c.title_children,
        )
      let open_attrs = case is_open {
        True -> [attribute.attribute("open", "")]
        False -> []
      }
      html.details(
        list.append([attribute.class(component_class)], open_attrs)
          |> list.append(c.attrs),
        [summary_el, content_el],
      )
    }
  }
}
