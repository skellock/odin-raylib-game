package main

import "core:testing"

@(test)
cycle_dot_color_test :: proc(t: ^testing.T) {
	dot := init_dot()
	defer destroy_dot(&dot)

	testing.expect_value(t, dot.color, DotColor.Yellow)
	cycle_dot_color(&dot)
	testing.expect_value(t, dot.color, DotColor.Red)
	cycle_dot_color(&dot)
	cycle_dot_color(&dot)
	testing.expect_value(t, dot.color, DotColor.Yellow)
}

@(test)
update_dot_reshuffle_cycles_color_test :: proc(t: ^testing.T) {
	dot := init_dot()
	defer destroy_dot(&dot)

	input: Input
	actions: Actions

	testing.expect_value(t, dot.color, DotColor.Yellow)

	actions.reshuffle = true
	update_dot(&dot, input, actions)
	testing.expect_value(t, dot.color, DotColor.Red)

	actions.reshuffle = false
	update_dot(&dot, input, actions)
	testing.expect_value(t, dot.color, DotColor.Red)
}

@(test)
update_dot_move_dot_sets_tween_test :: proc(t: ^testing.T) {
	dot := init_dot()
	defer destroy_dot(&dot)

	input: Input
	actions: Actions

	testing.expect_value(t, dot.x, f32(0))
	testing.expect_value(t, dot.y, f32(0))

	input.mouse.world_x = 100
	input.mouse.world_y = 200
	actions.move_dot = {true, input.mouse.world_x, input.mouse.world_y}
	update_dot(&dot, input, actions)

	// after a move_dot action, tweens are created but dot hasn't moved yet without dt
	testing.expect_value(t, dot.x, f32(0))
	testing.expect_value(t, dot.y, f32(0))

	// simulate time passing to let tweens update
	actions.move_dot = {false, 0, 0}
	input.time.dt = 1.0
	update_dot(&dot, input, actions)

	// dot should have moved toward the target
	testing.expect(t, dot.x > 0, "dot.x should have moved toward target")
	testing.expect(t, dot.y > 0, "dot.y should have moved toward target")
}
