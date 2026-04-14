/// A builder for DaisyUI mask elements.
///
/// Mask crops the content of an element to a common shape using CSS
/// `clip-path` or `mask-image`. It is most commonly applied to `<img>`
/// elements but can be used on any block element.
///
/// A shape is required. Optionally add `half_1/1` or `half_2/1` to crop
/// only one half of the mask (useful for split-colour hearts, stars, etc.).
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/mask
/// import lustre/attribute
///
/// // Circle-masked image
/// mask.new(mask.Circle)
/// |> mask.attrs([attribute.src("/photo.webp"), attribute.alt("Profile")])
/// |> mask.build
///
/// // Heart, first half only
/// mask.new(mask.Heart)
/// |> mask.half_1
/// |> mask.attrs([attribute.src("/photo.webp"), attribute.alt("")])
/// |> mask.build
/// ```
///
/// ## Reference
/// - [DaisyUI mask](https://daisyui.com/components/mask/)
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// The clipping shape applied by the mask.
pub type MaskShape {
  Squircle
  Heart
  Hexagon
  Hexagon2
  Decagon
  Pentagon
  Diamond
  Square
  Circle
  Star
  Star2
  Triangle
  Triangle2
  Triangle3
  Triangle4
}

/// An opaque builder for a masked element.
pub opaque type Mask(msg) {
  Mask(
    shape: MaskShape,
    half: Option(String),
    attrs: List(Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `Mask` builder for the given shape.
///
/// ```gleam
/// mask.new(mask.Circle)
/// |> mask.attrs([attribute.src("/photo.webp"), attribute.alt("Photo")])
/// |> mask.build
/// ```
pub fn new(shape: MaskShape) -> Mask(msg) {
  Mask(shape: shape, half: None, attrs: [])
}

// ---------------------------------------------------------------------------
// Half modifiers
// ---------------------------------------------------------------------------

/// Crops only the **first half** of the mask — adds `mask-half-1`.
///
/// Useful for split-colour effects (e.g. a half-filled star rating).
pub fn half_1(m: Mask(msg)) -> Mask(msg) {
  Mask(..m, half: Some("mask-half-1"))
}

/// Crops only the **second half** of the mask — adds `mask-half-2`.
pub fn half_2(m: Mask(msg)) -> Mask(msg) {
  Mask(..m, half: Some("mask-half-2"))
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the element.
///
/// Use this for `src`, `alt`, `width`, `height`, and other attributes:
///
/// ```gleam
/// mask.new(mask.Heart)
/// |> mask.attrs([
///   attribute.src("/photo.webp"),
///   attribute.alt("Heart-shaped photo"),
///   attribute.class("w-24"),
/// ])
/// |> mask.build
/// ```
pub fn attrs(m: Mask(msg), a: List(Attribute(msg))) -> Mask(msg) {
  Mask(..m, attrs: a)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `Mask` builder into a Lustre `Element(msg)`.
///
/// Renders an `<img>` with the mask classes applied:
///
/// ```html
/// <img class="mask mask-circle [mask-half-1|mask-half-2]" …attrs />
/// ```
///
/// Always call this at the end of a builder chain.
pub fn build(m: Mask(msg)) -> Element(msg) {
  let shape_class = case m.shape {
    Squircle -> "mask-squircle"
    Heart -> "mask-heart"
    Hexagon -> "mask-hexagon"
    Hexagon2 -> "mask-hexagon-2"
    Decagon -> "mask-decagon"
    Pentagon -> "mask-pentagon"
    Diamond -> "mask-diamond"
    Square -> "mask-square"
    Circle -> "mask-circle"
    Star -> "mask-star"
    Star2 -> "mask-star-2"
    Triangle -> "mask-triangle"
    Triangle2 -> "mask-triangle-2"
    Triangle3 -> "mask-triangle-3"
    Triangle4 -> "mask-triangle-4"
  }
  let class =
    [Some("mask"), Some(shape_class), m.half]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.img([attribute.class(class), ..m.attrs])
}
