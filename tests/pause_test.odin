package tests

import main ".."
import "core:testing"

@(test)
update_pause_toggles_test :: proc(t: ^testing.T) {
	g := main.init_game()
	defer main.destroy_game(&g)

	actions: main.Actions

	testing.expect_value(t, g.paused, false)

	actions.toggle_pause = true
	main.update_pause(&g, actions)
	testing.expect_value(t, g.paused, true)

	actions.toggle_pause = true
	main.update_pause(&g, actions)
	testing.expect_value(t, g.paused, false)
}

@(test)
update_pause_no_toggle_test :: proc(t: ^testing.T) {
	g := main.init_game()
	defer main.destroy_game(&g)

	actions: main.Actions

	actions.toggle_pause = false
	main.update_pause(&g, actions)
	testing.expect_value(t, g.paused, false)

	// manually pause, then confirm no-op when toggle_pause is false
	g.paused = true
	actions.toggle_pause = false
	main.update_pause(&g, actions)
	testing.expect_value(t, g.paused, true)
}
