/// Helpers for DaisyUI-styled calendar and date-picker integrations.
///
/// Unlike the other modules in this library, `calendar` does not provide
/// a self-contained builder. DaisyUI's calendar support is a set of CSS
/// class hooks that style **external libraries** — the rendering itself is
/// owned by those libraries. This module gives you:
///
/// - Lustre element helpers for the **Cally** web component.
/// - A Lustre element helper for a **Pikaday** input field.
/// - Class name constants for **React Day Picker** and direct use.
///
/// > **External library requirements**
/// >
/// > Each calendar flavour requires setup outside of Gleam/Lustre:
/// >
/// > | Library          | Runtime            | Lustre-compatible? |
/// > |------------------|--------------------|--------------------|
/// > | Cally            | Web component (JS) | Yes                |
/// > | Pikaday          | JS initialisation  | Yes (via effects)  |
/// > | React Day Picker | React only         | No                 |
/// >
/// > You do **not** need to import the CSS files for these libraries —
/// > DaisyUI styles them automatically through the class hooks.
///
/// ## Cally
///
/// Cally is a web component that works everywhere, including Lustre.
/// Register the component once with a `<script>` tag or JS import, then
/// use `cally/2`, `cally_month/0`, and the navigation arrow helpers to
/// build the element tree.
///
/// ```gleam
/// import daisyui/calendar
/// import lustre/attribute
///
/// // A standalone calendar widget
/// calendar.cally(
///   attrs: [
///     attribute.class("bg-base-100 border border-base-300 shadow-lg rounded-box"),
///   ],
///   children: [
///     calendar.prev_arrow(),
///     calendar.next_arrow(),
///     calendar.cally_month(),
///   ],
/// )
/// ```
///
/// Script tag to register the Cally web component (add to your HTML):
/// ```html
/// <script type="module" src="https://unpkg.com/cally"></script>
/// ```
/// Or install as a JS dependency:
/// ```
/// npm i cally
/// ```
/// then in your JS entry point:
/// ```js
/// import "cally";
/// ```
///
/// ## Pikaday
///
/// Pikaday is a JS datepicker that attaches to a text input. Create the
/// input with `pikaday_input/1`, then initialise the picker in a Lustre
/// effect using the element's `id`.
///
/// ```gleam
/// import daisyui/calendar
/// import lustre/attribute
///
/// calendar.pikaday_input([attribute.id("my-datepicker")])
/// ```
///
/// Install Pikaday as a JS dependency:
/// ```
/// npm i pikaday
/// ```
/// Then initialise it in a Lustre effect:
/// ```js
/// import Pikaday from "pikaday";
/// const picker = new Pikaday({ field: document.getElementById("my-datepicker") });
/// ```
///
/// ## React Day Picker
///
/// React Day Picker is React-only and cannot be used from Lustre. If you
/// are working in a React codebase alongside Lustre, apply the
/// `react_day_picker_class` constant as the component's `className` prop:
///
/// ```tsx
/// import { DayPicker } from "react-day-picker";
/// <DayPicker className="react-day-picker" mode="single" ... />
/// ```
///
/// Install React Day Picker:
/// ```
/// npm i react-day-picker
/// ```
///
/// ## Reference
/// - [DaisyUI calendar](https://daisyui.com/components/calendar/)
/// - [Cally docs](https://wicky.nillia.ms/cally/)
/// - [Pikaday docs](https://pikaday.com/)
/// - [React Day Picker docs](https://react-day-picker.js.org/)
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg

// ---------------------------------------------------------------------------
// Class name constants
// ---------------------------------------------------------------------------

/// The DaisyUI class that styles a Cally `<calendar-date>` element.
///
/// Apply this to the `<calendar-date>` root element to opt in to DaisyUI
/// styling. The builder helpers in this module apply it automatically;
/// use this constant only when building the element tree by hand.
///
/// ```gleam
/// element.element("calendar-date", [attribute.class(calendar.cally_class)], [...])
/// ```
pub const cally_class: String = "cally"

/// The DaisyUI class that styles a Pikaday input field.
///
/// Apply this alongside the standard `input` class to the `<input>` that
/// Pikaday will attach to:
///
/// ```html
/// <input type="text" class="input pika-single" />
/// ```
///
/// The `pikaday_input/1` helper applies both classes automatically.
pub const pikaday_class: String = "pika-single"

/// The DaisyUI class that styles a React Day Picker `<DayPicker>` component.
///
/// Pass this as the `className` prop in React:
///
/// ```tsx
/// <DayPicker className="react-day-picker" mode="single" ... />
/// ```
///
/// > **Note:** React Day Picker is React-only and cannot be used from
/// > Lustre. This constant is provided so that mixed codebases can
/// > reference the class name from a shared location.
pub const react_day_picker_class: String = "react-day-picker"

// ---------------------------------------------------------------------------
// Cally helpers
// ---------------------------------------------------------------------------

/// Creates a `<calendar-date class="cally">` element.
///
/// This is the root element of a Cally calendar. Pass additional DaisyUI
/// or Tailwind classes via `attrs` (e.g. background, border, shadow) and
/// supply the navigation arrows and a `cally_month/0` as `children`.
///
/// The Cally web component must be registered before this element renders
/// — see the module-level documentation for setup instructions.
///
/// ```gleam
/// import lustre/attribute
///
/// calendar.cally(
///   attrs: [
///     attribute.class("bg-base-100 border border-base-300 shadow-lg rounded-box"),
///   ],
///   children: [
///     calendar.prev_arrow(),
///     calendar.next_arrow(),
///     calendar.cally_month(),
///   ],
/// )
/// ```
///
/// ## Reference
/// - [Cally docs](https://wicky.nillia.ms/cally/)
/// - [DaisyUI calendar](https://daisyui.com/components/calendar/)
pub fn cally(
  attrs a: List(Attribute(msg)),
  children ch: List(Element(msg)),
) -> Element(msg) {
  element.element("calendar-date", [attribute.class(cally_class), ..a], ch)
}

/// Creates a `<calendar-month></calendar-month>` element.
///
/// Place this inside a `cally/2` element as the calendar's grid. Cally
/// renders the month view inside this custom element.
///
/// ```gleam
/// calendar.cally(
///   attrs: [],
///   children: [
///     calendar.prev_arrow(),
///     calendar.next_arrow(),
///     calendar.cally_month(),
///   ],
/// )
/// ```
///
/// ## Reference
/// - [Cally docs](https://wicky.nillia.ms/cally/)
pub fn cally_month() -> Element(msg) {
  element.element("calendar-month", [], [])
}

/// The default previous-month navigation arrow from DaisyUI's Cally example.
///
/// Renders an SVG chevron pointing left with `slot="previous"` set so that
/// Cally places it in the correct slot. The icon is sized `size-4` and
/// uses `fill-current` to inherit the surrounding text colour.
///
/// Replace with any element that carries `attribute.attribute("slot", "previous")`
/// if you need a custom icon.
///
/// ## Reference
/// - [Cally slot docs](https://wicky.nillia.ms/cally/)
pub fn prev_arrow() -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("aria-label", "Previous"),
      attribute.attribute("slot", "previous"),
      attribute.class("fill-current size-4"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.path([
        attribute.attribute("fill", "currentColor"),
        attribute.attribute("d", "M15.75 19.5 8.25 12l7.5-7.5"),
      ]),
    ],
  )
}

/// The default next-month navigation arrow from DaisyUI's Cally example.
///
/// Renders an SVG chevron pointing right with `slot="next"` set so that
/// Cally places it in the correct slot. The icon is sized `size-4` and
/// uses `fill-current` to inherit the surrounding text colour.
///
/// Replace with any element that carries `attribute.attribute("slot", "next")`
/// if you need a custom icon.
///
/// ## Reference
/// - [Cally slot docs](https://wicky.nillia.ms/cally/)
pub fn next_arrow() -> Element(msg) {
  svg.svg(
    [
      attribute.attribute("aria-label", "Next"),
      attribute.attribute("slot", "next"),
      attribute.class("fill-current size-4"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.path([
        attribute.attribute("d", "m8.25 4.5 7.5 7.5-7.5 7.5"),
      ]),
    ],
  )
}

// ---------------------------------------------------------------------------
// Pikaday helpers
// ---------------------------------------------------------------------------

/// Creates an `<input type="text" class="input pika-single">` element for
/// use with the Pikaday date picker library.
///
/// Pass an `id` attribute so you can target the element from the Pikaday
/// JS initialiser. Any additional attributes (placeholder, value, event
/// handlers) are appended after the built-in classes.
///
/// Pikaday must be initialised in JavaScript after the element is mounted.
/// In Lustre, use an effect keyed to the element's `id`:
///
/// ```gleam
/// import lustre/attribute
///
/// calendar.pikaday_input([
///   attribute.id("booking-date"),
///   attribute.attribute("placeholder", "Pick a date"),
/// ])
/// ```
///
/// JS initialisation (run once the element is in the DOM):
/// ```js
/// import Pikaday from "pikaday";
/// const picker = new Pikaday({ field: document.getElementById("booking-date") });
/// ```
///
/// ## Reference
/// - [Pikaday docs](https://pikaday.com/)
/// - [DaisyUI calendar](https://daisyui.com/components/calendar/)
pub fn pikaday_input(attrs a: List(Attribute(msg))) -> Element(msg) {
  html.input([
    attribute.type_("text"),
    attribute.class("input " <> pikaday_class),
    ..a
  ])
}
