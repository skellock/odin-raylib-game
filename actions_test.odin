package main

import "core:testing"

@(test)
resolve_actions_reshuffle_test :: proc(t: ^testing.T) {
	actions: Actions
	input: Input
	game := init_game()
	defer destroy_game(&game)

	input.mouse.right_pressed = false
	game.reshuffler.cooldown.active = false
	resolve_actions(&actions, game, input)
	testing.expect_value(t, actions.reshuffle, false)

	input.mouse.right_pressed = true
	game.reshuffler.cooldown.active = false
	resolve_actions(&actions, game, input)
	testing.expect_value(t, actions.reshuffle, true)

	input.mouse.right_pressed = true
	game.reshuffler.cooldown.active = true
	resolve_actions(&actions, game, input)
	testing.expect_value(t, actions.reshuffle, false)

	input.mouse.right_pressed = false
	game.reshuffler.cooldown.active = true
	resolve_actions(&actions, game, input)
	testing.expect_value(t, actions.reshuffle, false)
}

@(test)
resolve_actions_move_dot_test :: proc(t: ^testing.T) {
	actions: Actions
	input: Input
	game := init_game()
	defer destroy_game(&game)

	input.mouse.left_pressed = false
	resolve_actions(&actions, game, input)
	testing.expect_value(t, actions.move_dot.active, false)

	input.mouse.left_pressed = true
	input.mouse.world_x = 1.1
	input.mouse.world_y = 2.2
	resolve_actions(&actions, game, input)
	testing.expect_value(t, actions.move_dot, MoveDotAction{true, 1.1, 2.2})
}
