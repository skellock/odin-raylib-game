#+feature using-stmt
package tests

import main ".."
import "core:testing"

@(test)
update_pause_toggles_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	testing.expect_value(t, game.paused, false)

	game.actions.toggle_pause = true
	update_pause(&game)
	testing.expect_value(t, game.paused, true)

	game.actions.toggle_pause = true
	update_pause(&game)
	testing.expect_value(t, game.paused, false)
}

@(test)
update_pause_no_toggle_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	game.actions.toggle_pause = false
	update_pause(&game)
	testing.expect_value(t, game.paused, false)

	// manually pause, then confirm no-op when toggle_pause is false
	game.paused = true
	game.actions.toggle_pause = false
	update_pause(&game)
	testing.expect_value(t, game.paused, true)
}
