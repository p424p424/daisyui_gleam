/// Helpers for DaisyUI theme-controller inputs.
///
/// Adding `theme-controller` to a checked `<input type="checkbox">` or
/// `<input type="radio">` makes the page adopt the theme named in the
/// input's `value` attribute — **CSS only, no JS required**.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/theme_controller as tc
///
/// // Toggle that switches to "synthwave"
/// tc.toggle("synthwave", [])
///
/// // Radio group that selects among several themes
/// tc.radio("theme-group", "retro", [])
/// tc.radio("theme-group", "cyberpunk", [])
///
/// // Radio styled as a button
/// tc.radio_btn("theme-btns", "aqua", "Aqua", [])
/// ```
///
/// ## Reference
/// - [DaisyUI theme-controller](https://daisyui.com/components/theme-controller/)
import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Checkbox variants
// ---------------------------------------------------------------------------

/// `<input type="checkbox" value="{theme}" class="toggle theme-controller" …>`
///
/// Pass extra attributes (e.g. `attribute.checked(True)`) in `extra`.
pub fn toggle(theme: String, extra: List(Attribute(msg))) -> Element(msg) {
  html.input(list.flatten([
    [
      attribute.type_("checkbox"),
      attribute.value(theme),
      attribute.class("toggle theme-controller"),
    ],
    extra,
  ]))
}

/// `<input type="checkbox" value="{theme}" class="checkbox theme-controller" …>`
pub fn checkbox(theme: String, extra: List(Attribute(msg))) -> Element(msg) {
  html.input(list.flatten([
    [
      attribute.type_("checkbox"),
      attribute.value(theme),
      attribute.class("checkbox theme-controller"),
    ],
    extra,
  ]))
}

// ---------------------------------------------------------------------------
// Radio variants
// ---------------------------------------------------------------------------

/// `<input type="radio" name="{name}" value="{theme}" class="radio theme-controller" …>`
pub fn radio(
  name: String,
  theme: String,
  extra: List(Attribute(msg)),
) -> Element(msg) {
  html.input(list.flatten([
    [
      attribute.type_("radio"),
      attribute.name(name),
      attribute.value(theme),
      attribute.class("radio theme-controller"),
    ],
    extra,
  ]))
}

/// `<input type="radio" name="{name}" value="{theme}" class="btn theme-controller" aria-label="{label}" …>`
///
/// Renders the radio input as a button — used inside a `join` or `dropdown`.
pub fn radio_btn(
  name: String,
  theme: String,
  label: String,
  extra: List(Attribute(msg)),
) -> Element(msg) {
  html.input(list.flatten([
    [
      attribute.type_("radio"),
      attribute.name(name),
      attribute.value(theme),
      attribute.class("btn theme-controller"),
      attribute.attribute("aria-label", label),
    ],
    extra,
  ]))
}

/// `<input type="radio" name="{name}" value="{theme}" class="theme-controller w-full btn btn-sm btn-block btn-ghost justify-start" aria-label="{label}" …>`
///
/// Styled for use as a list item inside a dropdown menu.
pub fn radio_dropdown(
  name: String,
  theme: String,
  label: String,
  extra: List(Attribute(msg)),
) -> Element(msg) {
  html.input(list.flatten([
    [
      attribute.type_("radio"),
      attribute.name(name),
      attribute.value(theme),
      attribute.class(
        "theme-controller w-full btn btn-sm btn-block btn-ghost justify-start",
      ),
      attribute.attribute("aria-label", label),
    ],
    extra,
  ]))
}

// ---------------------------------------------------------------------------
// Swap helper
// ---------------------------------------------------------------------------

/// Returns a hidden `<input type="checkbox" class="theme-controller" value="{theme}">`.
///
/// Embed this inside a `<label class="swap …">` to make the swap also act
/// as a theme toggle:
/// ```gleam
/// html.label([attribute.class("swap swap-rotate")], [
///   tc.swap_checkbox("synthwave", []),
///   off_icon,
///   on_icon,
/// ])
/// ```
pub fn swap_checkbox(theme: String, extra: List(Attribute(msg))) -> Element(msg) {
  html.input(list.flatten([
    [
      attribute.type_("checkbox"),
      attribute.class("theme-controller"),
      attribute.value(theme),
    ],
    extra,
  ]))
}
