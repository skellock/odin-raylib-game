package main

import "core:testing"

@(test)
update_pause_toggles_test :: proc(t: ^testing.T) {
	game := init_game()
	defer destroy_game(&game)

	actions: Actions

	testing.expect_value(t, game.paused, false)

	actions.toggle_pause = true
	update_pause(&game, actions)
	testing.expect_value(t, game.paused, true)

	actions.toggle_pause = true
	update_pause(&game, actions)
	testing.expect_value(t, game.paused, false)
}

@(test)
update_pause_no_toggle_test :: proc(t: ^testing.T) {
	game := init_game()
	defer destroy_game(&game)

	actions: Actions

	actions.toggle_pause = false
	update_pause(&game, actions)
	testing.expect_value(t, game.paused, false)

	// manually pause, then confirm no-op when toggle_pause is false
	game.paused = true
	actions.toggle_pause = false
	update_pause(&game, actions)
	testing.expect_value(t, game.paused, true)
}
