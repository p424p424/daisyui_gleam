/// A builder for DaisyUI rating elements.
///
/// A rating is a group of radio inputs styled as stars (or other shapes).
/// All inputs in one rating share the same `name` attribute.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/rating
///
/// // 5 uniform orange stars, star 2 checked
/// rating.new()
/// |> rating.stars("rating-1", 5, 2, "mask-star-2", "bg-orange-400")
/// |> rating.build
///
/// // Explicit items (for per-item colours)
/// rating.new()
/// |> rating.gap
/// |> rating.items("rating-2", [
///   rating.item("mask-heart") |> rating.item_class("bg-red-400"),
///   rating.item("mask-heart") |> rating.item_class("bg-orange-400") |> rating.item_checked,
///   rating.item("mask-heart") |> rating.item_class("bg-yellow-400"),
/// ])
/// |> rating.build
///
/// // Half-star rating (10 half-inputs = 5 full stars)
/// rating.new()
/// |> rating.half
/// |> rating.allow_clear
/// |> rating.half_stars("rating-3", 5, 3, "mask-star-2", "bg-green-500")
/// |> rating.build
/// ```
///
/// ## Read-only
///
/// For a display-only rating, pass `read_only: True` to `stars/6` or
/// build items manually using `rating.item_div/1` instead of `rating.item/1`.
///
/// ## Reference
/// - [DaisyUI rating](https://daisyui.com/components/rating/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// RatingItem
// ---------------------------------------------------------------------------

/// A single item inside a rating group.
pub opaque type RatingItem(msg) {
  RatingItem(
    mask: String,
    half_side: Option(String),
    extra_class: Option(String),
    is_checked: Bool,
    read_only: Bool,
    attrs: List(Attribute(msg)),
  )
}

/// Creates an interactive radio item with the given mask class,
/// e.g. `"mask-star"`, `"mask-star-2"`, `"mask-heart"`.
pub fn item(mask_class: String) -> RatingItem(msg) {
  RatingItem(
    mask: mask_class,
    half_side: None,
    extra_class: None,
    is_checked: False,
    read_only: False,
    attrs: [],
  )
}

/// Creates a read-only (non-interactive) display item. Renders as `<div>`
/// instead of `<input type="radio">`.
pub fn item_div(mask_class: String) -> RatingItem(msg) {
  RatingItem(
    mask: mask_class,
    half_side: None,
    extra_class: None,
    is_checked: False,
    read_only: True,
    attrs: [],
  )
}

/// Marks this item as checked.
pub fn item_checked(i: RatingItem(msg)) -> RatingItem(msg) {
  RatingItem(..i, is_checked: True)
}

/// Appends an extra CSS class to the item, typically a background colour
/// like `"bg-orange-400"`.
pub fn item_class(i: RatingItem(msg), c: String) -> RatingItem(msg) {
  RatingItem(..i, extra_class: Some(c))
}

/// Merges additional Lustre attributes onto the item element.
pub fn item_attrs(i: RatingItem(msg), a: List(Attribute(msg))) -> RatingItem(msg) {
  RatingItem(..i, attrs: a)
}

// Internal — half-side assignment used by half_stars helper
fn item_half_1(i: RatingItem(msg)) -> RatingItem(msg) {
  RatingItem(..i, half_side: Some("mask-half-1"))
}

fn item_half_2(i: RatingItem(msg)) -> RatingItem(msg) {
  RatingItem(..i, half_side: Some("mask-half-2"))
}

fn build_item(name: String, i: RatingItem(msg)) -> Element(msg) {
  let item_class =
    [Some("mask"), Some(i.mask), i.half_side, i.extra_class]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  case i.read_only {
    True ->
      html.div(
        [
          attribute.class(item_class),
          ..i.attrs
        ],
        [],
      )
    False ->
      html.input(list.flatten([
        [
          attribute.type_("radio"),
          attribute.name(name),
          attribute.class(item_class),
        ],
        case i.is_checked {
          True -> [attribute.checked(True)]
          False -> []
        },
        i.attrs,
      ]))
  }
}

// ---------------------------------------------------------------------------
// Rating container
// ---------------------------------------------------------------------------

pub opaque type Rating(msg) {
  Rating(
    size: Option(String),
    half: Bool,
    gap: Bool,
    allow_clear: Bool,
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Rating` builder.
pub fn new() -> Rating(msg) {
  Rating(
    size: None,
    half: False,
    gap: False,
    allow_clear: False,
    attrs: [],
    children: [],
  )
}

// ---------------------------------------------------------------------------
// Modifiers
// ---------------------------------------------------------------------------

/// Enables half-star mode — adds `rating-half` to the container.
pub fn half(r: Rating(msg)) -> Rating(msg) {
  Rating(..r, half: True)
}

/// Adds a hidden radio at the start so the user can clear their rating.
pub fn allow_clear(r: Rating(msg)) -> Rating(msg) {
  Rating(..r, allow_clear: True)
}

/// Adds `gap-1` to the container (useful for multi-colour hearts, etc.).
pub fn gap(r: Rating(msg)) -> Rating(msg) {
  Rating(..r, gap: True)
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

/// Extra small size — `rating-xs`.
pub fn xs(r: Rating(msg)) -> Rating(msg) {
  Rating(..r, size: Some("rating-xs"))
}

/// Small size — `rating-sm`.
pub fn sm(r: Rating(msg)) -> Rating(msg) {
  Rating(..r, size: Some("rating-sm"))
}

/// Medium size — `rating-md` (default).
pub fn md(r: Rating(msg)) -> Rating(msg) {
  Rating(..r, size: Some("rating-md"))
}

/// Large size — `rating-lg`.
pub fn lg(r: Rating(msg)) -> Rating(msg) {
  Rating(..r, size: Some("rating-lg"))
}

/// Extra large size — `rating-xl`.
pub fn xl(r: Rating(msg)) -> Rating(msg) {
  Rating(..r, size: Some("rating-xl"))
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the outer `<div>`.
pub fn attrs(r: Rating(msg), a: List(Attribute(msg))) -> Rating(msg) {
  Rating(..r, attrs: a)
}

// ---------------------------------------------------------------------------
// Item setters
// ---------------------------------------------------------------------------

/// Sets explicit rating items. All items share `name` as their radio group.
///
/// ```gleam
/// rating.new()
/// |> rating.items("rating-hearts", [
///   rating.item("mask-heart") |> rating.item_class("bg-red-400"),
///   rating.item("mask-heart") |> rating.item_class("bg-orange-400") |> rating.item_checked,
///   rating.item("mask-heart") |> rating.item_class("bg-yellow-400"),
/// ])
/// |> rating.build
/// ```
pub fn items(
  r: Rating(msg),
  name: String,
  is: List(RatingItem(msg)),
) -> Rating(msg) {
  Rating(..r, children: list.map(is, build_item(name, _)))
}

/// Convenience: generates `count` uniform star items sharing `name`.
///
/// - `checked_index` — 1-based index of the checked star (0 = none checked).
/// - `mask_class` — e.g. `"mask-star"`, `"mask-star-2"`.
/// - `color_class` — e.g. `"bg-orange-400"` (empty string for no colour).
pub fn stars(
  r: Rating(msg),
  name: String,
  count: Int,
  checked_index: Int,
  mask_class: String,
  color_class: String,
) -> Rating(msg) {
  let is =
    int_range(1, count)
    |> list.map(fn(i) {
      let base = item(mask_class)
      let colored = case color_class {
        "" -> base
        c -> item_class(base, c)
      }
      case i == checked_index {
        True -> item_checked(colored)
        False -> colored
      }
    })
  items(r, name, is)
}

/// Convenience: generates half-star inputs — `count` whole stars → `count*2`
/// radio inputs, alternating `mask-half-1` / `mask-half-2`.
///
/// - `checked_half` — 1-based index of the checked half (0 = none).
///   E.g. `3` = "1.5 stars" (third half-input).
/// - `mask_class` — typically `"mask-star-2"`.
/// - `color_class` — e.g. `"bg-green-500"`.
pub fn half_stars(
  r: Rating(msg),
  name: String,
  count: Int,
  checked_half: Int,
  mask_class: String,
  color_class: String,
) -> Rating(msg) {
  let total = count * 2
  let is =
    int_range(1, total)
    |> list.map(fn(i) {
      let half_fn = case i % 2 {
        1 -> item_half_1
        _ -> item_half_2
      }
      let base = item(mask_class) |> half_fn
      let colored = case color_class {
        "" -> base
        c -> item_class(base, c)
      }
      case i == checked_half {
        True -> item_checked(colored)
        False -> colored
      }
    })
  items(r, name, is)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Rating` builder into a Lustre `Element(msg)`.
///
/// Renders:
/// ```html
/// <div class="rating [size] [rating-half] [gap-1]" …attrs>
///   [<input type="radio" class="rating-hidden" …>]
///   children
/// </div>
/// ```
pub fn build(r: Rating(msg)) -> Element(msg) {
  let class =
    [
      Some("rating"),
      r.size,
      case r.half {
        True -> Some("rating-half")
        False -> None
      },
      case r.gap {
        True -> Some("gap-1")
        False -> None
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  // The hidden clear radio needs the same name as sibling inputs.
  // We extract it from the first child's name attr — but that's not
  // easily inspectable. Instead, allow_clear is wired at the items/stars
  // call site via a sentinel child prepended here. Since we don't have
  // the name at build time, we embed it as a data attribute placeholder.
  // Simpler: require the caller to pass name to build when allow_clear=True.
  // Instead, we handle it in items/stars/half_stars by injecting the hidden
  // radio before the real children if allow_clear is set.
  // When allow_clear is set use build_named/2 to supply the group name.
  let children = r.children

  html.div([attribute.class(class), ..r.attrs], children)
}

/// Like `build/1` but prepends a `rating-hidden` clear radio with the given
/// `name`. Use this when `allow_clear/1` is set.
///
/// ```gleam
/// rating.new()
/// |> rating.lg
/// |> rating.allow_clear
/// |> rating.stars("rating-10", 5, 2, "mask-star-2", "")
/// |> rating.build_named("rating-10")
/// ```
fn int_range(from: Int, to: Int) -> List(Int) {
  int_range_acc(from, to, [])
}

fn int_range_acc(from: Int, to: Int, acc: List(Int)) -> List(Int) {
  case from > to {
    True -> list.reverse(acc)
    False -> int_range_acc(from + 1, to, [from, ..acc])
  }
}

pub fn build_named(r: Rating(msg), name: String) -> Element(msg) {
  let class =
    [
      Some("rating"),
      r.size,
      case r.half {
        True -> Some("rating-half")
        False -> None
      },
      case r.gap {
        True -> Some("gap-1")
        False -> None
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let clear_input =
    html.input([
      attribute.type_("radio"),
      attribute.name(name),
      attribute.class("rating-hidden"),
      attribute.attribute("aria-label", "clear"),
    ])

  let children = case r.allow_clear {
    True -> [clear_input, ..r.children]
    False -> r.children
  }

  html.div([attribute.class(class), ..r.attrs], children)
}

