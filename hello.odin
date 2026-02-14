package main

import rl "vendor:raylib"

main :: proc() {
	state := GameState{}
	reset_game(&state)

	input: Input
	rl.InitWindow(1024, 768, "OdinRaylib")
	rl.SetTargetFPS(60)
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		free_all(context.temp_allocator)

		process_input(&input)
		update_game(&state, input)
		draw(&state, input)
	}
}

draw :: proc(state: ^GameState, input: Input) {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.SKYBLUE)

	x := input.screen_width / 2
	rl.DrawRectangle(0, 0, x, input.screen_height, rl.BLUE)
	rl.DrawRectangle(x - 1, 0, 2, input.screen_height, rl.ColorAlpha(rl.WHITE, 0.5))

	rl.DrawText("This is a test using Odin and Raylib!", 10, 10, 20, rl.WHITE)

	dot_color: rl.Color
	switch state.color {
	case .Red:
		dot_color = rl.RED
	case .Green:
		dot_color = rl.GREEN
	case .Yellow:
		dot_color = rl.YELLOW
	}
	rl.DrawCircle(input.mouse_x, input.mouse_y, state.big ? 20 : 10, dot_color)

	draw_debug(input)
}
