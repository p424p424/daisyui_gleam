/// A builder for DaisyUI countdown elements.
///
/// The countdown component displays a numeric value with a slot-machine
/// transition effect when the number changes. Each `Countdown` builder
/// represents a single digit group — one `<span class="countdown">` wrapper
/// containing one inner `<span>` whose value is set via the `--value` CSS
/// variable.
///
/// Values must be between **0 and 999**. Values outside that range are clamped
/// at build time. The transition animation is driven entirely by CSS — no
/// JavaScript framework is required, though you do need to update the
/// `--value` CSS variable (and the accessible text content) whenever the
/// displayed number changes.
///
/// To build a clock or timer, compose multiple `Countdown` elements
/// separated by label text:
///
/// ```gleam
/// import daisyui/countdown
///
/// // HH:MM:SS clock row
/// html.div([attribute.class("flex gap-5")], [
///   html.span([attribute.class("flex flex-col items-center")], [
///     html.span([attribute.class("countdown font-mono text-4xl")], [
///       countdown.new(10) |> countdown.build,
///     ]),
///     html.text("hours"),
///   ]),
///   // … minutes, seconds …
/// ])
/// ```
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.span`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a countdown piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/countdown
///
/// // Single value — shows "59" with slot-machine transition effect
/// countdown.new(59)
/// |> countdown.build
///
/// // Always show at least 2 digits (e.g. "05" instead of "5")
/// countdown.new(5)
/// |> countdown.min_digits(2)
/// |> countdown.build
///
/// // Extra classes on the outer wrapper
/// countdown.new(42)
/// |> countdown.attrs([attribute.class("font-mono text-4xl")])
/// |> countdown.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI countdown](https://daisyui.com/components/countdown/)
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates countdown configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Countdown`
/// > directly — use `new/1` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Countdown(msg) {
  Countdown(
    value: Int,
    min_digits: Option(Int),
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Countdown` builder for the given numeric value.
///
/// `value` must be between 0 and 999 — values outside that range are clamped
/// to the nearest bound at build time. No icon, no forced min-digits, and no
/// extra attributes are set by default. Chain setter functions to configure,
/// then call `build/1` to produce a Lustre element.
///
/// ```gleam
/// countdown.new(59)
/// |> countdown.build
/// ```
pub fn new(value v: Int) -> Countdown(msg) {
  Countdown(value: v, min_digits: None, attrs: [])
}

// ---------------------------------------------------------------------------
// Modifiers
// ---------------------------------------------------------------------------

/// Forces the displayed value to use at least `n` digits by setting the
/// `--digits` CSS variable on the outer wrapper.
///
/// DaisyUI supports `2` and `3`. Passing any other value is a no-op at the
/// CSS level — the variable is still set, but DaisyUI ignores unknown values.
///
/// ```gleam
/// // Shows "05" instead of "5"
/// countdown.new(5)
/// |> countdown.min_digits(2)
/// |> countdown.build
///
/// // Shows "005"
/// countdown.new(5)
/// |> countdown.min_digits(3)
/// |> countdown.build
/// ```
///
/// ## Reference
/// - [DaisyUI countdown](https://daisyui.com/components/countdown/)
pub fn min_digits(c: Countdown(msg), n: Int) -> Countdown(msg) {
  Countdown(..c, min_digits: Some(n))
}

/// Merges additional Lustre attributes onto the outer
/// `<span class="countdown">` element.
///
/// Useful for adding font-size utilities, layout classes, an `id`, or ARIA
/// attributes to the wrapper.
///
/// ```gleam
/// countdown.new(99)
/// |> countdown.attrs([attribute.class("font-mono text-5xl")])
/// |> countdown.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(c: Countdown(msg), a: List(Attribute(msg))) -> Countdown(msg) {
  Countdown(..c, attrs: a)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Countdown` builder into a Lustre `Element(msg)`.
///
/// The value is clamped to 0–999. The rendered HTML is:
///
/// ```html
/// <span class="countdown" [style="--digits:N;"]>
///   <span style="--value:V;" aria-live="polite" aria-label="V">V</span>
/// </span>
/// ```
///
/// The `aria-live="polite"` attribute on the inner span announces value
/// changes to screen readers without interrupting ongoing speech.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI countdown](https://daisyui.com/components/countdown/)
pub fn build(c: Countdown(msg)) -> Element(msg) {
  let clamped = c.value |> int.max(0) |> int.min(999)
  let value_str = int.to_string(clamped)

  let digits_style_attr = case c.min_digits {
    Some(n) ->
      [attribute.attribute("style", "--digits:" <> int.to_string(n) <> ";")]
    None -> []
  }

  let inner =
    html.span(
      [
        attribute.attribute("style", "--value:" <> value_str <> ";"),
        attribute.attribute("aria-live", "polite"),
        attribute.attribute("aria-label", value_str),
      ],
      [html.text(value_str)],
    )

  html.span(
    list.append([attribute.class("countdown"), ..digits_style_attr], c.attrs),
    [inner],
  )
}
