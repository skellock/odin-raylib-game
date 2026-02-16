package main

import rl "vendor:raylib"

draw_game :: proc(draw: ^DrawState, game: ^GameState, input: ^InputState) {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.SKYBLUE)

	x := input.screen_width / 2
	rl.DrawRectangle(0, 0, x, input.screen_height, rl.BLUE)
	rl.DrawRectangle(x - 1, 0, 2, input.screen_height, rl.ColorAlpha(rl.WHITE, 0.5))

	rl.DrawText("This is a test using Odin and Raylib!", 10, 10, 20, rl.WHITE)

	draw_dot(draw, game, input)
}

draw_dot :: proc(draw: ^DrawState, game: ^GameState, input: ^InputState) {
	dot_color: rl.Color

	switch game.color {
	case .Red:
		dot_color = rl.RED
	case .Green:
		dot_color = rl.GREEN
	case .Yellow:
		dot_color = rl.YELLOW
	}

	rl.DrawCircle(i32(draw.dot_x), i32(draw.dot_y), draw.current_dot_size, dot_color)
}
