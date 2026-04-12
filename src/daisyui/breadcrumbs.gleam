/// A builder for DaisyUI breadcrumbs elements.
///
/// Breadcrumbs help users navigate through a website by showing their
/// current location in the page hierarchy. The component wraps a `<ul>`
/// list inside a `<div class="breadcrumbs">` container.
///
/// Individual crumbs are constructed with the `item/1` and `link/2`
/// helper functions, which produce the `<li>` elements that go inside
/// the list. Linked crumbs wrap their content in an `<a>`; the current
/// page crumb omits the anchor.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure breadcrumbs piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/breadcrumbs
/// import lustre/attribute
/// import lustre/element/html
///
/// // A simple three-crumb trail
/// breadcrumbs.new()
/// |> breadcrumbs.attrs([attribute.class("text-sm")])
/// |> breadcrumbs.items([
///   breadcrumbs.link(
///     attrs: [attribute.href("/")],
///     children: [html.text("Home")],
///   ),
///   breadcrumbs.link(
///     attrs: [attribute.href("/docs")],
///     children: [html.text("Documents")],
///   ),
///   breadcrumbs.item([html.text("Add Document")]),
/// ])
/// |> breadcrumbs.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI breadcrumbs](https://daisyui.com/components/breadcrumbs/)
import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates breadcrumbs configuration before
/// being converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a
/// > `Breadcrumbs` directly — use `new/0` to create one and the setter
/// > functions to configure it. This keeps the internal representation
/// > free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Breadcrumbs(msg) {
  Breadcrumbs(
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Breadcrumbs` builder with no attributes or items.
///
/// Chain `attrs/2` and `items/2` to configure it, then call `build/1` to
/// produce a Lustre element.
///
/// ```gleam
/// breadcrumbs.new()
/// |> breadcrumbs.attrs([attribute.class("text-sm max-w-xs")])
/// |> breadcrumbs.items([
///   breadcrumbs.link(attrs: [attribute.href("/")], children: [html.text("Home")]),
///   breadcrumbs.item([html.text("Settings")]),
/// ])
/// |> breadcrumbs.build
/// ```
pub fn new() -> Breadcrumbs(msg) {
  Breadcrumbs(attrs: [], items: [])
}

// ---------------------------------------------------------------------------
// Attrs / Items
// ---------------------------------------------------------------------------

/// Appends additional Lustre attributes to the outer `breadcrumbs` wrapper.
///
/// Multiple calls accumulate — later calls do not replace earlier ones.
/// Use this to add Tailwind utilities such as `text-sm` for font size or
/// `max-w-xs` to constrain the width (which enables horizontal scrolling
/// when the trail overflows).
///
/// ```gleam
/// breadcrumbs.new()
/// |> breadcrumbs.attrs([attribute.class("text-sm max-w-xs")])
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(b: Breadcrumbs(msg), extra: List(Attribute(msg))) -> Breadcrumbs(msg) {
  Breadcrumbs(..b, attrs: list.append(b.attrs, extra))
}

/// Sets the list of crumb elements.
///
/// Replaces any previously set items. Build each crumb with `item/1` (for
/// the current page) or `link/2` (for navigable ancestors).
///
/// ```gleam
/// breadcrumbs.new()
/// |> breadcrumbs.items([
///   breadcrumbs.link(attrs: [attribute.href("/")], children: [html.text("Home")]),
///   breadcrumbs.link(attrs: [attribute.href("/blog")], children: [html.text("Blog")]),
///   breadcrumbs.item([html.text("Post title")]),
/// ])
/// ```
pub fn items(b: Breadcrumbs(msg), crumbs: List(Element(msg))) -> Breadcrumbs(msg) {
  Breadcrumbs(..b, items: crumbs)
}

// ---------------------------------------------------------------------------
// Item helpers
// ---------------------------------------------------------------------------

/// Creates a plain `<li>` crumb — used for the current page.
///
/// Because the current page is not navigable, no `<a>` is rendered.
/// Pass any children directly, including icons alongside text.
///
/// ```gleam
/// breadcrumbs.item([html.text("Add Document")])
///
/// // With an icon:
/// breadcrumbs.item([
///   html.span([attribute.class("inline-flex items-center gap-2")], [
///     my_icon,
///     html.text("Add Document"),
///   ]),
/// ])
/// ```
pub fn item(children ch: List(Element(msg))) -> Element(msg) {
  html.li([], ch)
}

/// Creates a `<li><a>` crumb — used for navigable ancestors.
///
/// `attrs` are applied to the inner `<a>` element, so pass `href`,
/// event handlers, and ARIA attributes here. `children` become the
/// anchor's content — text, icons, or a mix of both.
///
/// ```gleam
/// breadcrumbs.link(
///   attrs: [attribute.href("/")],
///   children: [html.text("Home")],
/// )
///
/// // With an icon:
/// breadcrumbs.link(
///   attrs: [attribute.href("/docs")],
///   children: [my_folder_icon, html.text("Documents")],
/// )
/// ```
///
/// ## Reference
/// - [MDN: `<a>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a)
pub fn link(
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Element(msg) {
  html.li([], [html.a(a, ch)])
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Breadcrumbs` builder into a Lustre `Element(msg)`.
///
/// Renders a `<div class="breadcrumbs">` containing a `<ul>` whose
/// children are the configured crumb elements.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ```gleam
/// // In your Lustre view function:
/// pub fn view(model: Model) -> Element(Msg) {
///   html.div([], [
///     breadcrumbs.new()
///     |> breadcrumbs.attrs([attribute.class("text-sm")])
///     |> breadcrumbs.items(
///       list.map(model.trail, fn(crumb) {
///         case crumb.href {
///           "" -> breadcrumbs.item([html.text(crumb.label)])
///           href ->
///             breadcrumbs.link(
///               attrs: [attribute.href(href)],
///               children: [html.text(crumb.label)],
///             )
///         }
///       }),
///     )
///     |> breadcrumbs.build,
///   ])
/// }
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI breadcrumbs](https://daisyui.com/components/breadcrumbs/)
pub fn build(b: Breadcrumbs(msg)) -> Element(msg) {
  html.div(
    [attribute.class("breadcrumbs"), ..b.attrs],
    [html.ul([], b.items)],
  )
}
