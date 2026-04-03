# Overview

This is a sandbox for me to learn Raylib (version 5.5) game library and the Odin programming language.

# Instructions

* Never make git commits.
* Ask before deleting any files.
* Make tests but not for any drawing code.
* Run `odinfmt -w <filename>` on each file you modify.
* When things to the game don't call the new `update_*` function if the game is paused. See the main game loop.

# Patterns

Prefer to create `*.odin` files based on nouns (e.g. `thing.odin`).

When creating new structs, e.g. `struct :: Thing{}` and it needs memory management, then an `init_*` and `destroy_*` function.

```odin
Thing :: struct{}

init_thing :: proc() -> Thing {
    result := Thing{}
    return result
}


destroy_thing :: proc(thing: ^Thing) {
    delete(&thing.memory)
}
```

When drawing or updating, prefer to pass a pointer to the `Game` struct.

```odin
update_thing :: proc(game: ^Game) {
}

draw_thing :: proc(game: ^Game) {
}
```
