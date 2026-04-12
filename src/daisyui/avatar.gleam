/// A builder for DaisyUI avatar elements.
///
/// Avatars show a thumbnail representation of an individual or business.
/// The component is a two-layer structure: an outer `<div class="avatar">`
/// that carries status and placeholder modifiers, and an inner `<div>` that
/// sets the size and shape and holds the actual content — typically an
/// `<img>` or a text node for letter placeholders.
///
/// Use `group/2` to render several avatars side-by-side in an
/// `avatar-group` container.
///
/// > **New to Lustre?** Lustre is a Gleam web framework that models your UI
/// > as a tree of `Element(msg)` values. You build elements using
/// > constructor functions (like `html.div`) and pass them `Attribute` and
/// > child `Element` lists. This module wraps that pattern in a builder so
/// > you can configure an avatar piece-by-piece before calling `build/1`
/// > to turn it into an element.
/// > → [Lustre docs](https://hexdocs.pm/lustre/)
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/avatar
/// import lustre/element/html
///
/// // A circular avatar with an image
/// avatar.new()
/// |> avatar.w24
/// |> avatar.circle
/// |> avatar.children([html.img([attribute.src("/profile.webp")])])
/// |> avatar.build
///
/// // An online avatar with a rounded square
/// avatar.new()
/// |> avatar.online
/// |> avatar.w16
/// |> avatar.rounded
/// |> avatar.children([html.img([attribute.src("/profile.webp")])])
/// |> avatar.build
///
/// // A placeholder avatar showing initials
/// avatar.new()
/// |> avatar.placeholder
/// |> avatar.w12
/// |> avatar.circle
/// |> avatar.children([html.span([], [html.text("JD")])])
/// |> avatar.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI avatar](https://daisyui.com/components/avatar/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// The online/offline presence indicator shown as a coloured dot.
///
/// - `Online` — a green dot. Maps to `avatar-online`.
/// - `Offline` — a grey dot. Maps to `avatar-offline`.
///
/// Omit both (the default) to show no presence indicator.
pub type AvatarStatus {
  /// Shows a green presence dot. Maps to `avatar-online`.
  Online
  /// Shows a grey presence dot. Maps to `avatar-offline`.
  Offline
}

/// An opaque builder that accumulates avatar configuration before being
/// converted to a Lustre element by `build/1`.
///
/// The type parameter `msg` is Lustre's message type — it threads through
/// so that any `Attribute(msg)` values you attach (event handlers, etc.)
/// remain type-safe with the rest of your application.
///
/// > **Opaque type** means you cannot construct or pattern-match an `Avatar`
/// > directly — use `new/0` to create one and the setter functions to
/// > configure it. This keeps the internal representation free to change.
///
/// ## Reference
/// - [Lustre `Element` type](https://hexdocs.pm/lustre/)
pub opaque type Avatar(msg) {
  Avatar(
    status: Option(AvatarStatus),
    placeholder: Bool,
    size: Option(String),
    shape: Option(String),
    attrs: List(Attribute(msg)),
    inner_attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Avatar` builder with no classes applied.
///
/// Defaults to no status indicator, no placeholder modifier, no size, no
/// shape, empty attributes, and no children. Chain setter functions to
/// configure it, then call `build/1` to produce a Lustre element.
///
/// ```gleam
/// avatar.new()
/// |> avatar.w24
/// |> avatar.circle
/// |> avatar.children([html.img([attribute.src("/me.webp")])])
/// |> avatar.build
/// ```
pub fn new() -> Avatar(msg) {
  Avatar(
    status: None,
    placeholder: False,
    size: None,
    shape: None,
    attrs: [],
    inner_attrs: [],
    children: [],
  )
}

// ---------------------------------------------------------------------------
// Status
// ---------------------------------------------------------------------------

/// Shows a green dot indicating the user is online (`avatar-online`).
///
/// ## Reference
/// - [DaisyUI avatar](https://daisyui.com/components/avatar/)
pub fn online(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, status: Some(Online))
}

/// Shows a grey dot indicating the user is offline (`avatar-offline`).
///
/// ## Reference
/// - [DaisyUI avatar](https://daisyui.com/components/avatar/)
pub fn offline(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, status: Some(Offline))
}

// ---------------------------------------------------------------------------
// Placeholder
// ---------------------------------------------------------------------------

/// Applies the `avatar-placeholder` modifier.
///
/// Use when displaying initials or an icon instead of a photo. Typically
/// combined with a background colour class via `inner_attrs/2` and a
/// `<span>` child containing the letter(s).
///
/// ```gleam
/// avatar.new()
/// |> avatar.placeholder
/// |> avatar.w12
/// |> avatar.circle
/// |> avatar.inner_attrs([attribute.class("bg-neutral text-neutral-content")])
/// |> avatar.children([html.span([], [html.text("JD")])])
/// |> avatar.build
/// ```
///
/// ## Reference
/// - [DaisyUI avatar](https://daisyui.com/components/avatar/)
pub fn placeholder(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, placeholder: True)
}

// ---------------------------------------------------------------------------
// Size
// ---------------------------------------------------------------------------
// Sets the Tailwind width class on the inner sizing div. The inner div's
// width controls both the rendered size of the avatar and its aspect ratio
// (the height follows automatically via the img's intrinsic dimensions).
// Reference: https://tailwindcss.com/docs/width

/// Sets the inner div width to `w-8` — **2 rem / 32 px**.
///
/// Good for compact lists and tight UI chrome.
///
/// ## Reference
/// - [Tailwind width](https://tailwindcss.com/docs/width)
pub fn w8(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, size: Some("w-8"))
}

/// Sets the inner div width to `w-10` — **2.5 rem / 40 px**.
///
/// ## Reference
/// - [Tailwind width](https://tailwindcss.com/docs/width)
pub fn w10(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, size: Some("w-10"))
}

/// Sets the inner div width to `w-12` — **3 rem / 48 px**.
///
/// ## Reference
/// - [Tailwind width](https://tailwindcss.com/docs/width)
pub fn w12(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, size: Some("w-12"))
}

/// Sets the inner div width to `w-16` — **4 rem / 64 px**.
///
/// ## Reference
/// - [Tailwind width](https://tailwindcss.com/docs/width)
pub fn w16(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, size: Some("w-16"))
}

/// Sets the inner div width to `w-20` — **5 rem / 80 px**.
///
/// ## Reference
/// - [Tailwind width](https://tailwindcss.com/docs/width)
pub fn w20(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, size: Some("w-20"))
}

/// Sets the inner div width to `w-24` — **6 rem / 96 px**.
///
/// The size used in DaisyUI's own documentation examples.
///
/// ## Reference
/// - [Tailwind width](https://tailwindcss.com/docs/width)
pub fn w24(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, size: Some("w-24"))
}

/// Sets the inner div width to `w-32` — **8 rem / 128 px**.
///
/// ## Reference
/// - [Tailwind width](https://tailwindcss.com/docs/width)
pub fn w32(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, size: Some("w-32"))
}

// ---------------------------------------------------------------------------
// Shape
// ---------------------------------------------------------------------------

/// Applies `rounded` — slightly rounded corners on the inner div.
///
/// Gives the avatar a soft rectangular appearance. A good default when
/// the avatar represents a business, product, or non-person entity.
///
/// ## Reference
/// - [Tailwind border-radius](https://tailwindcss.com/docs/border-radius)
pub fn rounded(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, shape: Some("rounded"))
}

/// Applies `rounded-lg` — more pronounced rounded corners on the inner div.
///
/// ## Reference
/// - [Tailwind border-radius](https://tailwindcss.com/docs/border-radius)
pub fn rounded_lg(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, shape: Some("rounded-lg"))
}

/// Applies `rounded-xl` — heavily rounded corners on the inner div.
///
/// ## Reference
/// - [Tailwind border-radius](https://tailwindcss.com/docs/border-radius)
pub fn rounded_xl(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, shape: Some("rounded-xl"))
}

/// Applies `rounded-full` — a fully circular avatar.
///
/// The most common shape for person avatars and profile pictures.
///
/// ## Reference
/// - [Tailwind border-radius](https://tailwindcss.com/docs/border-radius)
pub fn circle(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, shape: Some("rounded-full"))
}

// ---------------------------------------------------------------------------
// Attrs / Children
// ---------------------------------------------------------------------------

/// Appends additional Lustre attributes to the outer `avatar` wrapper.
///
/// Multiple calls accumulate — later calls do not replace earlier ones.
/// Useful for IDs, ARIA attributes, or event handlers on the outer element.
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn attrs(a: Avatar(msg), extra: List(Attribute(msg))) -> Avatar(msg) {
  Avatar(..a, attrs: list.append(a.attrs, extra))
}

/// Appends additional Lustre attributes to the inner sizing div.
///
/// Multiple calls accumulate — later calls do not replace earlier ones.
/// Useful for adding background and text colour classes when using
/// `placeholder/1`.
///
/// ```gleam
/// import lustre/attribute
///
/// avatar.new()
/// |> avatar.placeholder
/// |> avatar.w16
/// |> avatar.circle
/// |> avatar.inner_attrs([attribute.class("bg-primary text-primary-content")])
/// |> avatar.children([html.span([], [html.text("AB")])])
/// |> avatar.build
/// ```
///
/// ## Reference
/// - [Lustre attribute module](https://hexdocs.pm/lustre/)
pub fn inner_attrs(a: Avatar(msg), extra: List(Attribute(msg))) -> Avatar(msg) {
  Avatar(..a, inner_attrs: list.append(a.inner_attrs, extra))
}

/// Sets the children of the inner sizing div.
///
/// Replaces any previously set children. Pass an `<img>` element for a
/// photo avatar or a `<span>` with text for a placeholder avatar.
///
/// ```gleam
/// avatar.new()
/// |> avatar.w24
/// |> avatar.circle
/// |> avatar.children([
///   html.img([attribute.src("/profile.webp"), attribute.alt("Jane Doe")]),
/// ])
/// |> avatar.build
/// ```
pub fn children(a: Avatar(msg), ch: List(Element(msg))) -> Avatar(msg) {
  Avatar(..a, children: ch)
}

// ---------------------------------------------------------------------------
// Group
// ---------------------------------------------------------------------------

/// Wraps a list of avatar elements in an `avatar-group` container.
///
/// The group component stacks avatars with a negative horizontal offset so
/// they overlap. Pass extra Tailwind utilities via `attrs` to control the
/// overlap amount (e.g. `"-space-x-6"`).
///
/// ```gleam
/// avatar.group(
///   attrs: [attribute.class("-space-x-4")],
///   avatars: [
///     avatar.new() |> avatar.w10 |> avatar.circle |> avatar.children([...]) |> avatar.build,
///     avatar.new() |> avatar.w10 |> avatar.circle |> avatar.children([...]) |> avatar.build,
///   ],
/// )
/// ```
///
/// ## Reference
/// - [DaisyUI avatar group](https://daisyui.com/components/avatar/)
pub fn group(
  attrs a: List(Attribute(msg)),
  avatars av: List(Element(msg)),
) -> Element(msg) {
  html.div([attribute.class("avatar-group"), ..a], av)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Avatar` builder into a Lustre `Element(msg)`.
///
/// Assembles the outer `avatar` class string (including any status or
/// placeholder modifiers), then wraps the configured children in an inner
/// sizing div whose class string combines the size and shape values.
///
/// Always call this at the end of a builder chain — it is the only step
/// that produces an element you can use in a Lustre view.
///
/// ```gleam
/// // In your Lustre view function:
/// pub fn view(model: Model) -> Element(Msg) {
///   avatar.group(
///     attrs: [attribute.class("-space-x-6")],
///     avatars: list.map(model.users, fn(user) {
///       avatar.new()
///       |> avatar.w10
///       |> avatar.circle
///       |> avatar.children([
///         html.img([attribute.src(user.avatar_url), attribute.alt(user.name)]),
///       ])
///       |> avatar.build
///     }),
///   )
/// }
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI avatar](https://daisyui.com/components/avatar/)
pub fn build(a: Avatar(msg)) -> Element(msg) {
  let outer_class =
    [
      Some("avatar"),
      option.map(a.status, fn(s) {
        case s {
          Online -> "avatar-online"
          Offline -> "avatar-offline"
        }
      }),
      case a.placeholder {
        True -> Some("avatar-placeholder")
        False -> None
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let inner_class =
    [a.size, a.shape]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let inner_all_attrs = case inner_class {
    "" -> a.inner_attrs
    _ -> [attribute.class(inner_class), ..a.inner_attrs]
  }

  let inner_el = html.div(inner_all_attrs, a.children)

  html.div([attribute.class(outer_class), ..a.attrs], [inner_el])
}
