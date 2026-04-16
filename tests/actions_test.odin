#+feature using-stmt
package tests

import main "../src"
import "core:strings"
import "core:testing"

@(test)
actions_update_reshuffle_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	game.mouse.right_pressed = false
	game.reshuffler.cooldown.active = false
	actions_update(&game)
	expect_value(t, game.actions.reshuffle, false)

	game.mouse.right_pressed = true
	game.reshuffler.cooldown.active = false
	actions_update(&game)
	expect_value(t, game.actions.reshuffle, true)

	game.mouse.right_pressed = true
	game.reshuffler.cooldown.active = true
	actions_update(&game)
	expect_value(t, game.actions.reshuffle, false)

	game.mouse.right_pressed = false
	game.reshuffler.cooldown.active = true
	actions_update(&game)
	expect_value(t, game.actions.reshuffle, false)
}

@(test)
actions_update_move_dot_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	game.mouse.left_pressed = false
	actions_update(&game)
	expect_value(t, game.actions.move_dot.active, false)

	game.mouse.left_pressed = true
	game.mouse.world_pos = {1.1, 2.2}
	actions_update(&game)
	expect_value(t, game.actions.move_dot, MoveDotAction{true, {1.1, 2.2}})
}

@(test)
actions_update_quit_game_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	game.keyboard.quit_pressed = false
	actions_update(&game)
	expect_value(t, game.actions.quit_game, false)

	game.keyboard.quit_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.quit_game, true)
}

@(test)
actions_update_toggle_pause_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	game.keyboard.pause_pressed = false
	actions_update(&game)
	expect_value(t, game.actions.toggle_pause, false)

	game.keyboard.pause_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.toggle_pause, true)
}

@(test)
actions_update_show_console_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	// slash shows console when console is not active
	game.console.active = false
	game.keyboard.slash_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.console.show, true)

	// slash does not show console when console is already active
	game.console.active = true
	game.keyboard.slash_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.console.show, false)
}

@(test)
actions_update_hide_console_escape_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	// escape hides console when active
	game.console.active = true
	game.keyboard.escape_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.console.hide, true)
	expect_value(t, game.actions.console.clear, true)

	// escape does nothing when console is not active
	game.console.active = false
	game.keyboard.escape_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.console.hide, false)
	expect_value(t, game.actions.console.clear, false)
}

@(test)
actions_update_hide_console_enter_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	// enter hides and clears console when active
	game.console.active = true
	game.keyboard.enter_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.console.hide, true)
	expect_value(t, game.actions.console.clear, true)

	// enter does nothing when console is not active
	game.console.active = false
	game.keyboard.enter_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.console.hide, false)
	expect_value(t, game.actions.console.clear, false)
}

@(test)
actions_update_console_backspace_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	// backspace action when console is active
	game.console.active = true
	game.keyboard.backspace_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.console.backspace, true)

	// backspace not set when console is not active
	game.console.active = false
	game.keyboard.backspace_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.console.backspace, false)
}

@(test)
actions_update_console_typed_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	// when the console is active, we capture keystrokes
	game.console.active = true
	game.keyboard.typed = "fun"

	actions_update(&game)
	// frame-based keys get transfered to the console
	expect_value(t, game.actions.console.typed, "fun")

	game.console.active = false
	game.keyboard.typed = "nope"
	actions_update(&game)
	expect_value(t, game.actions.console.typed, "")
}

@(private = "file")
run_command :: proc(command: string) -> main.Actions {
	using main
	game := game_init()
	defer game_destroy(&game)

	strings.write_string(&game.console.builder, command)
	game.console.active = true
	game.keyboard.enter_pressed = true
	actions_update(&game)

	return game.actions
}

@(test)
actions_update_console_quit_test :: proc(t: ^testing.T) {
	using testing

	a := run_command("quit")
	expect_value(t, a.quit_game, true)
}

@(test)
actions_update_console_pause_test :: proc(t: ^testing.T) {
	using testing

	a := run_command("pause")
	expect_value(t, a.toggle_pause, true)
}

@(test)
actions_update_console_load_test :: proc(t: ^testing.T) {
	using testing

	a := run_command("load")
	expect_value(t, a.load_game, true)
}

@(test)
actions_update_console_save_test :: proc(t: ^testing.T) {
	using testing

	a := run_command("save")
	expect_value(t, a.save_game, true)
}

@(test)
actions_update_console_backspace_word_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	// backspace_word action when console is active
	game.console.active = true
	game.keyboard.backspace_word_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.console.backspace_word, true)

	// backspace_word not set when console is not active
	game.console.active = false
	game.keyboard.backspace_word_pressed = true
	actions_update(&game)
	expect_value(t, game.actions.console.backspace_word, false)
}
