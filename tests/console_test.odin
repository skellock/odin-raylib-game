#+feature using-stmt
package tests

import main "../src"
import "core:strings"
import "core:testing"

@(test)
console_update_backspace_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	// "hello" -> "hell"
	strings.write_string(&game.console.builder, "hello")
	game.console.active = true
	game.actions.console.backspace = true
	console_update(&game)
	expect_value(t, console_get_value(&game.console), "hell")

	// "hell" -> "hel"
	game.actions.console.backspace = true
	console_update(&game)
	expect_value(t, console_get_value(&game.console), "hel")

	// keep going until empty
	game.actions.console.backspace = true
	console_update(&game)
	expect_value(t, console_get_value(&game.console), "he")

	game.actions.console.backspace = true
	console_update(&game)
	expect_value(t, console_get_value(&game.console), "h")

	game.actions.console.backspace = true
	console_update(&game)
	expect_value(t, console_get_value(&game.console), "")

	// backspace on empty stays empty
	game.actions.console.backspace = true
	console_update(&game)
	expect_value(t, console_get_value(&game.console), "")
}

@(test)
console_update_backspace_word_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	// "hello world" -> "hello"
	strings.write_string(&game.console.builder, "hello world")
	game.console.active = true
	game.actions.console.backspace_word = true
	console_update(&game)
	expect_value(t, console_get_value(&game.console), "hello")

	// "hello" -> "" (no space, clears all)
	game.actions.console.backspace_word = true
	console_update(&game)
	expect_value(t, console_get_value(&game.console), "")

	// "one two three" -> "one two"
	strings.write_string(&game.console.builder, "one two three")
	game.actions.console.backspace_word = true
	console_update(&game)
	expect_value(t, console_get_value(&game.console), "one two")

	// "trailing spaces   " -> "trailing"
	console_clear(&game.console)
	strings.write_string(&game.console.builder, "trailing spaces   ")
	game.actions.console.backspace_word = true
	console_update(&game)
	expect_value(t, console_get_value(&game.console), "trailing")

	// empty string stays empty
	console_clear(&game.console)
	game.actions.console.backspace_word = true
	console_update(&game)
	expect_value(t, console_get_value(&game.console), "")
}
