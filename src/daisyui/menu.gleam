/// A builder for DaisyUI menu elements.
///
/// Menu is a list of links that can be used for navigation. Items can be
/// grouped with titles, nested into submenus, and marked as active or disabled.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/menu
/// import lustre/attribute
/// import lustre/element/html
///
/// // Basic vertical menu
/// menu.new()
/// |> menu.children([
///   html.li([], [html.a([], [html.text("Home")])]),
///   html.li([], [html.a([], [html.text("About")])]),
/// ])
/// |> menu.build
///
/// // Horizontal menu
/// menu.new()
/// |> menu.horizontal
/// |> menu.children([...])
/// |> menu.build
/// ```
///
/// ## Item helpers
///
/// DaisyUI menu classes used directly on children:
/// - `menu-title` on `<li>` — section heading
/// - `menu-active` on `<a>` — active/selected state
/// - `menu-disabled` on `<li>` — disabled item
/// - `menu-focus` on `<a>` — focused state
///
/// ## Submenus
///
/// Use `<details>` / `<summary>` for collapsible submenus:
/// ```gleam
/// html.li([], [
///   html.details([], [
///     html.summary([], [html.text("Parent")]),
///     html.ul([], [html.li([], [html.a([], [html.text("Child")])])]),
///   ]),
/// ])
/// ```
///
/// Or use `menu-dropdown` / `menu-dropdown-toggle` / `menu-dropdown-show`
/// for JS-controlled submenus.
///
/// ## Reference
/// - [DaisyUI menu](https://daisyui.com/components/menu/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

pub opaque type Menu(msg) {
  Menu(
    horizontal: Bool,
    size: Option(String),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Menu` builder. Defaults to vertical layout.
pub fn new() -> Menu(msg) {
  Menu(horizontal: False, size: None, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Horizontal layout — adds `menu-horizontal`.
pub fn horizontal(m: Menu(msg)) -> Menu(msg) {
  Menu(..m, horizontal: True)
}

/// Vertical layout (default) — adds `menu-vertical`.
pub fn vertical(m: Menu(msg)) -> Menu(msg) {
  Menu(..m, horizontal: False)
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Extra small size — `menu-xs`.
pub fn xs(m: Menu(msg)) -> Menu(msg) {
  Menu(..m, size: Some("menu-xs"))
}

/// Small size — `menu-sm`.
pub fn sm(m: Menu(msg)) -> Menu(msg) {
  Menu(..m, size: Some("menu-sm"))
}

/// Medium size — `menu-md`.
pub fn md(m: Menu(msg)) -> Menu(msg) {
  Menu(..m, size: Some("menu-md"))
}

/// Large size — `menu-lg`.
pub fn lg(m: Menu(msg)) -> Menu(msg) {
  Menu(..m, size: Some("menu-lg"))
}

/// Extra large size — `menu-xl`.
pub fn xl(m: Menu(msg)) -> Menu(msg) {
  Menu(..m, size: Some("menu-xl"))
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<ul>`.
pub fn attrs(m: Menu(msg), a: List(Attribute(msg))) -> Menu(msg) {
  Menu(..m, attrs: a)
}

/// Sets the `<li>` children of the menu.
pub fn children(m: Menu(msg), c: List(Element(msg))) -> Menu(msg) {
  Menu(..m, children: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Menu` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <ul class="menu [menu-horizontal|menu-vertical] [menu-xs|…]" …attrs>
///   children
/// </ul>
/// ```
pub fn build(m: Menu(msg)) -> Element(msg) {
  let direction_class = case m.horizontal {
    True -> Some("menu-horizontal")
    False -> None
  }
  let class =
    [Some("menu"), direction_class, m.size]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.ul([attribute.class(class), ..m.attrs], m.children)
}
