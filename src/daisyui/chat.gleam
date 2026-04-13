/// A builder for DaisyUI chat bubble elements.
///
/// Chat bubbles display a single line of conversation together with its
/// contextual data — author image, header text (name + time), the bubble
/// itself, and footer text (status). Each bubble is either left-aligned
/// (`chat-start`) or right-aligned (`chat-end`).
///
/// The component renders as a `<div class="chat chat-start|chat-end">` wrapping
/// up to four optional sub-elements:
///
/// ```
/// <div class="chat chat-start">
///   <div class="chat-image">   …avatar… </div>    ← optional
///   <div class="chat-header">  …name/time… </div>  ← optional
///   <div class="chat-bubble">  …message… </div>    ← always rendered
///   <div class="chat-footer">  …status… </div>     ← optional
/// </div>
/// ```
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a chat bubble piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/chat
///
/// // Minimal left-aligned bubble
/// chat.new()
/// |> chat.start
/// |> chat.text("It's over Anakin, I have the high ground.")
/// |> chat.build
///
/// // Right-aligned bubble with colour, header, and footer
/// chat.new()
/// |> chat.end
/// |> chat.primary
/// |> chat.header(attrs: [], children: [
///   html.text("Anakin  "),
///   html.time([attribute.class("text-xs opacity-50")], [html.text("12:45")]),
/// ])
/// |> chat.text("You underestimate my power!")
/// |> chat.footer(attrs: [], children: [html.text("Delivered")])
/// |> chat.build
///
/// // Bubble with an avatar image
/// chat.new()
/// |> chat.start
/// |> chat.image(children: [
///   html.div([attribute.class("w-10 rounded-full")], [
///     html.img([attribute.src("/avatar.png"), attribute.alt("Obi-Wan")]),
///   ]),
/// ])
/// |> chat.text("Hello there.")
/// |> chat.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI chat bubble](https://daisyui.com/components/chat/)
import daisyui/tokens.{type Color, color_class}
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// Whether the bubble is aligned to the leading (`chat-start`) or
/// trailing (`chat-end`) edge of the container.
///
/// `chat-start` and `chat-end` are required by DaisyUI — every chat bubble
/// must have one. The builder defaults to `Start`; call `end/1` to override.
///
/// | Constructor | Class        | Effect                             |
/// |-------------|--------------|------------------------------------|
/// | `Start`     | `chat-start` | Aligns bubble to the left/start    |
/// | `End`       | `chat-end`   | Aligns bubble to the right/end     |
pub type ChatPlacement {
  /// Aligns the bubble to the leading edge. Maps to `chat-start`.
  Start
  /// Aligns the bubble to the trailing edge. Maps to `chat-end`.
  End
}

/// An opaque builder that accumulates chat bubble configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Chat`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Chat(msg) {
  Chat(
    placement: ChatPlacement,
    color: Option(Color),
    attrs: List(Attribute(msg)),
    image: Option(List(Element(msg))),
    header: Option(List(Element(msg))),
    header_attrs: List(Attribute(msg)),
    footer: Option(List(Element(msg))),
    footer_attrs: List(Attribute(msg)),
    bubble: List(Element(msg)),
    bubble_attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Chat` builder with default settings.
///
/// Defaults to `Start` placement, no colour, no image, no header, no footer,
/// empty bubble content, and no extra attributes. Call setters to configure
/// the bubble, then call `build/1` to produce a Lustre element.
///
/// ```gleam
/// chat.new()
/// |> chat.end
/// |> chat.primary
/// |> chat.text("You underestimate my power!")
/// |> chat.build
/// ```
pub fn new() -> Chat(msg) {
  Chat(
    placement: Start,
    color: None,
    attrs: [],
    image: None,
    header: None,
    header_attrs: [],
    footer: None,
    footer_attrs: [],
    bubble: [],
    bubble_attrs: [],
  )
}

// ---------------------------------------------------------------------------
// Placement
// ---------------------------------------------------------------------------

/// Aligns the bubble to the **leading** edge — `chat-start`.
///
/// This is the default, so you only need to call it explicitly when
/// overriding a previously set `end/1`.
///
/// ## Reference
/// - [DaisyUI chat bubble](https://daisyui.com/components/chat/)
pub fn start(c: Chat(msg)) -> Chat(msg) {
  Chat(..c, placement: Start)
}

/// Aligns the bubble to the **trailing** edge — `chat-end`.
///
/// Use for messages sent by the local user.
///
/// ## Reference
/// - [DaisyUI chat bubble](https://daisyui.com/components/chat/)
pub fn end(c: Chat(msg)) -> Chat(msg) {
  Chat(..c, placement: End)
}

// ---------------------------------------------------------------------------
// Color
// ---------------------------------------------------------------------------

/// Sets the bubble colour to `chat-bubble-neutral`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn neutral(c: Chat(msg)) -> Chat(msg) {
  Chat(..c, color: Some(tokens.Neutral))
}

/// Sets the bubble colour to `chat-bubble-primary`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn primary(c: Chat(msg)) -> Chat(msg) {
  Chat(..c, color: Some(tokens.Primary))
}

/// Sets the bubble colour to `chat-bubble-secondary`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn secondary(c: Chat(msg)) -> Chat(msg) {
  Chat(..c, color: Some(tokens.Secondary))
}

/// Sets the bubble colour to `chat-bubble-accent`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn accent(c: Chat(msg)) -> Chat(msg) {
  Chat(..c, color: Some(tokens.Accent))
}

/// Sets the bubble colour to `chat-bubble-info` — informational blue.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn info(c: Chat(msg)) -> Chat(msg) {
  Chat(..c, color: Some(tokens.Info))
}

/// Sets the bubble colour to `chat-bubble-success` — success green.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn success(c: Chat(msg)) -> Chat(msg) {
  Chat(..c, color: Some(tokens.Success))
}

/// Sets the bubble colour to `chat-bubble-warning` — warning yellow/orange.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn warning(c: Chat(msg)) -> Chat(msg) {
  Chat(..c, color: Some(tokens.Warning))
}

/// Sets the bubble colour to `chat-bubble-error` — error red.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn error(c: Chat(msg)) -> Chat(msg) {
  Chat(..c, color: Some(tokens.Error))
}

// ---------------------------------------------------------------------------
// Slots
// ---------------------------------------------------------------------------

/// Sets the `chat-image` slot — typically an avatar image.
///
/// The children are wrapped in `<div class="chat-image">`. Omit this call to
/// render no image column.
///
/// ```gleam
/// chat.new()
/// |> chat.image(children: [
///   html.div([attribute.class("w-10 rounded-full")], [
///     html.img([attribute.src("/avatar.png"), attribute.alt("Me")]),
///   ]),
/// ])
/// |> chat.text("Hello!")
/// |> chat.build
/// ```
///
/// ## Reference
/// - [DaisyUI chat bubble](https://daisyui.com/components/chat/)
pub fn image(c: Chat(msg), children ch: List(Element(msg))) -> Chat(msg) {
  Chat(..c, image: Some(ch))
}

/// Sets the `chat-header` slot — text shown above the bubble (e.g. name and time).
///
/// `attrs` are merged onto the `<div class="chat-header">` element. Omit
/// this call to render no header.
///
/// ```gleam
/// chat.new()
/// |> chat.header(attrs: [], children: [
///   html.text("Obi-Wan  "),
///   html.time([attribute.class("text-xs opacity-50")], [html.text("12:00")]),
/// ])
/// |> chat.text("Hello there.")
/// |> chat.build
/// ```
///
/// ## Reference
/// - [DaisyUI chat bubble](https://daisyui.com/components/chat/)
pub fn header(
  c: Chat(msg),
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Chat(msg) {
  Chat(..c, header: Some(ch), header_attrs: a)
}

/// Sets the `chat-footer` slot — text shown below the bubble (e.g. delivery status).
///
/// `attrs` are merged onto the `<div class="chat-footer">` element. Omit
/// this call to render no footer.
///
/// ```gleam
/// chat.new()
/// |> chat.text("Seen")
/// |> chat.footer(attrs: [attribute.class("opacity-50")], children: [
///   html.text("Delivered"),
/// ])
/// |> chat.build
/// ```
///
/// ## Reference
/// - [DaisyUI chat bubble](https://daisyui.com/components/chat/)
pub fn footer(
  c: Chat(msg),
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Chat(msg) {
  Chat(..c, footer: Some(ch), footer_attrs: a)
}

// ---------------------------------------------------------------------------
// Attrs / Children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<div class="chat">` element.
///
/// Useful for custom layout classes, `id`, ARIA roles, or event handlers on
/// the container.
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(c: Chat(msg), a: List(Attribute(msg))) -> Chat(msg) {
  Chat(..c, attrs: a)
}

/// Merges additional Lustre attributes onto the `<div class="chat-bubble">` element.
///
/// Use this to attach classes (e.g. custom max-width), event handlers, or
/// ARIA attributes directly to the bubble.
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn bubble_attrs(c: Chat(msg), a: List(Attribute(msg))) -> Chat(msg) {
  Chat(..c, bubble_attrs: a)
}

/// Sets the bubble content to an arbitrary list of Lustre elements.
///
/// Replaces any content previously set by `children/2` or `text/2`. Use
/// when you need to embed elements inside the bubble — for example, an image
/// or a formatted message.
///
/// ## Reference
/// - [Lustre element module](https://hexdocs.pm/lustre/)
pub fn children(c: Chat(msg), ch: List(Element(msg))) -> Chat(msg) {
  Chat(..c, bubble: ch)
}

/// Sets the bubble content to a single plain text node.
///
/// Shorthand for the common case of a text-only message. Replaces any
/// content previously set by `children/2` or a prior `text/2` call.
///
/// ```gleam
/// chat.new()
/// |> chat.end
/// |> chat.text("You underestimate my power!")
/// |> chat.build
/// ```
pub fn text(c: Chat(msg), content: String) -> Chat(msg) {
  Chat(..c, bubble: [html.text(content)])
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Chat` builder into a Lustre `Element(msg)`.
///
/// Assembles the placement class, bubble colour class, and all optional
/// sub-elements (image, header, footer), then renders the full chat structure:
///
/// ```html
/// <div class="chat chat-start|chat-end">
///   <div class="chat-image">…</div>         <!-- if image set -->
///   <div class="chat-header">…</div>        <!-- if header set -->
///   <div class="chat-bubble [color]">…</div>
///   <div class="chat-footer">…</div>        <!-- if footer set -->
/// </div>
/// ```
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI chat bubble](https://daisyui.com/components/chat/)
pub fn build(c: Chat(msg)) -> Element(msg) {
  let placement_class = case c.placement {
    Start -> "chat-start"
    End -> "chat-end"
  }

  let bubble_class = case option.map(c.color, color_class("chat-bubble", _)) {
    Some(color_cls) -> "chat-bubble " <> color_cls
    None -> "chat-bubble"
  }

  let image_el =
    option.map(c.image, fn(ch) { html.div([attribute.class("chat-image")], ch) })

  let header_el =
    option.map(c.header, fn(ch) {
      html.div([attribute.class("chat-header"), ..c.header_attrs], ch)
    })

  let bubble_el =
    html.div([attribute.class(bubble_class), ..c.bubble_attrs], c.bubble)

  let footer_el =
    option.map(c.footer, fn(ch) {
      html.div([attribute.class("chat-footer"), ..c.footer_attrs], ch)
    })

  let inner =
    [image_el, header_el, Some(bubble_el), footer_el]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })

  html.div(
    [attribute.class("chat " <> placement_class), ..c.attrs],
    inner,
  )
}
