package tests

import main ".."
import "core:testing"
import rl "vendor:raylib"

@(test)
cycle_dot_color_test :: proc(t: ^testing.T) {
	dot := main.init_dot()
	defer main.destroy_dot(&dot)

	testing.expect_value(t, dot.color, main.DotColor.Yellow)
	main.cycle_dot_color(&dot)
	testing.expect_value(t, dot.color, main.DotColor.Red)
	main.cycle_dot_color(&dot)
	main.cycle_dot_color(&dot)
	testing.expect_value(t, dot.color, main.DotColor.Yellow)
}

@(test)
update_dot_reshuffle_cycles_color_test :: proc(t: ^testing.T) {
	dot := main.init_dot()
	defer main.destroy_dot(&dot)

	input: main.Input
	actions: main.Actions

	testing.expect_value(t, dot.color, main.DotColor.Yellow)

	actions.reshuffle = true
	main.update_dot(&dot, input, actions)
	testing.expect_value(t, dot.color, main.DotColor.Red)

	actions.reshuffle = false
	main.update_dot(&dot, input, actions)
	testing.expect_value(t, dot.color, main.DotColor.Red)
}

@(test)
update_dot_move_dot_sets_tween_test :: proc(t: ^testing.T) {
	dot := main.init_dot()
	defer main.destroy_dot(&dot)

	input: main.Input
	actions: main.Actions

	testing.expect_value(t, dot.current_pos.x, f32(0))
	testing.expect_value(t, dot.current_pos.y, f32(0))

	input.mouse.world_pos = {100, 200}
	actions.move_dot = {true, input.mouse.world_pos}
	main.update_dot(&dot, input, actions)

	// after a move_dot action, tweens are created but dot hasn't moved yet without dt
	testing.expect_value(t, dot.current_pos.x, f32(0))
	testing.expect_value(t, dot.current_pos.y, f32(0))

	// simulate time passing to let tweens update
	actions.move_dot = {}
	input.time.dt = 1.0
	main.update_dot(&dot, input, actions)

	// dot should have moved toward the target
	testing.expect(t, dot.current_pos.x > 0, "dot.current_pos.x should have moved toward target")
	testing.expect(t, dot.current_pos.y > 0, "dot.current_pos.y should have moved toward target")
}

@(test)
update_dot_targeting_pos_test :: proc(t: ^testing.T) {
	dot := main.init_dot()
	defer main.destroy_dot(&dot)

	input: main.Input
	actions: main.Actions

	testing.expect_value(t, dot.targeting_pos, rl.Vector2{0, 0})

	input.mouse.world_pos = {50, 75}
	main.update_dot(&dot, input, actions)
	testing.expect_value(t, dot.targeting_pos, rl.Vector2{50, 75})

	input.mouse.world_pos = {200, 300}
	main.update_dot(&dot, input, actions)
	testing.expect_value(t, dot.targeting_pos, rl.Vector2{200, 300})
}
