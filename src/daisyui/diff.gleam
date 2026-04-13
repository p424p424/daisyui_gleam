/// A builder for DaisyUI diff elements.
///
/// The diff component shows a side-by-side comparison of two items with a
/// draggable resizer that slides between them. It renders as a `<figure>`
/// containing two content slots and a resizer handle:
///
/// ```html
/// <figure class="diff" tabindex="0">
///   <div class="diff-item-1" role="img" tabindex="0">…</div>
///   <div class="diff-item-2" role="img">…</div>
///   <div class="diff-resizer"></div>
/// </figure>
/// ```
///
/// The resizer is always rendered — it is part of the DaisyUI component
/// structure and enables the drag interaction. The `tabindex="0"` on the
/// outer figure and `diff-item-1` are required for keyboard accessibility.
///
/// The aspect ratio is **not** set automatically — add a Tailwind aspect
/// utility (e.g. `aspect-16/9`) via `attrs/2` to constrain the container.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.figure`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a diff piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/diff
///
/// diff.new()
/// |> diff.attrs([attribute.class("aspect-16/9")])
/// |> diff.item1(
///   attrs: [attribute.attribute("aria-label", "Before")],
///   children: [html.img([attribute.src("/before.webp"), attribute.alt("Before")])],
/// )
/// |> diff.item2(
///   attrs: [attribute.attribute("aria-label", "After")],
///   children: [html.img([attribute.src("/after.webp"), attribute.alt("After")])],
/// )
/// |> diff.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI diff](https://daisyui.com/components/diff/)
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates diff configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Diff`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Diff(msg) {
  Diff(
    attrs: List(Attribute(msg)),
    item1_attrs: List(Attribute(msg)),
    item1_children: List(Element(msg)),
    item2_attrs: List(Attribute(msg)),
    item2_children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Diff` builder with empty slots and no extra attributes.
///
/// Chain `item1/3`, `item2/3`, and optionally `attrs/2` to configure the
/// component, then call `build/1` to produce a Lustre element.
///
/// ```gleam
/// diff.new()
/// |> diff.attrs([attribute.class("aspect-16/9")])
/// |> diff.item1(attrs: [], children: [html.img([attribute.src("/before.webp")])])
/// |> diff.item2(attrs: [], children: [html.img([attribute.src("/after.webp")])])
/// |> diff.build
/// ```
pub fn new() -> Diff(msg) {
  Diff(
    attrs: [],
    item1_attrs: [],
    item1_children: [],
    item2_attrs: [],
    item2_children: [],
  )
}

// ---------------------------------------------------------------------------
// Slots / Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<figure class="diff">`
/// element.
///
/// Use this for aspect-ratio utilities, layout classes, `id`, or ARIA
/// attributes on the container. The `tabindex="0"` required by DaisyUI is
/// added automatically by `build/1`.
///
/// ```gleam
/// diff.new()
/// |> diff.attrs([attribute.class("aspect-16/9 w-full rounded-xl")])
/// |> diff.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(d: Diff(msg), a: List(Attribute(msg))) -> Diff(msg) {
  Diff(..d, attrs: a)
}

/// Sets the first (left/before) slot of the diff.
///
/// `attrs` are merged onto the `<div class="diff-item-1">` element after
/// the required `role="img"` and `tabindex="0"` attributes. `children` fill
/// the slot — typically a single `<img>` or a styled `<div>`.
///
/// ```gleam
/// diff.new()
/// |> diff.item1(
///   attrs: [attribute.attribute("aria-label", "Original")],
///   children: [html.img([attribute.src("/original.webp"), attribute.alt("Original")])],
/// )
/// |> diff.build
/// ```
///
/// ## Reference
/// - [DaisyUI diff](https://daisyui.com/components/diff/)
pub fn item1(
  d: Diff(msg),
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Diff(msg) {
  Diff(..d, item1_attrs: a, item1_children: ch)
}

/// Sets the second (right/after) slot of the diff.
///
/// `attrs` are merged onto the `<div class="diff-item-2">` element after
/// the required `role="img"` attribute. `children` fill the slot.
///
/// ```gleam
/// diff.new()
/// |> diff.item2(
///   attrs: [attribute.attribute("aria-label", "Modified")],
///   children: [html.img([attribute.src("/modified.webp"), attribute.alt("Modified")])],
/// )
/// |> diff.build
/// ```
///
/// ## Reference
/// - [DaisyUI diff](https://daisyui.com/components/diff/)
pub fn item2(
  d: Diff(msg),
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Diff(msg) {
  Diff(..d, item2_attrs: a, item2_children: ch)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Diff` builder into a Lustre `Element(msg)`.
///
/// Renders the full DaisyUI diff structure:
///
/// ```html
/// <figure class="diff" tabindex="0">
///   <div class="diff-item-1" role="img" tabindex="0">…item1 children…</div>
///   <div class="diff-item-2" role="img">…item2 children…</div>
///   <div class="diff-resizer"></div>
/// </figure>
/// ```
///
/// The `tabindex="0"` on the figure and `diff-item-1`, the `role="img"` on
/// both items, and the `diff-resizer` div are always emitted — they are
/// required for the drag interaction and keyboard accessibility.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI diff](https://daisyui.com/components/diff/)
pub fn build(d: Diff(msg)) -> Element(msg) {
  let item1_el =
    html.div(
      [
        attribute.class("diff-item-1"),
        attribute.attribute("role", "img"),
        attribute.attribute("tabindex", "0"),
        ..d.item1_attrs
      ],
      d.item1_children,
    )

  let item2_el =
    html.div(
      [
        attribute.class("diff-item-2"),
        attribute.attribute("role", "img"),
        ..d.item2_attrs
      ],
      d.item2_children,
    )

  let resizer_el = html.div([attribute.class("diff-resizer")], [])

  html.figure(
    [
      attribute.class("diff"),
      attribute.attribute("tabindex", "0"),
      ..d.attrs
    ],
    [item1_el, item2_el, resizer_el],
  )
}
