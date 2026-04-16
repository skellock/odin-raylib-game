#+feature using-stmt
package tests

import main "../src"
import "core:testing"
import rl "vendor:raylib"

@(test)
dot_cycle_color_test :: proc(t: ^testing.T) {
	using main, testing

	dot := dot_init()
	defer dot_destroy(&dot)

	expect_value(t, dot.color, DotColor.Yellow)
	dot_cycle_color(&dot)
	expect_value(t, dot.color, DotColor.Red)
	dot_cycle_color(&dot)
	dot_cycle_color(&dot)
	expect_value(t, dot.color, DotColor.Yellow)
}

@(test)
dot_update_reshuffle_cycles_color_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	expect_value(t, game.dot.color, DotColor.Yellow)

	game.actions.reshuffle = true
	dot_update(&game)
	expect_value(t, game.dot.color, DotColor.Red)

	game.actions.reshuffle = false
	dot_update(&game)
	expect_value(t, game.dot.color, DotColor.Red)
}

@(test)
dot_update_move_dot_sets_tween_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	expect_value(t, game.dot.current_pos.x, f32(0))
	expect_value(t, game.dot.current_pos.y, f32(0))

	game.mouse.world_pos = {100, 200}
	game.actions.move_dot = {true, game.mouse.world_pos}
	dot_update(&game)

	// after a move_dot action, tweens are created but dot hasn't moved yet without dt
	expect_value(t, game.dot.current_pos.x, f32(0))
	expect_value(t, game.dot.current_pos.y, f32(0))

	// simulate time passing to let tweens update
	game.actions.move_dot = {}
	game.time.dt = 1.0
	dot_update(&game)

	// dot should have moved toward the target
	expect(t, game.dot.current_pos.x > 0, "dot.current_pos.x should have moved toward target")
	expect(t, game.dot.current_pos.y > 0, "dot.current_pos.y should have moved toward target")
}

@(test)
dot_update_targeting_pos_test :: proc(t: ^testing.T) {
	using main, testing

	game := game_init()
	defer game_destroy(&game)

	expect_value(t, game.dot.targeting_pos, rl.Vector2{0, 0})

	game.mouse.world_pos = {50, 75}
	dot_update(&game)
	expect_value(t, game.dot.targeting_pos, rl.Vector2{50, 75})

	game.mouse.world_pos = {200, 300}
	dot_update(&game)
	expect_value(t, game.dot.targeting_pos, rl.Vector2{200, 300})
}
