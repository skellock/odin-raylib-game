#+feature using-stmt
package tests

import main "../src"
import "core:strings"
import "core:testing"

@(test)
console_update_limits_input_test :: proc(t: ^testing.T) {
	using main, testing

	console := console_init()
	defer console_destroy(&console)
	console.active = true
	input: [CONSOLE_MAX_CHARS * 2]byte
	for &ch in input { ch = 'x' }
	actions: Actions
	actions.console.typed = string(input[:CONSOLE_MAX_CHARS - 1])
	console_update(&console, actions, Mouse{})
	actions.console.typed = "abc"
	console_update(&console, actions, Mouse{})
	value := console_get_value(console)
	expect_value(t, len(value), CONSOLE_MAX_CHARS)
	expect_value(t, value[CONSOLE_MAX_CHARS - 1], u8('a'))
	console_update(&console, actions, Mouse{})
	expect_value(t, len(console_get_value(console)), CONSOLE_MAX_CHARS)

	console_clear(&console)
	actions.console.typed = string(input[:])
	console_update(&console, actions, Mouse{})
	expect_value(t, console_get_value(console), string(input[:CONSOLE_MAX_CHARS]))
}

@(test)
console_update_backspace_makes_room_at_limit_test :: proc(t: ^testing.T) {
	using main, testing

	console := console_init()
	defer console_destroy(&console)
	console.active = true
	input: [CONSOLE_MAX_CHARS]byte
	for &ch in input { ch = 'x' }
	actions: Actions
	actions.console.typed = string(input[:])
	console_update(&console, actions, Mouse{})
	actions.console.backspace = true
	actions.console.typed = "yz"
	console_update(&console, actions, Mouse{})
	value := console_get_value(console)
	expect_value(t, len(value), CONSOLE_MAX_CHARS)
	expect_value(t, value[:CONSOLE_MAX_CHARS - 1], string(input[:CONSOLE_MAX_CHARS - 1]))
	expect_value(t, value[CONSOLE_MAX_CHARS - 1], u8('y'))
}

@(test)
console_update_backspace_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)
	mouse := Mouse{}

	// "hello" -> "hell"
	strings.write_string(&game.console.builder, "hello")
	game.console.active = true
	game.actions.console.backspace = true
	console_update(&game.console, game.actions, mouse)
	expect_value(t, console_get_value(game.console), "hell")

	// "hell" -> "hel"
	game.actions.console.backspace = true
	console_update(&game.console, game.actions, mouse)
	expect_value(t, console_get_value(game.console), "hel")

	// keep going until empty
	game.actions.console.backspace = true
	console_update(&game.console, game.actions, mouse)
	expect_value(t, console_get_value(game.console), "he")

	game.actions.console.backspace = true
	console_update(&game.console, game.actions, mouse)
	expect_value(t, console_get_value(game.console), "h")

	game.actions.console.backspace = true
	console_update(&game.console, game.actions, mouse)
	expect_value(t, console_get_value(game.console), "")

	// backspace on empty stays empty
	game.actions.console.backspace = true
	console_update(&game.console, game.actions, mouse)
	expect_value(t, console_get_value(game.console), "")
}

@(test)
console_update_backspace_word_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)
	mouse := Mouse{}

	// "hello world" -> "hello"
	strings.write_string(&game.console.builder, "hello world")
	game.console.active = true
	game.actions.console.backspace_word = true
	console_update(&game.console, game.actions, mouse)
	expect_value(t, console_get_value(game.console), "hello")

	// "hello" -> "" (no space, clears all)
	game.actions.console.backspace_word = true
	console_update(&game.console, game.actions, mouse)
	expect_value(t, console_get_value(game.console), "")

	// "one two three" -> "one two"
	strings.write_string(&game.console.builder, "one two three")
	game.actions.console.backspace_word = true
	console_update(&game.console, game.actions, mouse)
	expect_value(t, console_get_value(game.console), "one two")

	// "trailing spaces   " -> "trailing"
	console_clear(&game.console)
	strings.write_string(&game.console.builder, "trailing spaces   ")
	game.actions.console.backspace_word = true
	console_update(&game.console, game.actions, mouse)
	expect_value(t, console_get_value(game.console), "trailing")

	// empty string stays empty
	console_clear(&game.console)
	game.actions.console.backspace_word = true
	console_update(&game.console, game.actions, mouse)
	expect_value(t, console_get_value(game.console), "")
}
