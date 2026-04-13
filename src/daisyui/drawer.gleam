/// A builder for DaisyUI drawer sidebar elements.
///
/// The drawer is a grid layout that shows or hides a sidebar panel on the
/// left (or right) side of the page. Visibility is controlled by a hidden
/// `<input type="checkbox">` that is toggled by `<label>` elements you
/// place in the content and sidebar.
///
/// The component renders as:
///
/// ```html
/// <div class="drawer [drawer-end] [drawer-open] [lg:drawer-open]">
///   <input id="{id}" type="checkbox" class="drawer-toggle" />
///   <div class="drawer-content" …content_attrs>
///     …page content…
///   </div>
///   <div class="drawer-side">
///     <label for="{id}" aria-label="close sidebar" class="drawer-overlay"></label>
///     …sidebar content…
///   </div>
/// </div>
/// ```
///
/// The checkbox `id` is **required** and must be unique on the page — it
/// links the hidden input to any `<label for="…">` toggle buttons you render
/// inside `content` and `sidebar`.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure a drawer piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/drawer
///
/// // Basic drawer with a toggle button in the page content
/// drawer.new("my-drawer")
/// |> drawer.content([
///   html.label(
///     [attribute.for("my-drawer"), attribute.class("btn drawer-button")],
///     [html.text("Open drawer")],
///   ),
///   html.text("Page content here"),
/// ])
/// |> drawer.sidebar([
///   html.ul([attribute.class("menu bg-base-200 min-h-full w-80 p-4")], [
///     html.li([], [html.a([], [html.text("Item 1")])]),
///     html.li([], [html.a([], [html.text("Item 2")])]),
///   ]),
/// ])
/// |> drawer.build
///
/// // Always-open sidebar on large screens, toggleable on small screens
/// drawer.new("my-drawer")
/// |> drawer.responsive_open("lg")
/// |> drawer.content([…])
/// |> drawer.sidebar([…])
/// |> drawer.build
///
/// // Drawer from the right side
/// drawer.new("my-drawer")
/// |> drawer.end
/// |> drawer.content([…])
/// |> drawer.sidebar([…])
/// |> drawer.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI drawer](https://daisyui.com/components/drawer/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates drawer configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match a `Drawer`
/// > directly — use `new/1` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Drawer(msg) {
  Drawer(
    id: String,
    end: Bool,
    force_open: Bool,
    responsive_open: Option(String),
    attrs: List(Attribute(msg)),
    content_attrs: List(Attribute(msg)),
    content: List(Element(msg)),
    sidebar: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Drawer` builder.
///
/// `id` is set as the `id` attribute on the hidden checkbox and as the
/// `for` attribute on the auto-generated overlay label — it must be unique
/// within the page. Any `<label for="…">` toggle buttons you render inside
/// the content or sidebar area should use the same `id`.
///
/// ```gleam
/// drawer.new("sidebar")
/// |> drawer.content([html.label([attribute.for("sidebar"), attribute.class("btn")], [html.text("Open")])])
/// |> drawer.sidebar([html.ul([attribute.class("menu bg-base-200 min-h-full w-80 p-4")], [])])
/// |> drawer.build
/// ```
pub fn new(id: String) -> Drawer(msg) {
  Drawer(
    id: id,
    end: False,
    force_open: False,
    responsive_open: None,
    attrs: [],
    content_attrs: [],
    content: [],
    sidebar: [],
  )
}

// ---------------------------------------------------------------------------
// Placement / state
// ---------------------------------------------------------------------------

/// Places the sidebar on the **right** side of the page — adds `drawer-end`.
///
/// ## Reference
/// - [DaisyUI drawer](https://daisyui.com/components/drawer/)
pub fn end(d: Drawer(msg)) -> Drawer(msg) {
  Drawer(..d, end: True)
}

/// Forces the drawer **permanently open** — adds `drawer-open`.
///
/// Useful when you want the sidebar always visible regardless of the
/// checkbox state, typically on wide screens.
///
/// For responsive behaviour (open on large screens, toggleable on small)
/// use `responsive_open/2` instead.
///
/// ## Reference
/// - [DaisyUI drawer](https://daisyui.com/components/drawer/)
pub fn open(d: Drawer(msg)) -> Drawer(msg) {
  Drawer(..d, force_open: True)
}

/// Makes the drawer always open at a given Tailwind breakpoint and above,
/// by adding a responsive class such as `lg:drawer-open`.
///
/// Pass the breakpoint prefix as a string — `"sm"`, `"md"`, `"lg"`,
/// `"xl"`, or `"2xl"`. The resulting class is `{prefix}:drawer-open`.
///
/// ```gleam
/// // Sidebar visible on lg screens and above; toggleable on smaller screens
/// drawer.new("nav")
/// |> drawer.responsive_open("lg")
/// |> drawer.build
/// ```
///
/// ## Reference
/// - [DaisyUI drawer responsive](https://daisyui.com/components/drawer/)
pub fn responsive_open(d: Drawer(msg), prefix: String) -> Drawer(msg) {
  Drawer(..d, responsive_open: Some(prefix))
}

// ---------------------------------------------------------------------------
// Attrs / slots
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<div class="drawer">`.
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(d: Drawer(msg), a: List(Attribute(msg))) -> Drawer(msg) {
  Drawer(..d, attrs: a)
}

/// Merges additional Lustre attributes onto the `<div class="drawer-content">`.
///
/// Use this to add layout utilities such as `flex flex-col` when placing a
/// navbar and scrollable content inside the drawer.
///
/// ```gleam
/// drawer.new("nav")
/// |> drawer.content_attrs([attribute.class("flex flex-col")])
/// |> drawer.content([navbar_el, page_content_el])
/// |> drawer.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn content_attrs(d: Drawer(msg), a: List(Attribute(msg))) -> Drawer(msg) {
  Drawer(..d, content_attrs: a)
}

/// Sets the page content rendered inside `<div class="drawer-content">`.
///
/// This is where your navbar, main content, and footer go. Any
/// `<label for="…">` toggle buttons that open the drawer should also live
/// here.
///
/// ```gleam
/// drawer.new("nav")
/// |> drawer.content([
///   html.label([attribute.for("nav"), attribute.class("btn")], [html.text("Open")]),
///   html.text("Main page content"),
/// ])
/// |> drawer.build
/// ```
pub fn content(d: Drawer(msg), ch: List(Element(msg))) -> Drawer(msg) {
  Drawer(..d, content: ch)
}

/// Sets the sidebar content rendered inside `<div class="drawer-side">`,
/// after the auto-generated overlay label.
///
/// Typically a `<ul class="menu …">` list, but can be any element. The
/// overlay `<label>` (which closes the drawer on click) is always rendered
/// automatically by `build/1` — do not include it here.
///
/// ```gleam
/// drawer.new("nav")
/// |> drawer.sidebar([
///   html.ul([attribute.class("menu bg-base-200 min-h-full w-80 p-4")], [
///     html.li([], [html.a([], [html.text("Home")])]),
///     html.li([], [html.a([], [html.text("About")])]),
///   ]),
/// ])
/// |> drawer.build
/// ```
pub fn sidebar(d: Drawer(msg), ch: List(Element(msg))) -> Drawer(msg) {
  Drawer(..d, sidebar: ch)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Drawer` builder into a Lustre `Element(msg)`.
///
/// Renders the full drawer structure:
///
/// ```html
/// <div class="drawer [drawer-end] [drawer-open] [{prefix}:drawer-open]" …attrs>
///   <input id="{id}" type="checkbox" class="drawer-toggle" />
///   <div class="drawer-content" …content_attrs>…content…</div>
///   <div class="drawer-side">
///     <label for="{id}" aria-label="close sidebar" class="drawer-overlay"></label>
///     …sidebar…
///   </div>
/// </div>
/// ```
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI drawer](https://daisyui.com/components/drawer/)
pub fn build(d: Drawer(msg)) -> Element(msg) {
  let component_class =
    [
      Some("drawer"),
      case d.end {
        True -> Some("drawer-end")
        False -> None
      },
      case d.force_open {
        True -> Some("drawer-open")
        False -> None
      },
      option.map(d.responsive_open, fn(prefix) { prefix <> ":drawer-open" }),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let toggle_el =
    html.input([
      attribute.id(d.id),
      attribute.type_("checkbox"),
      attribute.class("drawer-toggle"),
    ])

  let content_el =
    html.div(
      [attribute.class("drawer-content"), ..d.content_attrs],
      d.content,
    )

  let overlay_el =
    html.label(
      [
        attribute.for(d.id),
        attribute.attribute("aria-label", "close sidebar"),
        attribute.class("drawer-overlay"),
      ],
      [],
    )

  let side_el =
    html.div(
      [attribute.class("drawer-side")],
      [overlay_el, ..d.sidebar],
    )

  html.div(
    [attribute.class(component_class), ..d.attrs],
    [toggle_el, content_el, side_el],
  )
}
