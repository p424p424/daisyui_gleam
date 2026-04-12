/// A builder for DaisyUI card elements.
///
/// Cards group and display content in a readable, contained layout. The
/// component is a multi-part structure: an outer wrapper (`card`), an
/// optional `<figure>` for images, and a body section that holds an
/// optional title, arbitrary content, and optional actions.
///
/// The builder assembles these parts in the correct order. For cases where
/// you need full structural control, the standalone `title_part/2`,
/// `body_part/2`, and `actions_part/2` helpers produce the individual
/// sub-elements directly.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a card piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/card
/// import lustre/attribute
/// import lustre/element/html
///
/// // A simple card with an image, title, body text, and an action button
/// card.new()
/// |> card.border
/// |> card.figure([html.img([attribute.src("/shoes.webp"), attribute.alt("Shoes")])])
/// |> card.title([html.text("Card Title")])
/// |> card.body([html.p([], [html.text("A description of the product.")])])
/// |> card.actions(
///   attrs: [attribute.class("justify-end")],
///   children: [buy_now_button],
/// )
/// |> card.build
///
/// // A side-image card
/// card.new()
/// |> card.side
/// |> card.figure([html.img([attribute.src("/profile.webp")])])
/// |> card.body([html.p([], [html.text("Side image layout.")])])
/// |> card.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI card](https://daisyui.com/components/card/)
import daisyui/tokens.{type Size, size_class}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// The border style applied to the card wrapper.
///
/// | Style    | Class         | Effect                          |
/// |----------|---------------|---------------------------------|
/// | `Border` | `card-border` | Solid border around the card    |
/// | `Dash`   | `card-dash`   | Dashed border around the card   |
///
/// Omit to render the card without an explicit border (relying on
/// background colour or shadow to define the boundary).
pub type CardStyle {
  /// Adds a solid border. Maps to `card-border`.
  Border
  /// Adds a dashed border. Maps to `card-dash`.
  Dash
}

/// An opaque builder that accumulates card configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Card`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Card(msg) {
  Card(
    style: Option(CardStyle),
    side: Bool,
    image_full: Bool,
    size: Option(Size),
    attrs: List(Attribute(msg)),
    figure_children: Option(List(Element(msg))),
    title_children: Option(List(Element(msg))),
    body_children: List(Element(msg)),
    body_attrs: List(Attribute(msg)),
    actions_children: Option(List(Element(msg))),
    actions_attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Card` builder with no classes, no figure, and empty
/// body content.
///
/// Chain setter functions to configure it, then call `build/1` to produce
/// a Lustre element.
///
/// ```gleam
/// card.new()
/// |> card.border
/// |> card.title([html.text("Hello")])
/// |> card.body([html.p([], [html.text("Card content.")])])
/// |> card.build
/// ```
pub fn new() -> Card(msg) {
  Card(
    style: None,
    side: False,
    image_full: False,
    size: None,
    attrs: [],
    figure_children: None,
    title_children: None,
    body_children: [],
    body_attrs: [],
    actions_children: None,
    actions_attrs: [],
  )
}

// ---------------------------------------------------------------------------
// Style
// ---------------------------------------------------------------------------

/// Applies `card-border` — a solid border around the card.
///
/// ## Reference
/// - [DaisyUI card](https://daisyui.com/components/card/)
pub fn border(c: Card(msg)) -> Card(msg) {
  Card(..c, style: Some(Border))
}

/// Applies `card-dash` — a dashed border around the card.
///
/// ## Reference
/// - [DaisyUI card](https://daisyui.com/components/card/)
pub fn dash(c: Card(msg)) -> Card(msg) {
  Card(..c, style: Some(Dash))
}

// ---------------------------------------------------------------------------
// Modifier
// ---------------------------------------------------------------------------

/// Applies `card-side` — places the `<figure>` image to the side of the
/// body content rather than above it.
///
/// Use for horizontal card layouts, such as product list rows.
///
/// ## Reference
/// - [DaisyUI card](https://daisyui.com/components/card/)
pub fn side(c: Card(msg)) -> Card(msg) {
  Card(..c, side: True)
}

/// Applies `image-full` — the `<figure>` image becomes a full-bleed
/// background behind the card body.
///
/// The body text is overlaid on top of the image, so ensure sufficient
/// contrast with a coloured text or overlay.
///
/// ## Reference
/// - [DaisyUI card](https://daisyui.com/components/card/)
pub fn image_full(c: Card(msg)) -> Card(msg) {
  Card(..c, image_full: True)
}

// ---------------------------------------------------------------------------
// Size
// ---------------------------------------------------------------------------

/// Sets the card size to `card-xs` — extra small padding and font size.
///
/// ## Reference
/// - [DaisyUI card](https://daisyui.com/components/card/)
pub fn xs(c: Card(msg)) -> Card(msg) {
  Card(..c, size: Some(tokens.XS))
}

/// Sets the card size to `card-sm` — small padding and font size.
///
/// ## Reference
/// - [DaisyUI card](https://daisyui.com/components/card/)
pub fn sm(c: Card(msg)) -> Card(msg) {
  Card(..c, size: Some(tokens.SM))
}

/// Sets the card size to `card-md` — the default medium size.
///
/// ## Reference
/// - [DaisyUI card](https://daisyui.com/components/card/)
pub fn md(c: Card(msg)) -> Card(msg) {
  Card(..c, size: Some(tokens.MD))
}

/// Sets the card size to `card-lg` — large padding and font size.
///
/// ## Reference
/// - [DaisyUI card](https://daisyui.com/components/card/)
pub fn lg(c: Card(msg)) -> Card(msg) {
  Card(..c, size: Some(tokens.LG))
}

/// Sets the card size to `card-xl` — extra large padding and font size.
///
/// ## Reference
/// - [DaisyUI card](https://daisyui.com/components/card/)
pub fn xl(c: Card(msg)) -> Card(msg) {
  Card(..c, size: Some(tokens.XL))
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Appends additional Lustre attributes to the outer card wrapper.
///
/// Multiple calls accumulate — later calls do not replace earlier ones.
/// Use for Tailwind utilities (`w-96`, `shadow-sm`, background colours),
/// IDs, ARIA attributes, or event handlers.
///
/// ```gleam
/// card.new()
/// |> card.attrs([attribute.class("w-96 shadow-sm bg-base-100")])
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(c: Card(msg), extra: List(Attribute(msg))) -> Card(msg) {
  Card(..c, attrs: list.append(c.attrs, extra))
}

/// Appends additional Lustre attributes to the `card-body` wrapper div.
///
/// Multiple calls accumulate. Use for Tailwind utilities or ARIA
/// attributes on the body section specifically.
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn body_attrs(c: Card(msg), extra: List(Attribute(msg))) -> Card(msg) {
  Card(..c, body_attrs: list.append(c.body_attrs, extra))
}

// ---------------------------------------------------------------------------
// Parts
// ---------------------------------------------------------------------------

/// Sets the `<figure>` element's children.
///
/// Replaces any previously set figure children. Typically contains a
/// single `<img>` element. Omit to render a card with no figure.
///
/// ```gleam
/// card.new()
/// |> card.figure([
///   html.img([attribute.src("/product.webp"), attribute.alt("Product photo")]),
/// ])
/// ```
///
/// ## Reference
/// - [MDN: `<figure>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/figure)
pub fn figure(c: Card(msg), children ch: List(Element(msg))) -> Card(msg) {
  Card(..c, figure_children: Some(ch))
}

/// Sets the `<h2 class="card-title">` children.
///
/// Replaces any previously set title children. Rendered inside the
/// `card-body` div as the first child. Omit to render a card without
/// a title.
///
/// ```gleam
/// card.new()
/// |> card.title([html.text("Product Name")])
/// ```
pub fn title(c: Card(msg), children ch: List(Element(msg))) -> Card(msg) {
  Card(..c, title_children: Some(ch))
}

/// Sets the main body content — the children rendered between the title
/// and the actions inside `card-body`.
///
/// Replaces any previously set body children. Pass any mix of elements:
/// paragraphs, badges, lists, etc.
///
/// ```gleam
/// card.new()
/// |> card.body([
///   html.p([], [html.text("A great product at a great price.")]),
/// ])
/// ```
pub fn body(c: Card(msg), children ch: List(Element(msg))) -> Card(msg) {
  Card(..c, body_children: ch)
}

/// Sets the `<div class="card-actions">` children and optional attributes.
///
/// Rendered as the last child inside `card-body`. Use `attrs` for
/// alignment utilities such as `justify-end` or `justify-center`. Omit
/// to render a card with no actions row.
///
/// ```gleam
/// card.new()
/// |> card.actions(
///   attrs: [attribute.class("justify-end")],
///   children: [buy_button, wishlist_button],
/// )
/// ```
pub fn actions(
  c: Card(msg),
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Card(msg) {
  Card(
    ..c,
    actions_children: Some(ch),
    actions_attrs: list.append(c.actions_attrs, a),
  )
}

// ---------------------------------------------------------------------------
// Standalone part helpers
// ---------------------------------------------------------------------------

/// Creates a `<h2 class="card-title">` element directly.
///
/// Use this when building a card body by hand rather than through the
/// builder, or when you need a different heading level alongside the
/// `card-title` class.
///
/// ```gleam
/// card.title_part([], [html.text("Card Title")])
///
/// // As an h3:
/// html.h3([attribute.class("card-title")], [html.text("Section")])
/// ```
pub fn title_part(
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Element(msg) {
  html.h2([attribute.class("card-title"), ..a], ch)
}

/// Creates a `<div class="card-body">` element directly.
///
/// Use this when composing a card's inner structure by hand rather than
/// through the builder.
///
/// ```gleam
/// card.body_part([], [
///   card.title_part([], [html.text("Title")]),
///   html.p([], [html.text("Content")]),
///   card.actions_part([attribute.class("justify-end")], [button]),
/// ])
/// ```
pub fn body_part(
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Element(msg) {
  html.div([attribute.class("card-body"), ..a], ch)
}

/// Creates a `<div class="card-actions">` element directly.
///
/// Use this when composing a card's body by hand rather than through the
/// builder. Pass alignment utilities such as `justify-end` via `attrs`.
///
/// ```gleam
/// card.actions_part(
///   [attribute.class("justify-end")],
///   [buy_button],
/// )
/// ```
pub fn actions_part(
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Element(msg) {
  html.div([attribute.class("card-actions"), ..a], ch)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Card` builder into a Lustre `Element(msg)`.
///
/// Assembles the outer class string, then constructs the element tree in
/// the correct DaisyUI order:
///
/// 1. `<figure>` — only rendered when `figure/2` was called.
/// 2. `<div class="card-body">` — only rendered when any of `title/2`,
///    `body/2`, or `actions/3` were called; contains:
///    a. `<h2 class="card-title">` — only when `title/2` was called.
///    b. Body children — from `body/2`.
///    c. `<div class="card-actions">` — only when `actions/3` was called.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ```gleam
/// // In your Lustre view function:
/// pub fn view(model: Model) -> Element(Msg) {
///   card.new()
///   |> card.attrs([attribute.class("w-96 shadow-sm bg-base-100")])
///   |> card.figure([html.img([attribute.src(model.image_url)])])
///   |> card.title([html.text(model.product_name)])
///   |> card.body([html.p([], [html.text(model.description)])])
///   |> card.actions(
///     attrs: [attribute.class("justify-end")],
///     children: [buy_button],
///   )
///   |> card.build
/// }
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI card](https://daisyui.com/components/card/)
pub fn build(c: Card(msg)) -> Element(msg) {
  let classes =
    [
      Some("card"),
      option.map(c.style, fn(s) {
        case s {
          Border -> "card-border"
          Dash -> "card-dash"
        }
      }),
      option.map(c.size, size_class("card", _)),
      case c.side { True -> Some("card-side") False -> None },
      case c.image_full { True -> Some("image-full") False -> None },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let figure_section = case c.figure_children {
    Some(ch) -> [html.figure([], ch)]
    None -> []
  }

  let title_section = case c.title_children {
    Some(ch) -> [html.h2([attribute.class("card-title")], ch)]
    None -> []
  }

  let actions_section = case c.actions_children {
    Some(ch) ->
      [html.div([attribute.class("card-actions"), ..c.actions_attrs], ch)]
    None -> []
  }

  let has_body =
    !list.is_empty(c.body_children)
    || option.is_some(c.title_children)
    || option.is_some(c.actions_children)

  let body_section = case has_body {
    True -> [
      html.div(
        [attribute.class("card-body"), ..c.body_attrs],
        list.flatten([title_section, c.body_children, actions_section]),
      ),
    ]
    False -> []
  }

  html.div(
    [attribute.class(classes), ..c.attrs],
    list.flatten([figure_section, body_section]),
  )
}
