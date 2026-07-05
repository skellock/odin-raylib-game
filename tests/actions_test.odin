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
	keyboard := Keyboard{}
	mouse := Mouse{}

	mouse.right_pressed = false
	game.reshuffler.cooldown.active = false
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.reshuffle, false)

	mouse.right_pressed = true
	game.reshuffler.cooldown.active = false
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.reshuffle, true)

	mouse.right_pressed = true
	game.reshuffler.cooldown.active = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.reshuffle, false)

	mouse.right_pressed = false
	game.reshuffler.cooldown.active = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.reshuffle, false)
}

@(test)
actions_update_move_dot_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)
	keyboard := Keyboard{}
	mouse := Mouse{}

	mouse.left_pressed = false
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.move_dot.active, false)

	mouse.left_pressed = true
	mouse.world_pos = {1.1, 2.2}
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.move_dot, MoveDotAction{true, {1.1, 2.2}})
}

@(test)
actions_update_quit_game_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)
	keyboard := Keyboard{}
	mouse := Mouse{}

	keyboard.quit_pressed = false
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.quit_game, false)

	keyboard.quit_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.quit_game, true)
}

@(test)
actions_update_toggle_pause_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)
	keyboard := Keyboard{}
	mouse := Mouse{}

	keyboard.pause_pressed = false
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.toggle_pause, false)

	keyboard.pause_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.toggle_pause, true)
}

@(test)
actions_update_show_console_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)
	keyboard := Keyboard{}
	mouse := Mouse{}

	// slash shows console when console is not active
	game.console.active = false
	keyboard.slash_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.console.show, true)

	// slash does not show console when console is already active
	game.console.active = true
	keyboard.slash_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.console.show, false)
}

@(test)
actions_update_hide_console_escape_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)
	keyboard := Keyboard{}
	mouse := Mouse{}

	// escape hides console when active
	game.console.active = true
	keyboard.escape_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.console.hide, true)
	expect_value(t, game.actions.console.clear, true)

	// escape does nothing when console is not active
	game.console.active = false
	keyboard.escape_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.console.hide, false)
	expect_value(t, game.actions.console.clear, false)
}

@(test)
actions_update_hide_console_enter_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)
	keyboard := Keyboard{}
	mouse := Mouse{}

	// enter hides and clears console when active
	game.console.active = true
	keyboard.enter_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.console.hide, true)
	expect_value(t, game.actions.console.clear, true)

	// enter does nothing when console is not active
	game.console.active = false
	keyboard.enter_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.console.hide, false)
	expect_value(t, game.actions.console.clear, false)
}

@(test)
actions_update_console_backspace_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)
	keyboard := Keyboard{}
	mouse := Mouse{}

	// backspace action when console is active
	game.console.active = true
	keyboard.backspace_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.console.backspace, true)

	// backspace not set when console is not active
	game.console.active = false
	keyboard.backspace_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.console.backspace, false)
}

@(test)
actions_update_console_typed_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)
	keyboard := Keyboard{}
	mouse := Mouse{}

	// when the console is active, we capture keystrokes
	game.console.active = true
	keyboard.typed = "fun"

	actions_update(&game, keyboard, mouse)
	// frame-based keys get transfered to the console
	expect_value(t, game.actions.console.typed, "fun")

	game.console.active = false
	keyboard.typed = "nope"
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.console.typed, "")
}

@(private = "file")
run_command :: proc(command: string) -> main.Actions {
	using main
	game := game_init()
	defer game_destroy(&game)
	keyboard := Keyboard{}
	mouse := Mouse{}

	strings.write_string(&game.console.builder, command)
	game.console.active = true
	keyboard.enter_pressed = true
	actions_update(&game, keyboard, mouse)

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
	keyboard := Keyboard{}
	mouse := Mouse{}

	// backspace_word action when console is active
	game.console.active = true
	keyboard.backspace_word_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.console.backspace_word, true)

	// backspace_word not set when console is not active
	game.console.active = false
	keyboard.backspace_word_pressed = true
	actions_update(&game, keyboard, mouse)
	expect_value(t, game.actions.console.backspace_word, false)
}
