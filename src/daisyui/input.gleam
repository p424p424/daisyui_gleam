/// A builder for DaisyUI text input elements.
///
/// The `input` class can be applied to two HTML structures:
///
/// - **Plain input** (default) — `<input type="text" class="input …" />`.
///   Use `new/0` and set extra attributes via `attrs/2`.
/// - **Label wrapper** — `<label class="input …">…</label>` with an inner
///   `<input class="grow">` and optional icons, badges, or keyboard hints.
///   Use `label/0` and provide inner elements via `children/2`.
///
/// Both variants support ghost style, eight colour modifiers, five size
/// modifiers, a disabled state, and an optional `validator` class for
/// DaisyUI's built-in validation styling.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/input
/// import lustre/attribute
/// import lustre/element/html
///
/// // Plain input
/// input.new()
/// |> input.primary
/// |> input.attrs([attribute.placeholder("Email")])
/// |> input.build
///
/// // Label wrapper with search icon and keyboard hint
/// input.label()
/// |> input.children([
///   search_icon(),
///   html.input([attribute.type_("search"), attribute.class("grow"),
///               attribute.placeholder("Search")]),
///   html.kbd([attribute.class("kbd kbd-sm")], [html.text("⌘")]),
///   html.kbd([attribute.class("kbd kbd-sm")], [html.text("K")]),
/// ])
/// |> input.build
/// ```
///
/// ## Reference
/// - [DaisyUI text input](https://daisyui.com/components/input/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// Whether to render as a plain `<input>` or a `<label>` wrapper.
type InputVariant {
  PlainInput
  LabelWrapper
}

/// An opaque builder that accumulates input configuration before being
/// converted to a Lustre element by `build/1`.
pub opaque type Input(msg) {
  Input(
    variant: InputVariant,
    color: Option(String),
    size: Option(String),
    ghost: Bool,
    disabled: Bool,
    validator: Bool,
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructors
// ---------------------------------------------------------------------------

/// Creates a new `Input` builder for a plain `<input type="text" class="input …">`.
///
/// Use `attrs/2` to set `type_`, `placeholder`, `value`, event handlers, etc.
///
/// ```gleam
/// input.new()
/// |> input.primary
/// |> input.attrs([
///   attribute.type_("email"),
///   attribute.placeholder("mail@site.com"),
/// ])
/// |> input.build
/// ```
pub fn new() -> Input(msg) {
  Input(
    variant: PlainInput,
    color: None,
    size: None,
    ghost: False,
    disabled: False,
    validator: False,
    attrs: [],
    children: [],
  )
}

/// Creates a new `Input` builder for a `<label class="input …">` wrapper.
///
/// Use this when you want to embed icons, keyboard hints, or badge labels
/// alongside the text input. Place the inner `<input class="grow">` and any
/// surrounding elements via `children/2`.
///
/// ```gleam
/// input.label()
/// |> input.children([
///   icon_element,
///   html.input([attribute.type_("search"), attribute.class("grow"),
///               attribute.placeholder("Search")]),
/// ])
/// |> input.build
/// ```
pub fn label() -> Input(msg) {
  Input(
    variant: LabelWrapper,
    color: None,
    size: None,
    ghost: False,
    disabled: False,
    validator: False,
    attrs: [],
    children: [],
  )
}

// ---------------------------------------------------------------------------
// Ghost
// ---------------------------------------------------------------------------

/// Adds the `input-ghost` style — transparent background.
pub fn ghost(i: Input(msg)) -> Input(msg) {
  Input(..i, ghost: True)
}

// ---------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------

/// Applies the `input-neutral` colour modifier.
pub fn neutral(i: Input(msg)) -> Input(msg) {
  Input(..i, color: Some("input-neutral"))
}

/// Applies the `input-primary` colour modifier.
pub fn primary(i: Input(msg)) -> Input(msg) {
  Input(..i, color: Some("input-primary"))
}

/// Applies the `input-secondary` colour modifier.
pub fn secondary(i: Input(msg)) -> Input(msg) {
  Input(..i, color: Some("input-secondary"))
}

/// Applies the `input-accent` colour modifier.
pub fn accent(i: Input(msg)) -> Input(msg) {
  Input(..i, color: Some("input-accent"))
}

/// Applies the `input-info` colour modifier.
pub fn info(i: Input(msg)) -> Input(msg) {
  Input(..i, color: Some("input-info"))
}

/// Applies the `input-success` colour modifier.
pub fn success(i: Input(msg)) -> Input(msg) {
  Input(..i, color: Some("input-success"))
}

/// Applies the `input-warning` colour modifier.
pub fn warning(i: Input(msg)) -> Input(msg) {
  Input(..i, color: Some("input-warning"))
}

/// Applies the `input-error` colour modifier.
pub fn error(i: Input(msg)) -> Input(msg) {
  Input(..i, color: Some("input-error"))
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Applies the `input-xs` size modifier.
pub fn xs(i: Input(msg)) -> Input(msg) {
  Input(..i, size: Some("input-xs"))
}

/// Applies the `input-sm` size modifier.
pub fn sm(i: Input(msg)) -> Input(msg) {
  Input(..i, size: Some("input-sm"))
}

/// Applies the `input-md` size modifier.
pub fn md(i: Input(msg)) -> Input(msg) {
  Input(..i, size: Some("input-md"))
}

/// Applies the `input-lg` size modifier.
pub fn lg(i: Input(msg)) -> Input(msg) {
  Input(..i, size: Some("input-lg"))
}

/// Applies the `input-xl` size modifier.
pub fn xl(i: Input(msg)) -> Input(msg) {
  Input(..i, size: Some("input-xl"))
}

// ---------------------------------------------------------------------------
// Disabled / validator
// ---------------------------------------------------------------------------

/// Disables the input — adds the `disabled` HTML attribute.
///
/// For the plain-input variant this sets the HTML `disabled` attribute.
/// For the label-wrapper variant, add `disabled` to the inner `<input>`
/// element directly via its own `attribute.disabled(True)`.
pub fn disabled(i: Input(msg)) -> Input(msg) {
  Input(..i, disabled: True)
}

/// Adds the `validator` class for DaisyUI's built-in validation styling.
///
/// Pair with the browser's native constraint API (`required`, `pattern`,
/// `minlength`, etc.) on the inner `<input>` element. DaisyUI shows
/// success/error colours automatically based on `:valid`/`:invalid` state.
///
/// ```gleam
/// input.label()
/// |> input.validator
/// |> input.children([
///   html.input([
///     attribute.type_("email"),
///     attribute.class("grow"),
///     attribute.required(True),
///     attribute.placeholder("mail@site.com"),
///   ]),
/// ])
/// |> input.build
/// ```
pub fn validator(i: Input(msg)) -> Input(msg) {
  Input(..i, validator: True)
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer element.
///
/// For the plain-input variant these land on the `<input>` itself — use this
/// for `type_`, `placeholder`, `value`, `name`, event handlers, etc.
///
/// For the label-wrapper variant these land on the `<label>` element.
pub fn attrs(i: Input(msg), a: List(Attribute(msg))) -> Input(msg) {
  Input(..i, attrs: a)
}

/// Sets the child elements rendered inside a label-wrapper input.
///
/// Only meaningful when using the `label/0` constructor. Ignored when using
/// `new/0` (which renders a self-closing `<input>`).
///
/// ```gleam
/// input.label()
/// |> input.children([
///   icon,
///   html.input([attribute.type_("text"), attribute.class("grow"),
///               attribute.placeholder("…")]),
///   html.span([attribute.class("badge badge-neutral badge-xs")],
///             [html.text("Optional")]),
/// ])
/// |> input.build
/// ```
pub fn children(i: Input(msg), c: List(Element(msg))) -> Input(msg) {
  Input(..i, children: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Input` builder into a Lustre `Element(msg)`.
///
/// **Plain-input** renders:
///
/// ```html
/// <input type="text" class="input [ghost] [color] [size]" …attrs />
/// ```
///
/// **Label-wrapper** renders:
///
/// ```html
/// <label class="input [validator] [ghost] [color] [size]" …attrs>
///   …children
/// </label>
/// ```
///
/// Always call this at the end of a builder chain.
pub fn build(i: Input(msg)) -> Element(msg) {
  let ghost_class = case i.ghost {
    True -> Some("input-ghost")
    False -> None
  }
  let validator_class = case i.validator {
    True -> Some("validator")
    False -> None
  }
  let class =
    [Some("input"), validator_class, ghost_class, i.color, i.size]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  case i.variant {
    PlainInput -> {
      let disabled_attr = case i.disabled {
        True -> [attribute.disabled(True)]
        False -> []
      }
      html.input(
        [attribute.class(class), attribute.type_("text")]
        |> list.append(disabled_attr)
        |> list.append(i.attrs),
      )
    }
    LabelWrapper ->
      html.label([attribute.class(class), ..i.attrs], i.children)
  }
}
