/// A builder for DaisyUI fieldset elements.
///
/// A fieldset groups related form elements under a titled border. It renders
/// as a `<fieldset class="fieldset">` with an optional `<legend class="fieldset-legend">`
/// title, followed by whatever form controls you place in the children slot.
///
/// DaisyUI also defines a `label` class for input labels and helper text.
/// You can apply it directly:
///
/// ```gleam
/// html.label([attribute.class("label"), attribute.for("my-input")], [html.text("Title")])
/// html.p([attribute.class("label")], [html.text("Helper text shown below the input")])
/// ```
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.fieldset`) and pass them `Attribute`
/// > and child `Element` lists. This module wraps that pattern in a builder
/// > so you can configure a fieldset piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/fieldset
///
/// // Basic fieldset with legend and an input
/// fieldset.new()
/// |> fieldset.legend("Page title")
/// |> fieldset.children([
///   html.input([attribute.type_("text"), attribute.class("input"), attribute.placeholder("My awesome page")]),
///   html.p([attribute.class("label")], [html.text("You can edit page title later on from settings")]),
/// ])
/// |> fieldset.build
///
/// // Fieldset with visible background and border
/// fieldset.new()
/// |> fieldset.legend("Page details")
/// |> fieldset.attrs([attribute.class("bg-base-200 border-base-300 rounded-box w-xs border p-4")])
/// |> fieldset.children([…])
/// |> fieldset.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI fieldset](https://daisyui.com/components/fieldset/)
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates fieldset configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Fieldset`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
pub opaque type Fieldset(msg) {
  Fieldset(
    attrs: List(Attribute(msg)),
    legend: Option(String),
    legend_attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Fieldset` builder with no legend, no children, and no
/// extra attributes.
///
/// ```gleam
/// fieldset.new()
/// |> fieldset.legend("Login")
/// |> fieldset.children([email_input, password_input, submit_btn])
/// |> fieldset.build
/// ```
pub fn new() -> Fieldset(msg) {
  Fieldset(attrs: [], legend: None, legend_attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Legend
// ---------------------------------------------------------------------------

/// Sets the legend text rendered as `<legend class="fieldset-legend">`.
///
/// The legend is the title of the fieldset group, displayed at the top of
/// the border. Omit this call to render a fieldset with no title.
///
/// ```gleam
/// fieldset.new()
/// |> fieldset.legend("Account settings")
/// |> fieldset.build
/// ```
///
/// ## Reference
/// - [DaisyUI fieldset](https://daisyui.com/components/fieldset/)
pub fn legend(f: Fieldset(msg), text: String) -> Fieldset(msg) {
  Fieldset(..f, legend: Some(text))
}

/// Merges additional Lustre attributes onto the `<legend class="fieldset-legend">` element.
///
/// Use this for `id`, ARIA attributes, or extra utility classes on the
/// legend element.
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn legend_attrs(f: Fieldset(msg), a: List(Attribute(msg))) -> Fieldset(msg) {
  Fieldset(..f, legend_attrs: a)
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<fieldset class="fieldset">`.
///
/// Use this to add border, background, padding, and sizing utilities:
///
/// ```gleam
/// fieldset.new()
/// |> fieldset.attrs([attribute.class("bg-base-200 border-base-300 rounded-box border p-4 w-xs")])
/// |> fieldset.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(f: Fieldset(msg), a: List(Attribute(msg))) -> Fieldset(msg) {
  Fieldset(..f, attrs: a)
}

/// Sets the form elements rendered inside the fieldset, after the legend.
///
/// Typically a mix of `<label class="label">`, `<input class="input">`,
/// and other form controls. Replaces any previously set children.
///
/// ```gleam
/// fieldset.new()
/// |> fieldset.legend("Profile")
/// |> fieldset.children([
///   html.label([attribute.class("label"), attribute.for("username")], [html.text("Username")]),
///   html.input([attribute.id("username"), attribute.type_("text"), attribute.class("input")]),
/// ])
/// |> fieldset.build
/// ```
pub fn children(f: Fieldset(msg), ch: List(Element(msg))) -> Fieldset(msg) {
  Fieldset(..f, children: ch)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Fieldset` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <fieldset class="fieldset" …attrs>
///   <legend class="fieldset-legend" …legend_attrs>…legend text…</legend>
///   …children…
/// </fieldset>
/// ```
///
/// The `<legend>` is omitted entirely when no legend text has been set.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI fieldset](https://daisyui.com/components/fieldset/)
pub fn build(f: Fieldset(msg)) -> Element(msg) {
  let legend_el = case f.legend {
    Some(text) ->
      [
        html.legend(
          [attribute.class("fieldset-legend"), ..f.legend_attrs],
          [html.text(text)],
        ),
      ]
    None -> []
  }

  html.fieldset(
    [attribute.class("fieldset"), ..f.attrs],
    list.append(legend_el, f.children),
  )
}
