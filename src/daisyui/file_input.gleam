/// A builder for DaisyUI file input elements.
///
/// File input renders an `<input type="file">` with DaisyUI styling.
/// Supports ghost style, eight colour variants, five size variants,
/// and a disabled state.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.input`) and pass them `Attribute`
/// > lists. This module wraps that pattern in a builder so you can configure
/// > a file input piece-by-piece before calling `build/1` to turn it into
/// > an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/file_input
///
/// // Basic file input
/// file_input.new()
/// |> file_input.build
///
/// // Primary colour, large, inside a fieldset
/// file_input.new()
/// |> file_input.primary
/// |> file_input.lg
/// |> file_input.build
///
/// // Ghost style, disabled
/// file_input.new()
/// |> file_input.ghost
/// |> file_input.disabled
/// |> file_input.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI file input](https://daisyui.com/components/file-input/)
import daisyui/tokens.{type Color, type Size, color_class, size_class}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates file input configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a
/// > `FileInput` directly — use `new/0` to create one and the setter
/// > functions to configure it. This keeps the internal representation
/// > free to change.
pub opaque type FileInput(msg) {
  FileInput(
    color: Option(Color),
    size: Option(Size),
    ghost: Bool,
    disabled: Bool,
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `FileInput` builder with no colour, default size, no ghost
/// style, not disabled, and no extra attributes.
///
/// ```gleam
/// file_input.new()
/// |> file_input.primary
/// |> file_input.build
/// ```
pub fn new() -> FileInput(msg) {
  FileInput(color: None, size: None, ghost: False, disabled: False, attrs: [])
}

// ---------------------------------------------------------------------------
// Style
// ---------------------------------------------------------------------------

/// Apply the **ghost** style — `file-input-ghost`.
///
/// ## Reference
/// - [DaisyUI file input](https://daisyui.com/components/file-input/)
pub fn ghost(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, ghost: True)
}

// ---------------------------------------------------------------------------
// Color
// ---------------------------------------------------------------------------

/// Sets the colour to `file-input-neutral`.
pub fn neutral(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, color: Some(tokens.Neutral))
}

/// Sets the colour to `file-input-primary`.
pub fn primary(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, color: Some(tokens.Primary))
}

/// Sets the colour to `file-input-secondary`.
pub fn secondary(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, color: Some(tokens.Secondary))
}

/// Sets the colour to `file-input-accent`.
pub fn accent(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, color: Some(tokens.Accent))
}

/// Sets the colour to `file-input-info`.
pub fn info(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, color: Some(tokens.Info))
}

/// Sets the colour to `file-input-success`.
pub fn success(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, color: Some(tokens.Success))
}

/// Sets the colour to `file-input-warning`.
pub fn warning(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, color: Some(tokens.Warning))
}

/// Sets the colour to `file-input-error`.
pub fn error(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, color: Some(tokens.Error))
}

// ---------------------------------------------------------------------------
// Size
// ---------------------------------------------------------------------------

/// Sets the size to `file-input-xs`.
pub fn xs(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, size: Some(tokens.XS))
}

/// Sets the size to `file-input-sm`.
pub fn sm(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, size: Some(tokens.SM))
}

/// Sets the size to `file-input-md` (the default).
pub fn md(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, size: Some(tokens.MD))
}

/// Sets the size to `file-input-lg`.
pub fn lg(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, size: Some(tokens.LG))
}

/// Sets the size to `file-input-xl`.
pub fn xl(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, size: Some(tokens.XL))
}

// ---------------------------------------------------------------------------
// State / attrs
// ---------------------------------------------------------------------------

/// Disables the input — adds the HTML `disabled` attribute and the
/// `file-input-disabled` class.
///
/// ## Reference
/// - [DaisyUI file input](https://daisyui.com/components/file-input/)
pub fn disabled(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, disabled: True)
}

/// Merges additional Lustre attributes onto the `<input>` element.
///
/// Use this for `id`, `name`, `accept`, `multiple`, event handlers, or
/// any other attribute not covered by the builder setters.
///
/// ```gleam
/// file_input.new()
/// |> file_input.attrs([
///   attribute.id("avatar"),
///   attribute.attribute("accept", "image/*"),
///   attribute.attribute("multiple", ""),
/// ])
/// |> file_input.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(f: FileInput(msg), a: List(Attribute(msg))) -> FileInput(msg) {
  FileInput(..f, attrs: a)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `FileInput` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <input type="file" class="file-input [ghost] [color] [size] [disabled]"
///        [disabled] …attrs />
/// ```
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI file input](https://daisyui.com/components/file-input/)
pub fn build(f: FileInput(msg)) -> Element(msg) {
  let component_class =
    [
      Some("file-input"),
      case f.ghost {
        True -> Some("file-input-ghost")
        False -> None
      },
      option.map(f.color, color_class("file-input", _)),
      option.map(f.size, size_class("file-input", _)),
      case f.disabled {
        True -> Some("file-input-disabled")
        False -> None
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let disabled_attrs = case f.disabled {
    True -> [attribute.disabled(True)]
    False -> []
  }

  html.input(
    [attribute.type_("file"), attribute.class(component_class)]
      |> list.append(disabled_attrs)
      |> list.append(f.attrs),
  )
}
