/// A builder for DaisyUI filter elements.
///
/// The filter component is a group of radio buttons. Choosing one option
/// hides the others and reveals a reset control beside the chosen option.
/// There are two structural variants:
///
/// - **Form** (default) — uses a native `<form class="filter">` with an
///   `<input type="reset">` control. The browser handles reset automatically.
/// - **Div** — uses a `<div class="filter">` with a special
///   `filter-reset` radio input as the first option. Use this when you
///   cannot wrap the filter in a `<form>` element.
///
/// For multiple-choice filtering (checkboxes) the `filter` class is not
/// needed — use a plain `<form>` with `<input type="checkbox" class="btn">`
/// elements and an `<input type="reset">`.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.form`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a filter piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/filter
///
/// // Form variant — browser reset button
/// filter.new("frameworks")
/// |> filter.items([
///   filter.item("Svelte", []),
///   filter.item("Vue", []),
///   filter.item("React", []),
/// ])
/// |> filter.build
///
/// // Div variant — filter-reset radio
/// filter.new("frameworks")
/// |> filter.div
/// |> filter.items([
///   filter.item("SvelteKit", []),
///   filter.item("Nuxt", []),
///   filter.item("Next.js", []),
/// ])
/// |> filter.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI filter](https://daisyui.com/components/filter/)
import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// The HTML element and reset mechanism used for the filter container.
///
/// | Variant | Element    | Reset mechanism                           |
/// |---------|------------|-------------------------------------------|
/// | `Form`  | `<form>`   | `<input type="reset">` — native browser   |
/// | `Div`   | `<div>`    | `filter-reset` radio input                |
pub type FilterVariant {
  /// Uses `<form class="filter">` with a native `<input type="reset">`.
  Form
  /// Uses `<div class="filter">` with a `filter-reset` radio input.
  Div
}

/// A single radio option within the filter.
///
/// Rendered as `<input type="radio" class="btn" name="…" aria-label="label" …attrs>`.
pub type FilterItem(msg) {
  FilterItem(label: String, attrs: List(Attribute(msg)))
}

/// An opaque builder that accumulates filter configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Filter`
/// > directly — use `new/1` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
pub opaque type Filter(msg) {
  Filter(
    variant: FilterVariant,
    name: String,
    reset_label: String,
    attrs: List(Attribute(msg)),
    items: List(FilterItem(msg)),
  )
}

// ---------------------------------------------------------------------------
// Item constructor
// ---------------------------------------------------------------------------

/// Creates a `FilterItem` with a display label and optional extra attributes.
///
/// The label becomes the `aria-label` on the rendered radio `<input>`.
/// Use `attrs` for event handlers (`event.on_click`), `value`, `checked`,
/// or any other input attribute.
///
/// ```gleam
/// filter.item("React", [event.on_click(UserSelectedReact)])
/// filter.item("Vue", [attribute.attribute("value", "vue")])
/// ```
pub fn item(label: String, attrs: List(Attribute(msg))) -> FilterItem(msg) {
  FilterItem(label: label, attrs: attrs)
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Filter` builder using the **Form** variant, with the
/// given radio-group `name`, default reset label `"All"`, and no items.
///
/// ```gleam
/// filter.new("frameworks")
/// |> filter.items([filter.item("Svelte", []), filter.item("React", [])])
/// |> filter.build
/// ```
pub fn new(name: String) -> Filter(msg) {
  Filter(
    variant: Form,
    name: name,
    reset_label: "All",
    attrs: [],
    items: [],
  )
}

// ---------------------------------------------------------------------------
// Variant
// ---------------------------------------------------------------------------

/// Use the **Form** variant — wraps the filter in `<form class="filter">`
/// with an `<input type="reset" value="×">` as the reset control.
///
/// This is the default; call it explicitly only when overriding a
/// previously set `div/1`.
///
/// ## Reference
/// - [DaisyUI filter](https://daisyui.com/components/filter/)
pub fn form(f: Filter(msg)) -> Filter(msg) {
  Filter(..f, variant: Form)
}

/// Use the **Div** variant — wraps the filter in `<div class="filter">`
/// and prepends a `<input type="radio" class="btn filter-reset">` as the
/// reset control.
///
/// Use this when the filter cannot be placed inside a `<form>` element.
///
/// ## Reference
/// - [DaisyUI filter](https://daisyui.com/components/filter/)
pub fn div(f: Filter(msg)) -> Filter(msg) {
  Filter(..f, variant: Div)
}

// ---------------------------------------------------------------------------
// Reset label
// ---------------------------------------------------------------------------

/// Sets the `aria-label` on the `filter-reset` radio for the **Div**
/// variant. Defaults to `"All"`.
///
/// Has no effect when the **Form** variant is used.
///
/// ```gleam
/// filter.new("genres")
/// |> filter.div
/// |> filter.reset_label("Show all")
/// |> filter.items([…])
/// |> filter.build
/// ```
pub fn reset_label(f: Filter(msg), label: String) -> Filter(msg) {
  Filter(..f, reset_label: label)
}

// ---------------------------------------------------------------------------
// Attrs / items
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer container element
/// (`<form>` or `<div>`).
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(f: Filter(msg), a: List(Attribute(msg))) -> Filter(msg) {
  Filter(..f, attrs: a)
}

/// Sets the list of filter options.
///
/// Each `FilterItem` is rendered as a radio `<input>` with `class="btn"`,
/// the shared `name`, and its label as `aria-label`. Build items with
/// `item/2`.
///
/// ```gleam
/// filter.new("size")
/// |> filter.items([
///   filter.item("XS", []),
///   filter.item("S", []),
///   filter.item("M", []),
///   filter.item("L", []),
///   filter.item("XL", []),
/// ])
/// |> filter.build
/// ```
pub fn items(f: Filter(msg), i: List(FilterItem(msg))) -> Filter(msg) {
  Filter(..f, items: i)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Filter` builder into a Lustre `Element(msg)`.
///
/// **Form variant** renders:
///
/// ```html
/// <form class="filter" …attrs>
///   <input class="btn btn-square" type="reset" value="×" />
///   <input class="btn" type="radio" name="…" aria-label="Label" …item_attrs />
///   …
/// </form>
/// ```
///
/// **Div variant** renders:
///
/// ```html
/// <div class="filter" …attrs>
///   <input class="btn filter-reset" type="radio" name="…" aria-label="All" />
///   <input class="btn" type="radio" name="…" aria-label="Label" …item_attrs />
///   …
/// </div>
/// ```
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI filter](https://daisyui.com/components/filter/)
pub fn build(f: Filter(msg)) -> Element(msg) {
  let radio_els =
    list.map(f.items, fn(i) {
      html.input(
        [
          attribute.class("btn"),
          attribute.type_("radio"),
          attribute.name(f.name),
          attribute.attribute("aria-label", i.label),
          ..i.attrs
        ],
      )
    })

  case f.variant {
    Form -> {
      let reset_el =
        html.input([
          attribute.class("btn btn-square"),
          attribute.type_("reset"),
          attribute.value("×"),
        ])
      html.form(
        [attribute.class("filter"), ..f.attrs],
        [reset_el, ..radio_els],
      )
    }

    Div -> {
      let reset_el =
        html.input([
          attribute.class("btn filter-reset"),
          attribute.type_("radio"),
          attribute.name(f.name),
          attribute.attribute("aria-label", f.reset_label),
        ])
      html.div(
        [attribute.class("filter"), ..f.attrs],
        [reset_el, ..radio_els],
      )
    }
  }
}

