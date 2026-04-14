/// A builder for DaisyUI hover-gallery elements.
///
/// The hover-gallery component shows the first image by default and reveals
/// the remaining images (up to 10 total) as the user hovers horizontally
/// across the container. It is useful for product cards, portfolios, and
/// image galleries.
///
/// The component renders as a `<figure class="hover-gallery">` containing
/// `<img>` elements. Use `attrs/2` to set width constraints and other
/// Tailwind utilities on the figure.
///
/// ## Quick start
///
/// ```gleam
/// import daisyui/hover_gallery
/// import lustre/attribute
///
/// hover_gallery.new()
/// |> hover_gallery.attrs([attribute.class("max-w-60")])
/// |> hover_gallery.images([
///   #("https://example.com/hat-1.webp", "Product image 1"),
///   #("https://example.com/hat-2.webp", "Product image 2"),
///   #("https://example.com/hat-3.webp", "Product image 3"),
///   #("https://example.com/hat-4.webp", "Product image 4"),
/// ])
/// |> hover_gallery.build
/// ```
///
/// ## Reference
/// - [DaisyUI hover-gallery](https://daisyui.com/components/hover-gallery/)
import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// An opaque builder that accumulates hover-gallery configuration before
/// being converted to a Lustre element by `build/1`.
pub opaque type HoverGallery(msg) {
  HoverGallery(attrs: List(Attribute(msg)), children: List(Element(msg)))
}

// ---------------------------------------------------------------------------
// Constructor
// ---------------------------------------------------------------------------

/// Creates a new `HoverGallery` builder with no extra attributes and no
/// images.
///
/// ```gleam
/// hover_gallery.new()
/// |> hover_gallery.images([#("/hat-1.webp", "Hat 1"), …])
/// |> hover_gallery.build
/// ```
pub fn new() -> HoverGallery(msg) {
  HoverGallery(attrs: [], children: [])
}

// ---------------------------------------------------------------------------
// Attrs
// ---------------------------------------------------------------------------

/// Merges additional Lustre attributes onto the `<figure>` element.
///
/// Use this for width constraints and other Tailwind utilities:
///
/// ```gleam
/// hover_gallery.new()
/// |> hover_gallery.attrs([attribute.class("max-w-60")])
/// |> hover_gallery.build
/// ```
pub fn attrs(h: HoverGallery(msg), a: List(Attribute(msg))) -> HoverGallery(msg) {
  HoverGallery(..h, attrs: a)
}

// ---------------------------------------------------------------------------
// Images
// ---------------------------------------------------------------------------

/// Sets the gallery images from a list of `#(src, alt)` pairs.
///
/// The first image is shown by default; the remaining images (up to 9 more,
/// 10 total) are revealed as the user hovers horizontally.
///
/// ```gleam
/// hover_gallery.new()
/// |> hover_gallery.images([
///   #("https://example.com/hat-1.webp", "View 1"),
///   #("https://example.com/hat-2.webp", "View 2"),
///   #("https://example.com/hat-3.webp", "View 3"),
/// ])
/// |> hover_gallery.build
/// ```
pub fn images(
  h: HoverGallery(msg),
  srcs: List(#(String, String)),
) -> HoverGallery(msg) {
  let imgs =
    list.map(srcs, fn(pair) {
      html.img([attribute.src(pair.0), attribute.alt(pair.1)])
    })
  HoverGallery(..h, children: imgs)
}

/// Sets the gallery images from raw `Element(msg)` values.
///
/// Prefer `images/2` for the common case of plain `<img>` elements. Use this
/// when you need full control over each image element's attributes.
///
/// ```gleam
/// hover_gallery.new()
/// |> hover_gallery.children([
///   html.img([attribute.src("/1.webp"), attribute.class("rounded")]),
///   html.img([attribute.src("/2.webp"), attribute.class("rounded")]),
/// ])
/// |> hover_gallery.build
/// ```
pub fn children(
  h: HoverGallery(msg),
  c: List(Element(msg)),
) -> HoverGallery(msg) {
  HoverGallery(..h, children: c)
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Converts the `HoverGallery` builder into a Lustre `Element(msg)`.
///
/// Renders:
///
/// ```html
/// <figure class="hover-gallery" …attrs>
///   <img src="…" alt="…" />
///   …
/// </figure>
/// ```
///
/// Always call this at the end of a builder chain.
///
/// ## Reference
/// - [DaisyUI hover-gallery](https://daisyui.com/components/hover-gallery/)
pub fn build(h: HoverGallery(msg)) -> Element(msg) {
  html.figure([attribute.class("hover-gallery"), ..h.attrs], h.children)
}
