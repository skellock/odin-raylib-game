#+feature using-stmt
package tests

import main ".."
import "core:testing"

@(test)
update_actions_reshuffle_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	game.input.mouse.right_pressed = false
	game.reshuffler.cooldown.active = false
	update_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, false)

	game.input.mouse.right_pressed = true
	game.reshuffler.cooldown.active = false
	update_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, true)

	game.input.mouse.right_pressed = true
	game.reshuffler.cooldown.active = true
	update_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, false)

	game.input.mouse.right_pressed = false
	game.reshuffler.cooldown.active = true
	update_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, false)
}

@(test)
update_actions_move_dot_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	game.input.mouse.left_pressed = false
	update_actions(&game)
	testing.expect_value(t, game.actions.move_dot.active, false)

	game.input.mouse.left_pressed = true
	game.input.mouse.world_pos = {1.1, 2.2}
	update_actions(&game)
	testing.expect_value(t, game.actions.move_dot, MoveDotAction{true, {1.1, 2.2}})
}

@(test)
update_actions_quit_game_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	game.input.keyboard.quit_pressed = false
	update_actions(&game)
	testing.expect_value(t, game.actions.quit_game, false)

	game.input.keyboard.quit_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.quit_game, true)
}

@(test)
update_actions_toggle_pause_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	game.input.keyboard.pause_pressed = false
	update_actions(&game)
	testing.expect_value(t, game.actions.toggle_pause, false)

	game.input.keyboard.pause_pressed = true
	update_actions(&game)
	testing.expect_value(t, game.actions.toggle_pause, true)
}
