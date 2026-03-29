#+feature using-stmt
package tests

import main ".."
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
