package tests

import main ".."
import "core:testing"

@(test)
resolve_actions_reshuffle_test :: proc(t: ^testing.T) {
	game := main.init_game()
	defer main.destroy_game(&game)

	game.input.mouse.right_pressed = false
	game.reshuffler.cooldown.active = false
	main.resolve_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, false)

	game.input.mouse.right_pressed = true
	game.reshuffler.cooldown.active = false
	main.resolve_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, true)

	game.input.mouse.right_pressed = true
	game.reshuffler.cooldown.active = true
	main.resolve_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, false)

	game.input.mouse.right_pressed = false
	game.reshuffler.cooldown.active = true
	main.resolve_actions(&game)
	testing.expect_value(t, game.actions.reshuffle, false)
}

@(test)
resolve_actions_move_dot_test :: proc(t: ^testing.T) {
	game := main.init_game()
	defer main.destroy_game(&game)

	game.input.mouse.left_pressed = false
	main.resolve_actions(&game)
	testing.expect_value(t, game.actions.move_dot.active, false)

	game.input.mouse.left_pressed = true
	game.input.mouse.world_pos = {1.1, 2.2}
	main.resolve_actions(&game)
	testing.expect_value(t, game.actions.move_dot, main.MoveDotAction{true, {1.1, 2.2}})
}

@(test)
resolve_actions_quit_game_test :: proc(t: ^testing.T) {
	game := main.init_game()
	defer main.destroy_game(&game)

	game.input.keyboard.quit_pressed = false
	main.resolve_actions(&game)
	testing.expect_value(t, game.actions.quit_game, false)

	game.input.keyboard.quit_pressed = true
	main.resolve_actions(&game)
	testing.expect_value(t, game.actions.quit_game, true)
}

@(test)
resolve_actions_toggle_pause_test :: proc(t: ^testing.T) {
	game := main.init_game()
	defer main.destroy_game(&game)

	game.input.keyboard.pause_pressed = false
	main.resolve_actions(&game)
	testing.expect_value(t, game.actions.toggle_pause, false)

	game.input.keyboard.pause_pressed = true
	main.resolve_actions(&game)
	testing.expect_value(t, game.actions.toggle_pause, true)
}
