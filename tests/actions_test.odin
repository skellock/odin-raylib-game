#+feature using-stmt
package tests

import main ".."
import "core:strings"
import "core:testing"

@(test)
update_actions_reshuffle_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	game.mouse.right_pressed = false
	game.reshuffler.cooldown.active = false
	update_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, false)

	game.mouse.right_pressed = true
	game.reshuffler.cooldown.active = false
	update_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, true)

	game.mouse.right_pressed = true
	game.reshuffler.cooldown.active = true
	update_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, false)

	game.mouse.right_pressed = false
	game.reshuffler.cooldown.active = true
	update_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, false)
}

@(test)
update_actions_move_dot_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	game.mouse.left_pressed = false
	update_actions(&game)
	testing.expect_value(t, game.actions.move_dot.active, false)

	game.mouse.left_pressed = true
	game.mouse.world_pos = {1.1, 2.2}
	update_actions(&game)
	testing.expect_value(t, game.actions.move_dot, MoveDotAction{true, {1.1, 2.2}})
}

@(test)
update_actions_quit_game_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	game.keyboard.quit_pressed = false
	update_actions(&game)
	testing.expect_value(t, game.actions.quit_game, false)

	game.keyboard.quit_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.quit_game, true)
}

@(test)
update_actions_toggle_pause_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	game.keyboard.pause_pressed = false
	update_actions(&game)
	testing.expect_value(t, game.actions.toggle_pause, false)

	game.keyboard.pause_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.toggle_pause, true)
}

@(test)
update_actions_show_console_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	// slash shows console when console is not active
	game.console.active = false
	game.keyboard.slash_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.console.show, true)

	// slash does not show console when console is already active
	game.console.active = true
	game.keyboard.slash_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.console.show, false)
}

@(test)
update_actions_hide_console_escape_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	// escape hides console when active
	game.console.active = true
	game.keyboard.escape_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.console.hide, true)
	testing.expect_value(t, game.actions.console.clear, true)

	// escape does nothing when console is not active
	game.console.active = false
	game.keyboard.escape_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.console.hide, false)
	testing.expect_value(t, game.actions.console.clear, false)
}

@(test)
update_actions_hide_console_enter_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	// enter hides and clears console when active
	game.console.active = true
	game.keyboard.enter_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.console.hide, true)
	testing.expect_value(t, game.actions.console.clear, true)

	// enter does nothing when console is not active
	game.console.active = false
	game.keyboard.enter_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.console.hide, false)
	testing.expect_value(t, game.actions.console.clear, false)
}

@(test)
update_actions_console_backspace_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	// backspace action when console is active
	game.console.active = true
	game.keyboard.backspace_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.console.backspace, true)

	// backspace not set when console is not active
	game.console.active = false
	game.keyboard.backspace_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.console.backspace, false)
}

@(test)
update_actions_console_typed_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	// when the console is active, we capture keystrokes
	game.console.active = true
	game.keyboard.typed = "fun"

	update_actions(&game)
	// frame-based keys get transfered to the console
	testing.expect_value(t, game.actions.console.typed, "fun")

	game.console.active = false
	game.keyboard.typed = "nope"
	update_actions(&game)
	testing.expect_value(t, game.actions.console.typed, "")
}

@(private = "file")
run_command :: proc(command: string) -> main.Actions {
	using main
	game := init_game()
	defer destroy_game(&game)

	strings.write_string(&game.console.builder, command)
	game.console.active = true
	game.keyboard.enter_pressed = true
	update_actions(&game)

	return game.actions
}

@(test)
update_actions_console_quit_test :: proc(t: ^testing.T) {
	a := run_command("quit")
	testing.expect_value(t, a.quit_game, true)
}

@(test)
update_actions_console_pause_test :: proc(t: ^testing.T) {
	a := run_command("pause")
	testing.expect_value(t, a.toggle_pause, true)
}

@(test)
update_actions_console_load_test :: proc(t: ^testing.T) {
	a := run_command("load")
	testing.expect_value(t, a.load_game, true)
}

@(test)
update_actions_console_save_test :: proc(t: ^testing.T) {
	a := run_command("save")
	testing.expect_value(t, a.save_game, true)
}
