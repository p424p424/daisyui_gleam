/// Helpers for DaisyUI label elements.
///
/// This module provides two label primitives:
///
/// - **`label/1`** — a standalone `<span class="label">` for use inside
///   `input` or `select` wrapper labels (prefix/suffix text, e.g. `"https://"`,
///   `".com"`, `"Type"`).
/// - **`FloatingLabel`** — a `<label class="floating-label">` builder that
///   wraps an input/select and a `<span>`, causing the span to float above
///   the field when it is focused.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/label
/// import lustre/element/html
/// import lustre/attribute
///
/// // Inline label prefix inside an input wrapper
/// html.label([attribute.class("input")], [
///   label.label("https://"),
///   html.input([attribute.type_("text"), attribute.placeholder("URL")]),
/// ])
///
/// // Floating label
/// label.floating_new()
/// |> label.floating_children([
///   html.input([attribute.type_("text"), attribute.class("input input-md"),
///               attribute.placeholder("mail@site.com")]),
///   html.span([], [html.text("Your Email")]),
/// ])
/// |> label.floating_build
/// ```
///
/// ## Reference
/// - [DaisyUI label](https://daisyui.com/components/label/)
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Inline label span
// ---------------------------------------------------------------------------

/// Renders a `<span class="label">text</span>` for use inside an `input` or
/// `select` wrapper label.
///
/// Place it before or after the `<input>` element inside the wrapper:
///
/// ```gleam
/// // Prefix
/// html.label([attribute.class("input")], [
///   label.label("https://"),
///   html.input([attribute.type_("text"), attribute.placeholder("URL")]),
/// ])
///
/// // Suffix
/// html.label([attribute.class("input")], [
///   html.input([attribute.type_("text"), attribute.placeholder("domain")]),
///   label.label(".com"),
/// ])
/// ```
pub fn label(text: String) -> Element(msg) {
  html.span([attribute.class("label")], [html.text(text)])
}

// ---------------------------------------------------------------------------
// Floating label builder
// ---------------------------------------------------------------------------

/// An opaque builder for a `<label class="floating-label">` element.
///
/// The floating label causes an inner `<span>` to float above the input
/// when the field gains focus, creating an animated label effect.
pub opaque type FloatingLabel(msg) {
  FloatingLabel(attrs: List(Attribute(msg)), children: List(Element(msg)))
}

/// Creates a new `FloatingLabel` builder.
///
/// ```gleam
/// label.floating_new()
/// |> label.floating_children([
///   html.input([attribute.type_("text"), attribute.class("input input-md"),
///               attribute.placeholder("Your Email")]),
///   html.span([], [html.text("Your Email")]),
/// ])
/// |> label.floating_build
/// ```
pub fn floating_new() -> FloatingLabel(msg) {
  FloatingLabel(attrs: [], children: [])
}

/// Merges additional Lustre attributes onto the `<label class="floating-label">`.
pub fn floating_attrs(
  fl: FloatingLabel(msg),
  a: List(Attribute(msg)),
) -> FloatingLabel(msg) {
  FloatingLabel(..fl, attrs: a)
}

/// Sets the children of the floating label wrapper.
///
/// Should include an `<input>` (with `class="input input-{size}"` and a
/// `placeholder`) and a `<span>` with the label text. The span can appear
/// before or after the input.
///
/// ```gleam
/// label.floating_new()
/// |> label.floating_children([
///   html.input([attribute.type_("text"), attribute.class("input input-sm"),
///               attribute.placeholder("Small")]),
///   html.span([], [html.text("Small")]),
/// ])
/// |> label.floating_build
/// ```
pub fn floating_children(
  fl: FloatingLabel(msg),
  c: List(Element(msg)),
) -> FloatingLabel(msg) {
  FloatingLabel(..fl, children: c)
}

/// Converts the `FloatingLabel` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <label class="floating-label" …attrs>
///   …children
/// </label>
/// ```
pub fn floating_build(fl: FloatingLabel(msg)) -> Element(msg) {
  html.label([attribute.class("floating-label"), ..fl.attrs], fl.children)
}
