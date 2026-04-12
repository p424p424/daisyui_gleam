/// A builder for DaisyUI carousel elements.
///
/// Carousels display images or content in a horizontally or vertically
/// scrollable area with CSS scroll-snap. The component is a container
/// (`carousel`) holding one or more `carousel-item` children.
///
/// Build each item with the `item/1` helper, then pass the list to
/// `items/2` on the builder.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a carousel piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/carousel
/// import lustre/attribute
/// import lustre/element/html
///
/// // A basic image carousel that snaps to the centre of each item
/// carousel.new()
/// |> carousel.center
/// |> carousel.attrs([attribute.class("rounded-box")])
/// |> carousel.items([
///   carousel.item([html.img([attribute.src("/slide1.webp"), attribute.alt("Slide 1")])]),
///   carousel.item([html.img([attribute.src("/slide2.webp"), attribute.alt("Slide 2")])]),
///   carousel.item([html.img([attribute.src("/slide3.webp"), attribute.alt("Slide 3")])]),
/// ])
/// |> carousel.build
///
/// // A vertical carousel
/// carousel.new()
/// |> carousel.vertical
/// |> carousel.attrs([attribute.class("h-96 rounded-box")])
/// |> carousel.items(
///   list.map(slides, fn(s) {
///     carousel.item([html.img([attribute.src(s.url)])])
///   }),
/// )
/// |> carousel.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI carousel](https://daisyui.com/components/carousel/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// Controls which edge of each item the scroll-snap aligns to.
///
/// | Value    | Class               | Behaviour                        |
/// |----------|---------------------|----------------------------------|
/// | `Start`  | `carousel-start`    | Snaps to the leading edge (default) |
/// | `Center` | `carousel-center`   | Snaps to the centre of each item |
/// | `End`    | `carousel-end`      | Snaps to the trailing edge       |
///
/// When no snap is set the browser falls back to DaisyUI's default, which
/// is equivalent to `Start`.
pub type SnapPosition {
  /// Scroll-snap aligns to the leading edge of each item. Maps to
  /// `carousel-start`.
  Start
  /// Scroll-snap aligns to the centre of each item. Maps to
  /// `carousel-center`.
  Center
  /// Scroll-snap aligns to the trailing edge of each item. Maps to
  /// `carousel-end`.
  End
}

/// Controls the scroll direction of the carousel.
///
/// | Value        | Class                  | Behaviour         |
/// |--------------|------------------------|-------------------|
/// | `Horizontal` | `carousel-horizontal`  | Scrolls left/right (default) |
/// | `Vertical`   | `carousel-vertical`    | Scrolls up/down   |
///
/// When no direction is set the carousel scrolls horizontally.
pub type CarouselDirection {
  /// Items are laid out and scroll left/right. Maps to
  /// `carousel-horizontal`.
  Horizontal
  /// Items are laid out and scroll up/down. Maps to `carousel-vertical`.
  Vertical
}

/// An opaque builder that accumulates carousel configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a
/// > `Carousel` directly — use `new/0` to create one and the setter
/// > functions to configure it. This keeps the internal representation
/// > free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Carousel(msg) {
  Carousel(
    snap: Option(SnapPosition),
    direction: Option(CarouselDirection),
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Carousel` builder with no snap position, no explicit
/// direction, no extra attributes, and no items.
///
/// Chain setter functions to configure it, then call `build/1` to produce
/// a Lustre element.
///
/// ```gleam
/// carousel.new()
/// |> carousel.center
/// |> carousel.attrs([attribute.class("rounded-box w-full")])
/// |> carousel.items([
///   carousel.item([html.img([attribute.src("/a.webp")])]),
///   carousel.item([html.img([attribute.src("/b.webp")])]),
/// ])
/// |> carousel.build
/// ```
pub fn new() -> Carousel(msg) {
  Carousel(snap: None, direction: None, attrs: [], items: [])
}

// ---------------------------------------------------------------------------
// Snap position
// ---------------------------------------------------------------------------

/// Sets scroll-snap to align to the **leading edge** of each item
/// (`carousel-start`).
///
/// This is DaisyUI's default behaviour; call it explicitly when you want
/// to be clear about the intent or when overriding a previously set snap.
///
/// ## Reference
/// - [DaisyUI carousel](https://daisyui.com/components/carousel/)
pub fn start(c: Carousel(msg)) -> Carousel(msg) {
  Carousel(..c, snap: Some(Start))
}

/// Sets scroll-snap to align to the **centre** of each item
/// (`carousel-center`).
///
/// Good for when items are narrower than the viewport and you want the
/// active item visually centred.
///
/// ## Reference
/// - [DaisyUI carousel](https://daisyui.com/components/carousel/)
pub fn center(c: Carousel(msg)) -> Carousel(msg) {
  Carousel(..c, snap: Some(Center))
}

/// Sets scroll-snap to align to the **trailing edge** of each item
/// (`carousel-end`).
///
/// ## Reference
/// - [DaisyUI carousel](https://daisyui.com/components/carousel/)
pub fn end(c: Carousel(msg)) -> Carousel(msg) {
  Carousel(..c, snap: Some(End))
}

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Sets the carousel to scroll **horizontally** (`carousel-horizontal`).
///
/// This is DaisyUI's default direction; call it explicitly when you want
/// to be clear about the intent or when overriding a previously set
/// direction.
///
/// ## Reference
/// - [DaisyUI carousel](https://daisyui.com/components/carousel/)
pub fn horizontal(c: Carousel(msg)) -> Carousel(msg) {
  Carousel(..c, direction: Some(Horizontal))
}

/// Sets the carousel to scroll **vertically** (`carousel-vertical`).
///
/// Remember to constrain the container height with a Tailwind utility
/// such as `h-96` via `attrs/2`, otherwise the carousel will expand to
/// fit all items and no scrolling will occur.
///
/// ## Reference
/// - [DaisyUI carousel](https://daisyui.com/components/carousel/)
pub fn vertical(c: Carousel(msg)) -> Carousel(msg) {
  Carousel(..c, direction: Some(Vertical))
}

// ---------------------------------------------------------------------------
// Attrs / Items
// ---------------------------------------------------------------------------

/// Appends additional Lustre attributes to the carousel container.
///
/// Multiple calls accumulate — later calls do not replace earlier ones.
/// Use for Tailwind utilities such as `rounded-box`, `w-full`, or `h-96`,
/// IDs, ARIA attributes, or event handlers.
///
/// ```gleam
/// carousel.new()
/// |> carousel.attrs([attribute.class("rounded-box w-full")])
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(c: Carousel(msg), extra: List(Attribute(msg))) -> Carousel(msg) {
  Carousel(..c, attrs: list.append(c.attrs, extra))
}

/// Sets the list of carousel items.
///
/// Replaces any previously set items. Build each item with `item/1` or
/// construct `<div class="carousel-item">` elements by hand.
///
/// ```gleam
/// carousel.new()
/// |> carousel.items(
///   list.map(model.slides, fn(slide) {
///     carousel.item([
///       html.img([attribute.src(slide.url), attribute.alt(slide.caption)]),
///     ])
///   }),
/// )
/// ```
pub fn items(c: Carousel(msg), slides: List(Element(msg))) -> Carousel(msg) {
  Carousel(..c, items: slides)
}

// ---------------------------------------------------------------------------
// Item helper
// ---------------------------------------------------------------------------

/// Creates a `<div class="carousel-item">` element.
///
/// Pass the item's content — typically a single `<img>` — as `children`.
/// Any valid Lustre element works: images, cards, custom content, etc.
///
/// ```gleam
/// carousel.item([
///   html.img([attribute.src("/slide.webp"), attribute.alt("Slide")]),
/// ])
///
/// // An item with a full-width div and an ID for anchor-based navigation
/// carousel.item([
///   html.div(
///     [attribute.id("slide1"), attribute.class("w-full")],
///     [html.text("Slide 1")],
///   ),
/// ])
/// ```
pub fn item(children ch: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("carousel-item")], ch)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Carousel` builder into a Lustre `Element(msg)`.
///
/// Assembles the DaisyUI class string from the `carousel` base class plus
/// any snap and direction modifiers, then renders a `<div>` with the
/// configured attributes and items as children.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ```gleam
/// // In your Lustre view function:
/// pub fn view(model: Model) -> Element(Msg) {
///   carousel.new()
///   |> carousel.center
///   |> carousel.attrs([attribute.class("rounded-box w-full")])
///   |> carousel.items(
///     list.map(model.slides, fn(slide) {
///       carousel.item([
///         html.img([attribute.src(slide.url), attribute.alt(slide.alt)]),
///       ])
///     }),
///   )
///   |> carousel.build
/// }
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI carousel](https://daisyui.com/components/carousel/)
pub fn build(c: Carousel(msg)) -> Element(msg) {
  let classes =
    [
      Some("carousel"),
      option.map(c.snap, fn(s) {
        case s {
          Start -> "carousel-start"
          Center -> "carousel-center"
          End -> "carousel-end"
        }
      }),
      option.map(c.direction, fn(d) {
        case d {
          Horizontal -> "carousel-horizontal"
          Vertical -> "carousel-vertical"
        }
      }),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.div([attribute.class(classes), ..c.attrs], c.items)
}
