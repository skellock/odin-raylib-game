#+feature using-stmt
package tests

import main "../src"
import "core:testing"

@(test)
pause_update_toggles_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	expect_value(t, game.paused, false)

	game.actions.toggle_pause = true
	pause_update(&game)
	expect_value(t, game.paused, true)

	game.actions.toggle_pause = true
	pause_update(&game)
	expect_value(t, game.paused, false)
}

@(test)
pause_update_no_toggle_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	game.actions.toggle_pause = false
	pause_update(&game)
	expect_value(t, game.paused, false)

	// manually pause, then confirm no-op when toggle_pause is false
	game.paused = true
	game.actions.toggle_pause = false
	pause_update(&game)
	expect_value(t, game.paused, true)
}
