#+feature using-stmt
package tests

import main ".."
import "core:strings"
import "core:testing"

@(test)
update_console_backspace_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	// "hello" -> "hell"
	strings.write_string(&game.console.builder, "hello")
	game.console.active = true
	game.actions.console.backspace = true
	update_console(&game)
	testing.expect_value(t, get_console_value(&game.console), "hell")

	// "hell" -> "hel"
	game.actions.console.backspace = true
	update_console(&game)
	testing.expect_value(t, get_console_value(&game.console), "hel")

	// keep going until empty
	game.actions.console.backspace = true
	update_console(&game)
	testing.expect_value(t, get_console_value(&game.console), "he")

	game.actions.console.backspace = true
	update_console(&game)
	testing.expect_value(t, get_console_value(&game.console), "h")

	game.actions.console.backspace = true
	update_console(&game)
	testing.expect_value(t, get_console_value(&game.console), "")

	// backspace on empty stays empty
	game.actions.console.backspace = true
	update_console(&game)
	testing.expect_value(t, get_console_value(&game.console), "")
}

@(test)
update_console_backspace_word_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	// "hello world" -> "hello"
	strings.write_string(&game.console.builder, "hello world")
	game.console.active = true
	game.actions.console.backspace_word = true
	update_console(&game)
	testing.expect_value(t, get_console_value(&game.console), "hello")

	// "hello" -> "" (no space, clears all)
	game.actions.console.backspace_word = true
	update_console(&game)
	testing.expect_value(t, get_console_value(&game.console), "")

	// "one two three" -> "one two"
	strings.write_string(&game.console.builder, "one two three")
	game.actions.console.backspace_word = true
	update_console(&game)
	testing.expect_value(t, get_console_value(&game.console), "one two")

	// "trailing spaces   " -> "trailing"
	clear_console(&game.console)
	strings.write_string(&game.console.builder, "trailing spaces   ")
	game.actions.console.backspace_word = true
	update_console(&game)
	testing.expect_value(t, get_console_value(&game.console), "trailing")

	// empty string stays empty
	clear_console(&game.console)
	game.actions.console.backspace_word = true
	update_console(&game)
	testing.expect_value(t, get_console_value(&game.console), "")
}
