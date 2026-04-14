/// Builders for DaisyUI tabs elements.
///
/// Two patterns are supported:
///
/// **Link / button tabs** — simple `<a role="tab">` elements:
/// ```gleam
/// tabs.new()
/// |> tabs.lift
/// |> tabs.children([
///   tabs.tab("Tab 1") |> tabs.tab_build,
///   tabs.tab("Tab 2") |> tabs.tab_active |> tabs.tab_build,
///   tabs.tab("Tab 3") |> tabs.tab_build,
/// ])
/// |> tabs.build
/// ```
///
/// **Radio tabs with content** — `<input type="radio">` + `<div class="tab-content">` pairs.
/// Use `tabs.radio_items/2` to generate the interleaved list:
/// ```gleam
/// tabs.new()
/// |> tabs.lift
/// |> tabs.children(
///   tabs.radio_items("my_tabs", [
///     tabs.radio_item("Tab 1", [html.text("Content 1")], False),
///     tabs.radio_item("Tab 2", [html.text("Content 2")], True),
///     tabs.radio_item("Tab 3", [html.text("Content 3")], False),
///   ]),
/// )
/// |> tabs.build
/// ```
///
/// ## Reference
/// - [DaisyUI tabs](https://daisyui.com/components/tabs/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Tab item (link/button style)
// ---------------------------------------------------------------------------

/// A single `<a role="tab" class="tab …">` item.
pub opaque type Tab(msg) {
  Tab(
    label: String,
    active: Bool,
    disabled: Bool,
    attrs: List(Attribute(msg)),
  )
}

/// Creates a new `Tab` with the given label.
pub fn tab(label: String) -> Tab(msg) {
  Tab(label: label, active: False, disabled: False, attrs: [])
}

/// Marks the tab as active — adds `tab-active`.
pub fn tab_active(t: Tab(msg)) -> Tab(msg) {
  Tab(..t, active: True)
}

/// Marks the tab as disabled — adds `tab-disabled`.
pub fn tab_disabled(t: Tab(msg)) -> Tab(msg) {
  Tab(..t, disabled: True)
}

/// Merges additional Lustre attributes onto the `<a>` element.
pub fn tab_attrs(t: Tab(msg), a: List(Attribute(msg))) -> Tab(msg) {
  Tab(..t, attrs: a)
}

/// Converts a `Tab` builder into a `<a role="tab" class="tab …">` element.
pub fn tab_build(t: Tab(msg)) -> Element(msg) {
  let class =
    [
      Some("tab"),
      case t.active {
        True -> Some("tab-active")
        False -> None
      },
      case t.disabled {
        True -> Some("tab-disabled")
        False -> None
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.a(
    [attribute.role("tab"), attribute.class(class), ..t.attrs],
    [html.text(t.label)],
  )
}

// ---------------------------------------------------------------------------
// Radio tab item (with optional content)
// ---------------------------------------------------------------------------

/// Represents a single radio tab + optional content div pair.
pub opaque type RadioItem(msg) {
  RadioItem(
    label: String,
    checked: Bool,
    content: List(Element(msg)),
    content_attrs: List(Attribute(msg)),
    tab_attrs: List(Attribute(msg)),
  )
}

/// Creates a radio tab item.
///
/// - `label` — shown as the `aria-label` on the radio input.
/// - `content` — children for the `<div class="tab-content">` that follows.
///   Pass `[]` for tab-bar-only use.
/// - `is_checked` — whether this tab starts selected.
pub fn radio_item(
  label: String,
  content: List(Element(msg)),
  is_checked: Bool,
) -> RadioItem(msg) {
  RadioItem(
    label: label,
    checked: is_checked,
    content: content,
    content_attrs: [],
    tab_attrs: [],
  )
}

/// Marks the radio item as checked.
pub fn radio_checked(r: RadioItem(msg)) -> RadioItem(msg) {
  RadioItem(..r, checked: True)
}

/// Merges additional Lustre attributes onto the `<input type="radio">`.
pub fn radio_tab_attrs(r: RadioItem(msg), a: List(Attribute(msg))) -> RadioItem(msg) {
  RadioItem(..r, tab_attrs: a)
}

/// Merges additional Lustre attributes onto the `<div class="tab-content">`.
pub fn radio_content_attrs(
  r: RadioItem(msg),
  a: List(Attribute(msg)),
) -> RadioItem(msg) {
  RadioItem(..r, content_attrs: a)
}

/// Converts a list of `RadioItem` values into the interleaved
/// `[input, content-div, input, content-div, …]` list expected by the
/// `<div class="tabs">` container. All inputs share `name`.
pub fn radio_items(
  name: String,
  items: List(RadioItem(msg)),
) -> List(Element(msg)) {
  list.flat_map(items, fn(r) {
    let input =
      html.input(list.flatten([
        [
          attribute.type_("radio"),
          attribute.name(name),
          attribute.class("tab"),
          attribute.attribute("aria-label", r.label),
        ],
        case r.checked {
          True -> [attribute.checked(True)]
          False -> []
        },
        r.tab_attrs,
      ]))

    case r.content {
      [] -> [input]
      _ -> [
        input,
        html.div(
          [attribute.class("tab-content"), ..r.content_attrs],
          r.content,
        ),
      ]
    }
  })
}

/// Like `radio_items/2` but wraps each input in a `<label class="tab">` so
/// you can add icons or rich content alongside the radio button.
///
/// `label_content_fn` receives the `RadioItem` and should return the
/// non-input children for the label (icons, text, etc.).
///
/// ```gleam
/// tabs.radio_label_items("tabs", items, fn(r) {
///   [icon(), html.text(r_label)]
/// })
/// ```
pub fn radio_label_items(
  name: String,
  items: List(RadioItem(msg)),
  label_content_fn: fn(String) -> List(Element(msg)),
) -> List(Element(msg)) {
  list.flat_map(items, fn(r) {
    let radio_input =
      html.input(list.flatten([
        [attribute.type_("radio"), attribute.name(name)],
        case r.checked {
          True -> [attribute.checked(True)]
          False -> []
        },
        r.tab_attrs,
      ]))

    let label_el =
      html.label(
        [attribute.class("tab")],
        [radio_input, ..label_content_fn(r.label)],
      )

    case r.content {
      [] -> [label_el]
      _ -> [
        label_el,
        html.div(
          [attribute.class("tab-content"), ..r.content_attrs],
          r.content,
        ),
      ]
    }
  })
}

// ---------------------------------------------------------------------------
// Tabs container
// ---------------------------------------------------------------------------

pub opaque type Tabs(msg) {
  Tabs(
    style: Option(String),
    placement: Option(String),
    size: Option(String),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

/// Creates a new `Tabs` builder with no style, size, or placement override.
pub fn new() -> Tabs(msg) {
  Tabs(style: None, placement: None, size: None, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Styles
// ---------------------------------------------------------------------------

/// Border style — `tabs-border`.
pub fn border(t: Tabs(msg)) -> Tabs(msg) {
  Tabs(..t, style: Some("tabs-border"))
}

/// Lift style — `tabs-lift`.
pub fn lift(t: Tabs(msg)) -> Tabs(msg) {
  Tabs(..t, style: Some("tabs-lift"))
}

/// Box style — `tabs-box`.
pub fn box(t: Tabs(msg)) -> Tabs(msg) {
  Tabs(..t, style: Some("tabs-box"))
}

// ---------------------------------------------------------------------------
// Placement
// ---------------------------------------------------------------------------

/// Tab buttons on top of content (default) — `tabs-top`.
pub fn top(t: Tabs(msg)) -> Tabs(msg) {
  Tabs(..t, placement: Some("tabs-top"))
}

/// Tab buttons below content — `tabs-bottom`.
pub fn bottom(t: Tabs(msg)) -> Tabs(msg) {
  Tabs(..t, placement: Some("tabs-bottom"))
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Extra small tabs — `tabs-xs`.
pub fn xs(t: Tabs(msg)) -> Tabs(msg) {
  Tabs(..t, size: Some("tabs-xs"))
}

/// Small tabs — `tabs-sm`.
pub fn sm(t: Tabs(msg)) -> Tabs(msg) {
  Tabs(..t, size: Some("tabs-sm"))
}

/// Medium tabs — `tabs-md` (default).
pub fn md(t: Tabs(msg)) -> Tabs(msg) {
  Tabs(..t, size: Some("tabs-md"))
}

/// Large tabs — `tabs-lg`.
pub fn lg(t: Tabs(msg)) -> Tabs(msg) {
  Tabs(..t, size: Some("tabs-lg"))
}

/// Extra large tabs — `tabs-xl`.
pub fn xl(t: Tabs(msg)) -> Tabs(msg) {
  Tabs(..t, size: Some("tabs-xl"))
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer container.
pub fn attrs(t: Tabs(msg), a: List(Attribute(msg))) -> Tabs(msg) {
  Tabs(..t, attrs: a)
}

/// Sets the tab children. For link tabs use `tab_build/1`; for radio tabs
/// use `radio_items/2` to generate the interleaved list.
pub fn children(t: Tabs(msg), c: List(Element(msg))) -> Tabs(msg) {
  Tabs(..t, children: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Tabs` builder into a Lustre `Element(msg)`.
///
/// Link-style tabs render as `<div role="tablist" class="tabs …">`.
/// Radio-style tabs render as `<div class="tabs …">` (no `role` — the
/// radio inputs provide their own accessibility semantics).
pub fn build(t: Tabs(msg)) -> Element(msg) {
  let class =
    [Some("tabs"), t.style, t.placement, t.size]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.div([attribute.class(class), ..t.attrs], t.children)
}
