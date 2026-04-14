/// A builder for DaisyUI modal elements.
///
/// Modals can be opened three ways:
///
/// **Method 1 — `<dialog>` element (recommended)**
/// Use `dialog_new/1` to get a `<dialog>` element. Open with
/// `document.getElementById("id").showModal()` and close with `.close()` or
/// the Esc key. Add `backdrop_form/1` inside the modal to close on
/// outside-click.
///
/// **Method 2 — hidden checkbox**
/// Use `new/0` to get a `<div role="dialog">`. Pair with a
/// `<input type="checkbox" class="modal-toggle" id="…">` in the DOM and
/// `<label for="…">` triggers.
///
/// **Method 3 — anchor link**
/// Use `new/0` with an `id` attribute. Open via `<a href="#id">`.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/modal
/// import lustre/attribute
/// import lustre/element/html
///
/// // Dialog method (recommended)
/// modal.dialog_new("my_modal")
/// |> modal.children([
///   modal.box([], [
///     html.h3([attribute.class("text-lg font-bold")], [html.text("Hello!")]),
///     html.p([attribute.class("py-4")], [html.text("Press ESC to close.")]),
///     modal.action([
///       html.form([attribute.method("dialog")], [
///         html.button([attribute.class("btn")], [html.text("Close")]),
///       ]),
///     ]),
///   ]),
///   modal.backdrop_form([]),
/// ])
/// |> modal.build
/// ```
///
/// ## Reference
/// - [DaisyUI modal](https://daisyui.com/components/modal/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

pub type Placement {
  Top
  Middle
  Bottom
  Start
  End
}

pub opaque type Modal(msg) {
  Modal(
    variant: ModalVariant,
    placement: Option(Placement),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

type ModalVariant {
  DialogModal(id: String)
  DivModal
}

// ---------------------------------------------------------------------------
// Constructors
// ---------------------------------------------------------------------------

/// Creates a modal backed by a `<dialog id="…">` element (recommended).
///
/// Open it with JS: `document.getElementById(id).showModal()`.
/// Close with `id.close()` or the Esc key.
pub fn dialog_new(id: String) -> Modal(msg) {
  Modal(variant: DialogModal(id), placement: None, attrs: [], children: [])
}

/// Creates a modal backed by a `<div role="dialog">` element.
///
/// Used with the checkbox or anchor-link open methods.
pub fn new() -> Modal(msg) {
  Modal(variant: DivModal, placement: None, attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Placement
// ---------------------------------------------------------------------------

/// Moves the modal to the top — `modal-top`.
pub fn top(m: Modal(msg)) -> Modal(msg) {
  Modal(..m, placement: Some(Top))
}

/// Moves the modal to the middle — `modal-middle` (default).
pub fn middle(m: Modal(msg)) -> Modal(msg) {
  Modal(..m, placement: Some(Middle))
}

/// Moves the modal to the bottom — `modal-bottom`.
pub fn bottom(m: Modal(msg)) -> Modal(msg) {
  Modal(..m, placement: Some(Bottom))
}

/// Moves the modal to the start horizontally — `modal-start`.
pub fn start(m: Modal(msg)) -> Modal(msg) {
  Modal(..m, placement: Some(Start))
}

/// Moves the modal to the end horizontally — `modal-end`.
pub fn end(m: Modal(msg)) -> Modal(msg) {
  Modal(..m, placement: Some(End))
}

// ---------------------------------------------------------------------------
// Attrs / children
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer modal element.
pub fn attrs(m: Modal(msg), a: List(Attribute(msg))) -> Modal(msg) {
  Modal(..m, attrs: a)
}

/// Sets the children of the modal (typically `modal.box(…)` and optionally
/// `modal.backdrop_form(…)` or `modal.backdrop_label(…)`).
pub fn children(m: Modal(msg), c: List(Element(msg))) -> Modal(msg) {
  Modal(..m, children: c)
}

// ---------------------------------------------------------------------------
// Part helpers
// ---------------------------------------------------------------------------

/// Renders `<div class="modal-box" …attrs>children</div>`.
///
/// Place this as the primary child of the modal. Add `w-*` / `max-w-*`
/// utilities in `attrs` to customise the width.
pub fn box(
  a: List(Attribute(msg)),
  c: List(Element(msg)),
) -> Element(msg) {
  html.div([attribute.class("modal-box"), ..a], c)
}

/// Renders `<div class="modal-action">children</div>`.
///
/// Wrap action buttons (e.g. a `<form method="dialog">` with a Close button)
/// inside this helper.
pub fn action(c: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("modal-action")], c)
}

/// Renders `<form method="dialog" class="modal-backdrop">children</form>`.
///
/// Place this as a sibling of `modal.box` inside a `<dialog>` modal to
/// allow closing by clicking outside the box.
///
/// ```gleam
/// modal.backdrop_form([html.button([], [html.text("close")])])
/// ```
pub fn backdrop_form(c: List(Element(msg))) -> Element(msg) {
  html.form(
    [attribute.method("dialog"), attribute.class("modal-backdrop")],
    c,
  )
}

/// Renders `<label class="modal-backdrop" for="id">Close</label>`.
///
/// Use this inside a checkbox-controlled modal (`modal.new()`) to allow
/// closing by clicking outside the box.
pub fn backdrop_label(for_id: String) -> Element(msg) {
  html.label(
    [attribute.class("modal-backdrop"), attribute.for(for_id)],
    [html.text("Close")],
  )
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Modal` builder into a Lustre `Element(msg)`.
///
/// - `dialog_new/1` renders `<dialog id="…" class="modal …" …attrs>children</dialog>`
/// - `new/0` renders `<div class="modal …" role="dialog" …attrs>children</div>`
pub fn build(m: Modal(msg)) -> Element(msg) {
  let placement_class = case m.placement {
    Some(Top) -> Some("modal-top")
    Some(Middle) -> Some("modal-middle")
    Some(Bottom) -> Some("modal-bottom")
    Some(Start) -> Some("modal-start")
    Some(End) -> Some("modal-end")
    None -> None
  }
  let class =
    [Some("modal"), placement_class]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  case m.variant {
    DialogModal(id) ->
      html.dialog(
        [attribute.class(class), attribute.id(id), ..m.attrs],
        m.children,
      )
    DivModal ->
      html.div(
        [attribute.class(class), attribute.role("dialog"), ..m.attrs],
        m.children,
      )
  }
}
