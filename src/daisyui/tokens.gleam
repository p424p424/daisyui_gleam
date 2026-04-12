/// Shared design tokens for `daisyui_gleam` components.
///
/// This module sits at the centre of the library. Rather than each component
/// declaring its own size, colour, and weight types, they all import from
/// here — keeping the surface area small and consistent across `Button`,
/// `Badge`, `Alert`, `Text`, and anything you add later.
///
/// ## Three layers working together
///
/// Understanding how these three tools relate makes the whole system click:
///
/// **Tailwind CSS** supplies the low-level utility classes that end up in
/// your HTML — things like `text-xl`, `font-bold`, `bg-primary`. It works
/// by scanning your source for class name strings and generating only the
/// CSS you actually use.
/// → [Tailwind docs](https://tailwindcss.com/docs)
///
/// **DaisyUI** is a Tailwind plugin that adds higher-level component classes
/// on top — things like `btn-primary`, `badge-xs`, `alert-soft`. It also
/// defines the semantic colour variables (e.g. `--color-primary`) that
/// Tailwind's utilities reference, so swapping themes changes every colour
/// at once.
/// → [DaisyUI docs](https://daisyui.com/docs)
///
/// **Lustre** is the Gleam web framework this library targets. Components
/// are built as `Element(msg)` values and composed into a Lustre view.
/// → [Lustre docs](https://hexdocs.pm/lustre/)
/// The five-step size scale shared by DaisyUI interactive components.
///
/// DaisyUI uses the same scale — `xs`, `sm`, `md`, `lg`, `xl` — across
/// buttons, badges, inputs, selects, and more. The size controls overall
/// element dimensions (padding, height, font-size) rather than just text.
///
/// > **New to DaisyUI?** A "component class" like `btn-xs` is just a regular
/// > CSS class provided by the DaisyUI plugin. Tailwind generates the
/// > underlying rules; DaisyUI groups them into a convenient shorthand.
///
/// > **Note:** This scale is separate from Tailwind's `text-*` font-size
/// > scale. For typography, use `TextSize` instead.
///
/// ## Reference
/// - [DaisyUI button sizes](https://daisyui.com/components/button/#sizes)
/// - [DaisyUI badge sizes](https://daisyui.com/components/badge/#sizes)
pub type Size {
  /// Maps to `-xs` — the smallest variant (e.g. `btn-xs`, `badge-xs`).
  XS
  /// Maps to `-sm` — slightly smaller than the default.
  SM
  /// Maps to `-md` — the default size for most components. Often optional
  /// to include since it is the baseline, but explicit is clearer.
  MD
  /// Maps to `-lg` — larger than default.
  LG
  /// Maps to `-xl` — the largest DaisyUI component size.
  XL
}

/// Builds a DaisyUI component size class from a prefix and a `Size` value.
///
/// Each DaisyUI component has its own prefix, so the same `Size` token
/// produces a different class depending on where it is used:
///
/// ```gleam
/// size_class("btn", XS)    // → "btn-xs"
/// size_class("badge", LG)  // → "badge-lg"
/// size_class("input", MD)  // → "input-md"
/// ```
///
/// ## Reference
/// - [DaisyUI button sizes](https://daisyui.com/components/button/#sizes)
/// - [DaisyUI badge sizes](https://daisyui.com/components/badge/#sizes)
pub fn size_class(prefix: String, s: Size) -> String {
  prefix
  <> case s {
    XS -> "-xs"
    SM -> "-sm"
    MD -> "-md"
    LG -> "-lg"
    XL -> "-xl"
  }
}

// ---------------------------------------------------------------------------
// Text / Typography Size
// ---------------------------------------------------------------------------

/// Tailwind's thirteen-step font-size scale, from `text-xs` to `text-9xl`.
///
/// Each step sets both `font-size` and a matching `line-height` via CSS
/// custom properties, so text stays well-spaced at every size without
/// manual line-height adjustments.
///
/// > **Why not use `Size` for text?** DaisyUI's component scale (`xs`–`xl`)
/// > and Tailwind's text scale (`xs`–`9xl`) are independent systems with
/// > different class name patterns. Keeping them as separate types prevents
/// > accidentally passing a `TextXL9` to a button.
///
/// Constructor names are prefixed with `Text` (e.g. `TextXL2` rather than
/// `XL2`) to avoid clashing with the `Size` constructors above.
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub type TextSize {
  /// `text-xs` — 0.75 rem / 12 px
  TextXS
  /// `text-sm` — 0.875 rem / 14 px
  TextSM
  /// `text-base` — 1 rem / 16 px (the browser default body size)
  TextBase
  /// `text-lg` — 1.125 rem / 18 px
  TextLG
  /// `text-xl` — 1.25 rem / 20 px
  TextXL
  /// `text-2xl` — 1.5 rem / 24 px
  TextXL2
  /// `text-3xl` — 1.875 rem / 30 px
  TextXL3
  /// `text-4xl` — 2.25 rem / 36 px
  TextXL4
  /// `text-5xl` — 3 rem / 48 px
  TextXL5
  /// `text-6xl` — 3.75 rem / 60 px
  TextXL6
  /// `text-7xl` — 4.5 rem / 72 px
  TextXL7
  /// `text-8xl` — 6 rem / 96 px
  TextXL8
  /// `text-9xl` — 8 rem / 128 px
  TextXL9
}

/// Returns the Tailwind font-size utility class for a given `TextSize`.
///
/// Unlike `size_class/2`, this function takes no prefix — Tailwind's text
/// size classes always use the `text-` prefix.
///
/// ```gleam
/// text_size_class(TextBase) // → "text-base"
/// text_size_class(TextXL2)  // → "text-2xl"
/// text_size_class(TextXL9)  // → "text-9xl"
/// ```
///
/// ## Reference
/// - [Tailwind font-size](https://tailwindcss.com/docs/font-size)
pub fn text_size_class(s: TextSize) -> String {
  case s {
    TextXS -> "text-xs"
    TextSM -> "text-sm"
    TextBase -> "text-base"
    TextLG -> "text-lg"
    TextXL -> "text-xl"
    TextXL2 -> "text-2xl"
    TextXL3 -> "text-3xl"
    TextXL4 -> "text-4xl"
    TextXL5 -> "text-5xl"
    TextXL6 -> "text-6xl"
    TextXL7 -> "text-7xl"
    TextXL8 -> "text-8xl"
    TextXL9 -> "text-9xl"
  }
}

// ---------------------------------------------------------------------------
// Semantic Color
// ---------------------------------------------------------------------------

/// DaisyUI's semantic colour palette — the colours every component shares.
///
/// Rather than hardcoding hex values, DaisyUI maps colour names to CSS
/// custom properties (e.g. `--color-primary`). The active theme provides
/// the actual values, so switching themes updates every component at once
/// without touching your Gleam code.
///
/// > **New to semantic colours?** Think of them as roles rather than shades:
/// > `Primary` is your brand colour, `Error` signals something went wrong,
/// > `Success` confirms an action completed. The exact hue is up to the
/// > theme.
///
/// ## Colour groups
///
/// **Brand colours** — the three main palette colours:
/// `Primary`, `Secondary`, `Accent` (and their `-content` counterparts).
///
/// **Neutral** — a desaturated tone for borders, subtle backgrounds, and
/// secondary UI chrome.
///
/// **Status colours** — convey meaning at a glance:
/// `Info` (blue), `Success` (green), `Warning` (yellow/orange),
/// `Error` (red).
///
/// **Surface colours** — background layers for the page and cards:
/// `Base100` (lightest, main background), `Base200`, `Base300` (progressively
/// darker). `BaseContent` is the default body text colour.
///
/// **Content variants** (`PrimaryContent`, `InfoContent`, etc.) — the
/// foreground colour designed to sit *on top of* its matching background,
/// ensuring accessible contrast. Use these for text or icons inside coloured
/// components.
///
/// ## How the prefix changes the context
///
/// The same `Color` value produces different output depending on the prefix
/// you pass to `color_class/2`:
///
/// | prefix   | example output        | where it's used                  |
/// |----------|-----------------------|----------------------------------|
/// | `"text"` | `text-primary`        | Tailwind text colour utility     |
/// | `"bg"`   | `bg-info`             | Tailwind background colour       |
/// | `"btn"`  | `btn-error`           | DaisyUI button colour modifier   |
/// | `"badge"`| `badge-success`       | DaisyUI badge colour modifier    |
/// | `"alert"`| `alert-warning`       | DaisyUI alert colour modifier    |
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
/// - [Tailwind text colour](https://tailwindcss.com/docs/text-color)
/// - [Tailwind background colour](https://tailwindcss.com/docs/background-color)
pub type Color {
  /// The primary brand colour. Use for main calls-to-action and key UI
  /// elements. Resolves to `--color-primary`.
  Primary
  /// Foreground colour for use on a `Primary` background. Ensures readable
  /// contrast. Resolves to `--color-primary-content`.
  PrimaryContent
  /// A secondary brand colour, complementary to `Primary`. Resolves to
  /// `--color-secondary`.
  Secondary
  /// Foreground for `Secondary` backgrounds. Resolves to
  /// `--color-secondary-content`.
  SecondaryContent
  /// An accent colour for highlights and decorative elements. Resolves to
  /// `--color-accent`.
  Accent
  /// Foreground for `Accent` backgrounds. Resolves to
  /// `--color-accent-content`.
  AccentContent
  /// A desaturated/neutral tone for borders and subtle chrome. Resolves to
  /// `--color-neutral`.
  Neutral
  /// Foreground for `Neutral` backgrounds. Resolves to
  /// `--color-neutral-content`.
  NeutralContent
  /// Informational blue — conveys a non-critical message or tip. Resolves to
  /// `--color-info`.
  Info
  /// Foreground for `Info` backgrounds. Resolves to `--color-info-content`.
  InfoContent
  /// Success green — confirms a completed action. Resolves to
  /// `--color-success`.
  Success
  /// Foreground for `Success` backgrounds. Resolves to
  /// `--color-success-content`.
  SuccessContent
  /// Warning yellow/orange — signals caution or a recoverable issue.
  /// Resolves to `--color-warning`.
  Warning
  /// Foreground for `Warning` backgrounds. Resolves to
  /// `--color-warning-content`.
  WarningContent
  /// Error red — signals a failure or destructive action. Resolves to
  /// `--color-error`.
  Error
  /// Foreground for `Error` backgrounds. Resolves to
  /// `--color-error-content`.
  ErrorContent
  /// Main page/card background — the lightest surface. Resolves to
  /// `--color-base-100`.
  Base100
  /// Secondary surface, slightly darker than `Base100`. Resolves to
  /// `--color-base-200`.
  Base200
  /// Tertiary surface — the darkest base tone. Resolves to
  /// `--color-base-300`.
  Base300
  /// Default body text colour for the current theme. Most body copy should
  /// use this. Resolves to `--color-base-content`.
  BaseContent
}

/// Builds a colour utility class from a prefix and a `Color` value.
///
/// The same `Color` token works across Tailwind utilities *and* DaisyUI
/// component modifiers — only the prefix changes:
///
/// ```gleam
/// color_class("text",  Primary)  // → "text-primary"
/// color_class("bg",    Base200)  // → "bg-base-200"
/// color_class("btn",   Error)    // → "btn-error"
/// color_class("badge", Success)  // → "badge-success"
/// color_class("alert", Warning)  // → "alert-warning"
/// ```
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
/// - [Tailwind text colour](https://tailwindcss.com/docs/text-color)
/// - [Tailwind background colour](https://tailwindcss.com/docs/background-color)
pub fn color_class(prefix: String, c: Color) -> String {
  prefix
  <> case c {
    Primary -> "-primary"
    PrimaryContent -> "-primary-content"
    Secondary -> "-secondary"
    SecondaryContent -> "-secondary-content"
    Accent -> "-accent"
    AccentContent -> "-accent-content"
    Neutral -> "-neutral"
    NeutralContent -> "-neutral-content"
    Info -> "-info"
    InfoContent -> "-info-content"
    Success -> "-success"
    SuccessContent -> "-success-content"
    Warning -> "-warning"
    WarningContent -> "-warning-content"
    Error -> "-error"
    ErrorContent -> "-error-content"
    Base100 -> "-base-100"
    Base200 -> "-base-200"
    Base300 -> "-base-300"
    BaseContent -> "-base-content"
  }
}

// ---------------------------------------------------------------------------
// Font Weight
// ---------------------------------------------------------------------------

/// Tailwind's eight-step font-weight scale.
///
/// Font weight controls how thick or thin the strokes of your text appear.
/// These map directly to numeric CSS `font-weight` values, but Tailwind
/// exposes them as readable names.
///
/// > Unlike `Size` and `Color`, weight classes have no component prefix —
/// > the class name is always `font-{name}`, regardless of which component
/// > uses it.
///
/// | Constructor | Class           | CSS value |
/// |-------------|-----------------|-----------|
/// | `Thin`      | `font-thin`     | 100       |
/// | `Light`     | `font-light`    | 300       |
/// | `Normal`    | `font-normal`   | 400       |
/// | `Medium`    | `font-medium`   | 500       |
/// | `Semibold`  | `font-semibold` | 600       |
/// | `Bold`      | `font-bold`     | 700       |
/// | `ExtraBold` | `font-extrabold`| 800       |
/// | `Black`     | `font-black`    | 900       |
///
/// ## Reference
/// - [Tailwind font-weight](https://tailwindcss.com/docs/font-weight)
pub type Weight {
  /// `font-thin` — weight 100, the finest stroke.
  Thin
  /// `font-light` — weight 300.
  Light
  /// `font-normal` — weight 400, the browser default for body text.
  Normal
  /// `font-medium` — weight 500, slightly heavier than normal.
  Medium
  /// `font-semibold` — weight 600.
  Semibold
  /// `font-bold` — weight 700, the conventional "bold".
  Bold
  /// `font-extrabold` — weight 800.
  ExtraBold
  /// `font-black` — weight 900, the heaviest stroke available.
  Black
}

/// Returns the Tailwind font-weight utility class for a given `Weight`.
///
/// No prefix is needed — Tailwind weight classes always start with `font-`.
///
/// ```gleam
/// weight_class(Bold)      // → "font-bold"
/// weight_class(ExtraBold) // → "font-extrabold"
/// weight_class(Thin)      // → "font-thin"
/// ```
///
/// ## Reference
/// - [Tailwind font-weight](https://tailwindcss.com/docs/font-weight)
pub fn weight_class(w: Weight) -> String {
  case w {
    Thin -> "font-thin"
    Light -> "font-light"
    Normal -> "font-normal"
    Medium -> "font-medium"
    Semibold -> "font-semibold"
    Bold -> "font-bold"
    ExtraBold -> "font-extrabold"
    Black -> "font-black"
  }
}

// ---------------------------------------------------------------------------
// Style Variant
// ---------------------------------------------------------------------------

/// Visual style variants shared across DaisyUI components.
///
/// Variants let you change the *look* of a component without changing its
/// semantic colour. They are applied as an additional modifier class
/// alongside the component's base class and colour class.
///
/// > **New to DaisyUI modifiers?** DaisyUI classes compose. A filled primary
/// > button is `btn btn-primary`. A soft primary button is
/// > `btn btn-primary btn-soft`. Each class adds one layer of style.
///
/// | Variant   | Effect                                         | Components       |
/// |-----------|------------------------------------------------|------------------|
/// | `Soft`    | Subtle tinted background, lower visual weight  | btn, badge, alert|
/// | `Outline` | Transparent background with a solid border     | btn, badge, alert|
/// | `Dash`    | Transparent background with a dashed border    | btn, badge, alert|
/// | `Ghost`   | Transparent with no border until hover/focus   | btn, badge       |
///
/// ## Reference
/// - [DaisyUI button variants](https://daisyui.com/components/button/)
/// - [DaisyUI badge variants](https://daisyui.com/components/badge/)
/// - [DaisyUI alert variants](https://daisyui.com/components/alert/)
pub type Variant {
  /// Subtle tinted background — lower visual weight than a filled button.
  /// Applies `btn-soft`, `badge-soft`, or `alert-soft`.
  Soft
  /// Transparent background with a solid border.
  /// Applies `btn-outline`, `badge-outline`, or `alert-outline`.
  Outline
  /// Transparent background with a dashed border.
  /// Applies `btn-dash`, `badge-dash`, or `alert-dash`.
  Dash
  /// No background or border in the default state; appears on interaction.
  /// Applies `btn-ghost` or `badge-ghost`.
  Ghost
}

/// Builds a DaisyUI style variant class from a prefix and a `Variant` value.
///
/// ```gleam
/// variant_class("btn",   Ghost)   // → "btn-ghost"
/// variant_class("badge", Outline) // → "badge-outline"
/// variant_class("alert", Soft)    // → "alert-soft"
/// variant_class("btn",   Dash)    // → "btn-dash"
/// ```
///
/// ## Reference
/// - [DaisyUI button variants](https://daisyui.com/components/button/)
/// - [DaisyUI badge variants](https://daisyui.com/components/badge/)
/// - [DaisyUI alert variants](https://daisyui.com/components/alert/)
pub fn variant_class(prefix: String, v: Variant) -> String {
  prefix
  <> case v {
    Soft -> "-soft"
    Outline -> "-outline"
    Dash -> "-dash"
    Ghost -> "-ghost"
  }
}
