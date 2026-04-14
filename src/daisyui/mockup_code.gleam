/// A builder for DaisyUI code mockup elements.
///
/// Code mockup displays a block of code in a box styled like a code editor
/// or terminal. Each line is represented by a `Line` builder that can carry
/// an optional prefix and optional extra classes (e.g. for highlighting).
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/mockup_code
///
/// // Single command line
/// mockup_code.new()
/// |> mockup_code.lines([
///   mockup_code.line("npm i daisyui") |> mockup_code.prefix("$"),
/// ])
/// |> mockup_code.build
///
/// // Multi-line with colours
/// mockup_code.new()
/// |> mockup_code.lines([
///   mockup_code.line("npm i daisyui")  |> mockup_code.prefix("$"),
///   mockup_code.line("installing...")  |> mockup_code.prefix(">") |> mockup_code.line_class("text-warning"),
///   mockup_code.line("Done!")          |> mockup_code.prefix(">") |> mockup_code.line_class("text-success"),
/// ])
/// |> mockup_code.build
/// ```
///
/// ## Reference
/// - [DaisyUI mockup-code](https://daisyui.com/components/mockup-code/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Line type
// ---------------------------------------------------------------------------

/// A single line inside the code mockup.
pub opaque type Line {
  Line(content: String, prefix: Option(String), extra_class: Option(String))
}

/// Creates a new `Line` with the given code content and no prefix.
pub fn line(content: String) -> Line {
  Line(content: content, prefix: None, extra_class: None)
}

/// Sets the `data-prefix` attribute on the `<pre>` element.
///
/// Common values: `"$"`, `">"`, `"~"`, `"1"`, `"2"`, …
pub fn prefix(l: Line, p: String) -> Line {
  Line(..l, prefix: Some(p))
}

/// Appends extra CSS classes to the `<pre>` element (e.g. `"text-warning"`,
/// `"bg-warning text-warning-content"`).
pub fn line_class(l: Line, c: String) -> Line {
  Line(..l, extra_class: Some(c))
}

// ---------------------------------------------------------------------------
// MockupCode type
// ---------------------------------------------------------------------------

pub opaque type MockupCode(msg) {
  MockupCode(
    color: Option(String),
    attrs: List(Attribute(msg)),
    lines: List(Line),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `MockupCode` builder with no lines and no colour override.
pub fn new() -> MockupCode(msg) {
  MockupCode(color: None, attrs: [], lines: [])
}

// ---------------------------------------------------------------------------
// Colour
// ---------------------------------------------------------------------------

/// Overrides the background/text colour with arbitrary Tailwind classes.
///
/// ```gleam
/// mockup_code.new()
/// |> mockup_code.color("bg-primary text-primary-content")
/// |> mockup_code.lines([mockup_code.line("can be any color!")])
/// |> mockup_code.build
/// ```
pub fn color(m: MockupCode(msg), c: String) -> MockupCode(msg) {
  MockupCode(..m, color: Some(c))
}

// ---------------------------------------------------------------------------
// Attrs / lines
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<div>`.
pub fn attrs(m: MockupCode(msg), a: List(Attribute(msg))) -> MockupCode(msg) {
  MockupCode(..m, attrs: a)
}

/// Sets the list of `Line` values to render inside the mockup.
pub fn lines(m: MockupCode(msg), ls: List(Line)) -> MockupCode(msg) {
  MockupCode(..m, lines: ls)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `MockupCode` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <div class="mockup-code [color]" …attrs>
///   <pre [data-prefix="…"] [class="…"]><code>content</code></pre>
///   …
/// </div>
/// ```
pub fn build(m: MockupCode(msg)) -> Element(msg) {
  let class =
    [Some("mockup-code"), m.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let pre_elements =
    list.map(m.lines, fn(l) {
      let pre_attrs =
        [
          case l.prefix {
            Some(p) -> [attribute.attribute("data-prefix", p)]
            None -> []
          },
          case l.extra_class {
            Some(c) -> [attribute.class(c)]
            None -> []
          },
        ]
        |> list.flatten
      html.pre(pre_attrs, [html.code([], [html.text(l.content)])])
    })

  html.div([attribute.class(class), ..m.attrs], pre_elements)
}
