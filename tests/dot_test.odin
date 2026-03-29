#+feature using-stmt
package tests

import main ".."
import "core:testing"
import rl "vendor:raylib"

@(test)
cycle_dot_color_test :: proc(t: ^testing.T) {
	using main
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
	using main
	game := init_game()
	defer destroy_game(&game)

	testing.expect_value(t, game.dot.color, DotColor.Yellow)

	game.actions.reshuffle = true
	update_dot(&game)
	testing.expect_value(t, game.dot.color, DotColor.Red)

	game.actions.reshuffle = false
	update_dot(&game)
	testing.expect_value(t, game.dot.color, DotColor.Red)
}

@(test)
update_dot_move_dot_sets_tween_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	testing.expect_value(t, game.dot.current_pos.x, f32(0))
	testing.expect_value(t, game.dot.current_pos.y, f32(0))

	game.mouse.world_pos = {100, 200}
	game.actions.move_dot = {true, game.mouse.world_pos}
	update_dot(&game)

	// after a move_dot action, tweens are created but dot hasn't moved yet without dt
	testing.expect_value(t, game.dot.current_pos.x, f32(0))
	testing.expect_value(t, game.dot.current_pos.y, f32(0))

	// simulate time passing to let tweens update
	game.actions.move_dot = {}
	game.time.dt = 1.0
	update_dot(&game)

	// dot should have moved toward the target
	testing.expect(
		t,
		game.dot.current_pos.x > 0,
		"dot.current_pos.x should have moved toward target",
	)
	testing.expect(
		t,
		game.dot.current_pos.y > 0,
		"dot.current_pos.y should have moved toward target",
	)
}

@(test)
update_dot_targeting_pos_test :: proc(t: ^testing.T) {
	using main
	game := init_game()
	defer destroy_game(&game)

	testing.expect_value(t, game.dot.targeting_pos, rl.Vector2{0, 0})

	game.mouse.world_pos = {50, 75}
	update_dot(&game)
	testing.expect_value(t, game.dot.targeting_pos, rl.Vector2{50, 75})

	game.mouse.world_pos = {200, 300}
	update_dot(&game)
	testing.expect_value(t, game.dot.targeting_pos, rl.Vector2{200, 300})
}
