import daisyui/badge
import daisyui/button
import daisyui/divider
import daisyui/input
import daisyui/select
import daisyui/toggle
import gleam/dynamic/decode
import gleam/int
import gleam/list
import gleam/string
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

pub type Filter {
  All
  Active
  Done
}

pub type Todo {
  Todo(id: Int, text: String, done: Bool)
}

pub type Model {
  Model(
    theme: String,
    todos: List(Todo),
    draft: String,
    filter: Filter,
    next_id: Int,
  )
}

pub type Msg {
  UserChangedTheme(String)
  UserTypedDraft(String)
  UserSubmittedTodo
  UserToggledTodo(Int)
  UserDeletedTodo(Int)
  UserSetFilter(Filter)
  UserClearedDone
}

// ---------------------------------------------------------------------------
// Init / update
// ---------------------------------------------------------------------------

fn init(_flags) -> Model {
  Model(
    theme: "light",
    todos: [
      Todo(id: 1, text: "Read the Gleam docs", done: True),
      Todo(id: 2, text: "Build something with daisyui_gleam", done: False),
      Todo(id: 3, text: "Ship it 🚀", done: False),
    ],
    draft: "",
    filter: All,
    next_id: 4,
  )
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedTheme(t) -> Model(..model, theme: t)

    UserTypedDraft(text) -> Model(..model, draft: text)

    UserSubmittedTodo -> {
      let trimmed = string.trim(model.draft)
      case trimmed {
        "" -> model
        text ->
          Model(
            ..model,
            todos: list.append(model.todos, [
              Todo(id: model.next_id, text: text, done: False),
            ]),
            draft: "",
            next_id: model.next_id + 1,
          )
      }
    }

    UserToggledTodo(id) ->
      Model(
        ..model,
        todos: list.map(model.todos, fn(t) {
          case t.id == id {
            True -> Todo(..t, done: !t.done)
            False -> t
          }
        }),
      )

    UserDeletedTodo(id) ->
      Model(..model, todos: list.filter(model.todos, fn(t) { t.id != id }))

    UserSetFilter(f) -> Model(..model, filter: f)

    UserClearedDone ->
      Model(..model, todos: list.filter(model.todos, fn(t) { !t.done }))
  }
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

// ---------------------------------------------------------------------------
// View
// ---------------------------------------------------------------------------

fn view(model: Model) -> Element(Msg) {
  html.div(
    [
      attribute.attribute("data-theme", model.theme),
      attribute.class("min-h-screen bg-base-200"),
    ],
    [
      page_header(model.theme),
      html.main([attribute.class("max-w-2xl mx-auto px-4 py-10 space-y-6")], [
        todo_input(model.draft),
        filter_bar(model.filter, model.todos),
        todo_list(model.todos, model.filter),
        footer_bar(model.todos),
      ]),
    ],
  )
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

fn page_header(current_theme: String) -> Element(Msg) {
  html.header(
    [
      attribute.class(
        "sticky top-0 z-50 bg-base-100 shadow px-6 h-16 flex items-center gap-4",
      ),
    ],
    [
      html.h1([attribute.class("text-xl font-bold flex-1")], [
        html.text("✅ Todos"),
      ]),
      select.new()
        |> select.sm
        |> select.attrs([
          attribute.value(current_theme),
          event.on_input(UserChangedTheme),
        ])
        |> select.children([
          html.option([attribute.value("light")], "light"),
          html.option([attribute.value("dark")], "dark"),
          html.option([attribute.value("cupcake")], "cupcake"),
          html.option([attribute.value("corporate")], "corporate"),
          html.option([attribute.value("synthwave")], "synthwave"),
          html.option([attribute.value("retro")], "retro"),
          html.option([attribute.value("dracula")], "dracula"),
          html.option([attribute.value("nord")], "nord"),
          html.option([attribute.value("dim")], "dim"),
        ])
        |> select.build,
    ],
  )
}

// ---------------------------------------------------------------------------
// Input row
// ---------------------------------------------------------------------------

fn todo_input(draft: String) -> Element(Msg) {
  html.div([attribute.class("flex gap-2")], [
    input.new()
      |> input.primary
      |> input.attrs([
        attribute.class("flex-1"),
        attribute.placeholder("What needs to be done?"),
        attribute.value(draft),
        attribute.autocomplete("off"),
        event.on_input(UserTypedDraft),
        event.on("keydown", {
          use key <- decode.field("key", decode.string)
          case key {
            "Enter" -> decode.success(UserSubmittedTodo)
            _ -> decode.failure(UserSubmittedTodo, "not-enter")
          }
        }),
      ])
      |> input.build,
    button.new()
      |> button.primary
      |> button.attrs([event.on_click(UserSubmittedTodo)])
      |> button.text("Add")
      |> button.build,
  ])
}

// ---------------------------------------------------------------------------
// Filter bar
// ---------------------------------------------------------------------------

fn filter_bar(current: Filter, todos: List(Todo)) -> Element(Msg) {
  let active_count = list.count(todos, fn(t) { !t.done })
  let done_count = list.count(todos, fn(t) { t.done })

  html.div([attribute.class("flex items-center gap-2")], [
    filter_btn("All", All, current, list.length(todos)),
    filter_btn("Active", Active, current, active_count),
    filter_btn("Done", Done, current, done_count),
  ])
}

fn filter_btn(
  label: String,
  filter: Filter,
  current: Filter,
  count: Int,
) -> Element(Msg) {
  let is_active = filter == current

  let base =
    button.new()
    |> button.sm
    |> button.attrs([event.on_click(UserSetFilter(filter))])

  let styled = case is_active {
    True -> base |> button.primary
    False -> base |> button.ghost
  }

  let count_badge =
    badge.new()
    |> badge.sm
    |> badge.text(int.to_string(count))

  let count_badge = case is_active {
    True -> count_badge |> badge.primary
    False -> count_badge |> badge.ghost
  }

  styled
  |> button.children([html.text(label), count_badge |> badge.build])
  |> button.build
}

// ---------------------------------------------------------------------------
// Todo list
// ---------------------------------------------------------------------------

fn todo_list(todos: List(Todo), filter: Filter) -> Element(Msg) {
  let visible =
    list.filter(todos, fn(t) {
      case filter {
        All -> True
        Active -> !t.done
        Done -> t.done
      }
    })

  case visible {
    [] -> empty_state(filter)
    items ->
      html.div([attribute.class("card bg-base-100 shadow-sm overflow-hidden")], [
        html.ul([], list.map(items, todo_item)),
      ])
  }
}

fn todo_item(item: Todo) -> Element(Msg) {
  html.li(
    [
      attribute.class(
        "flex items-center gap-4 px-5 py-4 border-b border-base-200 last:border-0 group",
      ),
    ],
    [
      toggle.new()
        |> toggle.success
        |> fn(t) {
          case item.done {
            True -> toggle.checked(t)
            False -> t
          }
        }
        |> toggle.attrs([
          event.on("change", decode.success(UserToggledTodo(item.id))),
        ])
        |> toggle.build,
      html.span(
        [
          attribute.class(case item.done {
            True -> "flex-1 line-through opacity-40"
            False -> "flex-1"
          }),
        ],
        [html.text(item.text)],
      ),
      button.new()
        |> button.ghost
        |> button.xs
        |> button.circle
        |> button.attrs([
          attribute.class(
            "opacity-0 group-hover:opacity-100 transition-opacity",
          ),
          event.on_click(UserDeletedTodo(item.id)),
        ])
        |> button.text("✕")
        |> button.build,
    ],
  )
}

fn empty_state(filter: Filter) -> Element(Msg) {
  let message = case filter {
    All -> "No todos yet — add one above!"
    Active -> "Nothing left to do. 🎉"
    Done -> "Nothing completed yet."
  }
  html.div(
    [attribute.class("card bg-base-100 shadow-sm py-16 text-center opacity-50")],
    [html.p([attribute.class("text-lg")], [html.text(message)])],
  )
}

// ---------------------------------------------------------------------------
// Footer
// ---------------------------------------------------------------------------

fn footer_bar(todos: List(Todo)) -> Element(Msg) {
  let done_count = list.count(todos, fn(t) { t.done })
  let active_count = list.length(todos) - done_count

  case todos {
    [] -> html.text("")
    _ ->
      html.div([attribute.class("space-y-3")], [
        divider.new() |> divider.build,
        html.div(
          [
            attribute.class(
              "flex items-center justify-between text-sm opacity-60 px-1",
            ),
          ],
          [
            html.span([], [
              html.text(
                int.to_string(active_count)
                <> case active_count {
                  1 -> " item left"
                  _ -> " items left"
                },
              ),
            ]),
            case done_count > 0 {
              True ->
                button.new()
                |> button.ghost
                |> button.xs
                |> button.attrs([event.on_click(UserClearedDone)])
                |> button.text(
                  "Clear completed (" <> int.to_string(done_count) <> ")",
                )
                |> button.build
              False -> html.text("")
            },
          ],
        ),
      ])
  }
}
