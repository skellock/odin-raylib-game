package main

import rl "vendor:raylib"

draw :: proc(draw_state: ^DrawState, game_state: ^GameState, input_state: ^InputState) {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.SKYBLUE)

	x := input_state.screen_width / 2
	rl.DrawRectangle(0, 0, x, input_state.screen_height, rl.BLUE)
	rl.DrawRectangle(x - 1, 0, 2, input_state.screen_height, rl.ColorAlpha(rl.WHITE, 0.5))

	rl.DrawText("This is a test using Odin and Raylib!", 10, 10, 20, rl.WHITE)

	draw_dot(draw_state, game_state, input_state)
	draw_debug(input_state)
}

draw_dot :: proc(draw_state: ^DrawState, game_state: ^GameState, input_state: ^InputState) {
	dot_color: rl.Color

	switch game_state.color {
	case .Red:
		dot_color = rl.RED
	case .Green:
		dot_color = rl.GREEN
	case .Yellow:
		dot_color = rl.YELLOW
	}

	rl.DrawCircle(input_state.mouse_x, input_state.mouse_y, draw_state.current_dot_size, dot_color)
}
