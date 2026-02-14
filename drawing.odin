package main

import rl "vendor:raylib"

draw :: proc(draw_state: ^DrawState, game_state: ^GameState, input: ^Input) {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.SKYBLUE)

	x := input.screen_width / 2
	rl.DrawRectangle(0, 0, x, input.screen_height, rl.BLUE)
	rl.DrawRectangle(x - 1, 0, 2, input.screen_height, rl.ColorAlpha(rl.WHITE, 0.5))

	rl.DrawText("This is a test using Odin and Raylib!", 10, 10, 20, rl.WHITE)

	draw_dot(draw_state, game_state, input)
	draw_debug(input)
}

draw_dot :: proc(draw_state: ^DrawState, game_state: ^GameState, input: ^Input) {
	dot_color: rl.Color

	switch game_state.color {
	case .Red:
		dot_color = rl.RED
	case .Green:
		dot_color = rl.GREEN
	case .Yellow:
		dot_color = rl.YELLOW
	}

	rl.DrawCircle(input.mouse_x, input.mouse_y, draw_state.current_dot_size, dot_color)
}
