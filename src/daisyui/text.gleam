/// A builder for styled text elements — `<span>`, `<p>`, and `<h1>`–`<h6>`.
///
/// Text styling in this library is pure Tailwind CSS — no DaisyUI component
/// classes are involved. That means size, colour, and weight are all
/// controlled by standard Tailwind utilities (`text-xl`, `text-primary`,
/// `font-bold`), while colour values are still resolved through DaisyUI's
/// semantic theme variables at runtime.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.span`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a text element piece-by-piece before calling
/// > `build/1` to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/text
///
/// // A bold, primary-coloured h2 at 3xl size
/// text.new()
/// |> text.h2
/// |> text.xl3
/// |> text.bold
/// |> text.primary
/// |> text.text("Hello, world!")
/// |> text.build
///
/// // A small muted caption
/// text.new()
/// |> text.sm
/// |> text.base_content
/// |> text.text("Last updated 5 minutes ago")
/// |> text.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
/// - [Tailwind text-color](https://tailwindcss.com/docs/text-color)
/// - [Tailwind font-weight](https://tailwindcss.com/docs/font-weight)
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
import daisyui/tokens.{
  type Color, type TextSize, type Weight, color_class, text_size_class,
  weight_class,
}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// The HTML element that `build/1` will render.
///
/// Choosing the right element matters for accessibility and SEO — screen
/// readers and search engines use heading levels to understand page structure.
/// Use `Span` for inline text within a sentence, `P` for standalone
/// paragraphs, and `H1`–`H6` for headings in descending importance.
///
/// > **Note:** Heading level should reflect document structure, not visual
/// > size. Use `xl3` (or any size function) separately to control how large
/// > a heading appears.
///
/// Defaults to `Span` when a `Text` is created with `new/0`.
pub type TextElement {
  /// Inline element — wraps text within a line without breaking flow.
  /// Maps to `<span>`.
  Span
  /// Block-level paragraph. Adds vertical spacing above and below by
  /// default. Maps to `<p>`.
  P
  /// Top-level heading — there should only be one `H1` per page. Maps to
  /// `<h1>`.
  H1
  /// Second-level heading. Maps to `<h2>`.
  H2
  /// Third-level heading. Maps to `<h3>`.
  H3
  /// Fourth-level heading. Maps to `<h4>`.
  H4
  /// Fifth-level heading. Maps to `<h5>`.
  H5
  /// Sixth-level heading — the least prominent. Maps to `<h6>`.
  H6
}

/// An opaque builder that accumulates text configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Text`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Text(msg) {
  Text(
    element: TextElement,
    size: Option(TextSize),
    color: Option(Color),
    weight: Option(Weight),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Text` builder with no classes applied.
///
/// Defaults to a `<span>` element with no size, colour, weight, extra
/// attributes, or children. Chain setter functions to configure it, then
/// call `build/1` to produce a Lustre element.
///
/// ```gleam
/// text.new()
/// |> text.p
/// |> text.lg
/// |> text.text("Hello!")
/// |> text.build
/// ```
pub fn new() -> Text(msg) {
  Text(
    element: Span,
    size: None,
    color: None,
    weight: None,
    attrs: [],
    children: [],
  )
}

// ---------------------------------------------------------------------------
// Element
// ---------------------------------------------------------------------------

/// Renders as `<span>` — the default inline element.
///
/// Use `span` when the text is part of a larger block (e.g. a highlighted
/// word within a sentence).
///
/// ## Reference
/// - [MDN: `<span>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/span)
pub fn span(t: Text(msg)) -> Text(msg) {
  Text(..t, element: Span)
}

/// Renders as `<p>` — a block-level paragraph.
///
/// Browsers add vertical margin above and below paragraphs by default.
/// Use for standalone sentences or blocks of body text.
///
/// ## Reference
/// - [MDN: `<p>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/p)
pub fn p(t: Text(msg)) -> Text(msg) {
  Text(..t, element: P)
}

/// Renders as `<h1>` — the most important heading on the page.
///
/// There should be exactly one `<h1>` per page for correct document
/// structure and SEO.
///
/// ## Reference
/// - [MDN: heading elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)
pub fn h1(t: Text(msg)) -> Text(msg) {
  Text(..t, element: H1)
}

/// Renders as `<h2>` — a section heading, one level below `<h1>`.
///
/// ## Reference
/// - [MDN: heading elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)
pub fn h2(t: Text(msg)) -> Text(msg) {
  Text(..t, element: H2)
}

/// Renders as `<h3>` — a sub-section heading.
///
/// ## Reference
/// - [MDN: heading elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)
pub fn h3(t: Text(msg)) -> Text(msg) {
  Text(..t, element: H3)
}

/// Renders as `<h4>`.
///
/// ## Reference
/// - [MDN: heading elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)
pub fn h4(t: Text(msg)) -> Text(msg) {
  Text(..t, element: H4)
}

/// Renders as `<h5>`.
///
/// ## Reference
/// - [MDN: heading elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)
pub fn h5(t: Text(msg)) -> Text(msg) {
  Text(..t, element: H5)
}

/// Renders as `<h6>` — the least prominent heading level.
///
/// ## Reference
/// - [MDN: heading elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)
pub fn h6(t: Text(msg)) -> Text(msg) {
  Text(..t, element: H6)
}

// ---------------------------------------------------------------------------
// Size
// ---------------------------------------------------------------------------
// Applies a Tailwind font-size class. Each step also adjusts line-height via
// a CSS custom property, so text stays well-spaced without manual tweaking.
// Reference: https://tailwindcss.com/docs/font-size

/// Sets font-size to `text-xs` — **0.75 rem / 12 px**.
///
/// Good for labels, captions, and legal/fine-print text.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn xs(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextXS))
}

/// Sets font-size to `text-sm` — **0.875 rem / 14 px**.
///
/// Common for secondary body text and helper messages.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn sm(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextSM))
}

/// Sets font-size to `text-base` — **1 rem / 16 px**.
///
/// The browser's default body text size. A solid choice for main content.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn base(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextBase))
}

/// Sets font-size to `text-lg` — **1.125 rem / 18 px**.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn lg(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextLG))
}

/// Sets font-size to `text-xl` — **1.25 rem / 20 px**.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn xl(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextXL))
}

/// Sets font-size to `text-2xl` — **1.5 rem / 24 px**.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn xl2(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextXL2))
}

/// Sets font-size to `text-3xl` — **1.875 rem / 30 px**.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn xl3(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextXL3))
}

/// Sets font-size to `text-4xl` — **2.25 rem / 36 px**.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn xl4(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextXL4))
}

/// Sets font-size to `text-5xl` — **3 rem / 48 px**.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn xl5(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextXL5))
}

/// Sets font-size to `text-6xl` — **3.75 rem / 60 px**.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn xl6(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextXL6))
}

/// Sets font-size to `text-7xl` — **4.5 rem / 72 px**.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn xl7(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextXL7))
}

/// Sets font-size to `text-8xl` — **6 rem / 96 px**.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn xl8(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextXL8))
}

/// Sets font-size to `text-9xl` — **8 rem / 128 px**.
///
/// The largest step in Tailwind's scale — suitable for hero displays and
/// large typographic statements.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn xl9(t: Text(msg)) -> Text(msg) {
  Text(..t, size: Some(tokens.TextXL9))
}

// ---------------------------------------------------------------------------
// Color
// ---------------------------------------------------------------------------
// Applies a Tailwind text-color utility using DaisyUI's semantic colour
// tokens. The value resolves at runtime through the active DaisyUI theme,
// so changing themes updates every colour automatically.
//
// Reference:
//   https://tailwindcss.com/docs/text-color
//   https://daisyui.com/docs/colors/

/// Sets text colour to `text-primary` — the theme's primary brand colour.
///
/// Use for the most important text on the page or to match primary action
/// elements. Resolves via `--color-primary`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
/// - [Tailwind text-color](https://tailwindcss.com/docs/text-color)
pub fn primary(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.Primary))
}

/// Sets text colour to `text-primary-content`.
///
/// Use for text or icons placed *on top of* a primary-coloured background
/// (e.g. inside a primary button). Resolves via `--color-primary-content`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn primary_content(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.PrimaryContent))
}

/// Sets text colour to `text-secondary`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn secondary(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.Secondary))
}

/// Sets text colour to `text-secondary-content`.
///
/// Use for text placed on a secondary-coloured background.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn secondary_content(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.SecondaryContent))
}

/// Sets text colour to `text-accent`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn accent(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.Accent))
}

/// Sets text colour to `text-accent-content`.
///
/// Use for text placed on an accent-coloured background.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn accent_content(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.AccentContent))
}

/// Sets text colour to `text-neutral`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn neutral(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.Neutral))
}

/// Sets text colour to `text-neutral-content`.
///
/// Use for text placed on a neutral-coloured background.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn neutral_content(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.NeutralContent))
}

/// Sets text colour to `text-info` — informational blue.
///
/// Use for tips, hints, or non-critical messages.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn info(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.Info))
}

/// Sets text colour to `text-info-content`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn info_content(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.InfoContent))
}

/// Sets text colour to `text-success` — success green.
///
/// Use to confirm a completed action or valid state.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn success(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.Success))
}

/// Sets text colour to `text-success-content`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn success_content(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.SuccessContent))
}

/// Sets text colour to `text-warning` — warning yellow/orange.
///
/// Use to signal caution or a recoverable issue.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn warning(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.Warning))
}

/// Sets text colour to `text-warning-content`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn warning_content(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.WarningContent))
}

/// Sets text colour to `text-error` — error red.
///
/// Use for validation messages, destructive confirmations, or failure states.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn error(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.Error))
}

/// Sets text colour to `text-error-content`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn error_content(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.ErrorContent))
}

/// Sets text colour to `text-base-content` — the default body text colour
/// for the current theme.
///
/// This is the colour most body copy should use. It is automatically set
/// on `<body>` by DaisyUI, so you only need to apply it explicitly when
/// overriding a colour set by a parent element.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn base_content(t: Text(msg)) -> Text(msg) {
  Text(..t, color: Some(tokens.BaseContent))
}

// ---------------------------------------------------------------------------
// Weight
// ---------------------------------------------------------------------------
// Applies a Tailwind font-weight utility class.
// Reference: https://tailwindcss.com/docs/font-weight

/// Sets font-weight to `font-thin` — **100**.
///
/// The finest stroke available. Use sparingly; thin text can be hard to read
/// at small sizes or on low-contrast backgrounds.
///
/// ## Reference
/// - [Tailwind font-weight](https://tailwindcss.com/docs/font-weight)
pub fn thin(t: Text(msg)) -> Text(msg) {
  Text(..t, weight: Some(tokens.Thin))
}

/// Sets font-weight to `font-light` — **300**.
///
/// ## Reference
/// - [Tailwind font-weight](https://tailwindcss.com/docs/font-weight)
pub fn light(t: Text(msg)) -> Text(msg) {
  Text(..t, weight: Some(tokens.Light))
}

/// Sets font-weight to `font-normal` — **400**.
///
/// The browser default for body text. Useful for explicitly resetting weight
/// inside a context that sets a heavier default.
///
/// ## Reference
/// - [Tailwind font-weight](https://tailwindcss.com/docs/font-weight)
pub fn normal(t: Text(msg)) -> Text(msg) {
  Text(..t, weight: Some(tokens.Normal))
}

/// Sets font-weight to `font-medium` — **500**.
///
/// Slightly heavier than normal — good for labels and UI chrome.
///
/// ## Reference
/// - [Tailwind font-weight](https://tailwindcss.com/docs/font-weight)
pub fn medium(t: Text(msg)) -> Text(msg) {
  Text(..t, weight: Some(tokens.Medium))
}

/// Sets font-weight to `font-semibold` — **600**.
///
/// A common choice for headings and emphasis without full bold.
///
/// ## Reference
/// - [Tailwind font-weight](https://tailwindcss.com/docs/font-weight)
pub fn semibold(t: Text(msg)) -> Text(msg) {
  Text(..t, weight: Some(tokens.Semibold))
}

/// Sets font-weight to `font-bold` — **700**.
///
/// The conventional "bold" — use for headings and strong emphasis.
///
/// ## Reference
/// - [Tailwind font-weight](https://tailwindcss.com/docs/font-weight)
pub fn bold(t: Text(msg)) -> Text(msg) {
  Text(..t, weight: Some(tokens.Bold))
}

/// Sets font-weight to `font-extrabold` — **800**.
///
/// ## Reference
/// - [Tailwind font-weight](https://tailwindcss.com/docs/font-weight)
pub fn extrabold(t: Text(msg)) -> Text(msg) {
  Text(..t, weight: Some(tokens.ExtraBold))
}

/// Sets font-weight to `font-black` — **900**.
///
/// The heaviest weight available — good for hero headings and display text.
///
/// ## Reference
/// - [Tailwind font-weight](https://tailwindcss.com/docs/font-weight)
pub fn black(t: Text(msg)) -> Text(msg) {
  Text(..t, weight: Some(tokens.Black))
}

// ---------------------------------------------------------------------------
// Attrs / Children
// ---------------------------------------------------------------------------

/// Appends additional Lustre attributes to the element.
///
/// Multiple calls accumulate — later calls do not replace earlier ones.
/// Useful for attaching event handlers, IDs, ARIA attributes, or any other
/// HTML attribute not covered by the builder functions.
///
/// ```gleam
/// import lustre/attribute
/// import lustre/event
///
/// text.new()
/// |> text.span
/// |> text.bold
/// |> text.attrs([
///   attribute.id("username"),
///   event.on_click(UserClicked),
/// ])
/// |> text.text("Click me")
/// |> text.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(t: Text(msg), a: List(Attribute(msg))) -> Text(msg) {
  Text(..t, attrs: list.append(t.attrs, a))
}

/// Sets the children to an arbitrary list of Lustre elements.
///
/// Replaces any children previously set by `children/2` or `text/2`.
/// Use when you need to nest elements inside the text container — for
/// example, a `<p>` containing both plain text and a `<strong>` span.
///
/// ```gleam
/// import lustre/element/html
///
/// text.new()
/// |> text.p
/// |> text.children([
///   html.text("Read the "),
///   html.strong([], [html.text("release notes")]),
///   html.text(" for details."),
/// ])
/// |> text.build
/// ```
///
/// ## Reference
/// - [Lustre element module](https://hexdocs.pm/lustre/)
pub fn children(t: Text(msg), ch: List(Element(msg))) -> Text(msg) {
  Text(..t, children: ch)
}

/// Sets the children to a single plain text node.
///
/// Shorthand for the common case of rendering a string. Replaces any
/// children previously set by `children/2` or a prior `text/2` call.
///
/// ```gleam
/// text.new()
/// |> text.h1
/// |> text.xl4
/// |> text.text("Welcome back")
/// |> text.build
/// ```
pub fn text(t: Text(msg), content: String) -> Text(msg) {
  Text(..t, children: [html.text(content)])
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Text` builder into a Lustre `Element(msg)`.
///
/// Collects all configured Tailwind classes into a single `class` attribute
/// (omitted entirely if no classes were set), then delegates to the
/// appropriate `lustre/element/html` constructor based on the chosen element.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ```gleam
/// // In your Lustre view function:
/// pub fn view(model: Model) -> Element(Msg) {
///   html.div([], [
///     text.new()
///     |> text.h1
///     |> text.xl4
///     |> text.bold
///     |> text.primary
///     |> text.text("Dashboard")
///     |> text.build,
///
///     text.new()
///     |> text.p
///     |> text.base_content
///     |> text.text("Welcome back, " <> model.username)
///     |> text.build,
///   ])
/// }
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
pub fn build(t: Text(msg)) -> Element(msg) {
  let classes =
    [
      option.map(t.size, text_size_class),
      option.map(t.color, color_class("text", _)),
      option.map(t.weight, weight_class),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let all_attrs = case classes {
    "" -> t.attrs
    _ -> [attribute.class(classes), ..t.attrs]
  }

  case t.element {
    Span -> html.span(all_attrs, t.children)
    P -> html.p(all_attrs, t.children)
    H1 -> html.h1(all_attrs, t.children)
    H2 -> html.h2(all_attrs, t.children)
    H3 -> html.h3(all_attrs, t.children)
    H4 -> html.h4(all_attrs, t.children)
    H5 -> html.h5(all_attrs, t.children)
    H6 -> html.h6(all_attrs, t.children)
  }
}
