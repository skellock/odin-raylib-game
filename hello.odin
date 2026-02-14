package main

import rl "vendor:raylib"

main :: proc() {
	state := GameState{}
	input: Input
	rl.InitWindow(1024, 768, "OdinRaylib")
	rl.SetTargetFPS(60)
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		free_all(context.temp_allocator)

		process_user_input(&input)

		update(&state, input)
		draw(&state, input)
	}
}

update :: proc(state: ^GameState, input: Input) {
	state.big = input.mouse_x < input.screen_width / 2
}

draw :: proc(state: ^GameState, input: Input) {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.SKYBLUE)

	x := input.screen_width / 2
	sh := input.screen_height
	rl.DrawRectangle(0, 0, x, sh, rl.BLUE)
	rl.DrawRectangle(x - 1, 0, 2, sh, rl.ColorAlpha(rl.WHITE, 0.5))

	rl.DrawText("This is a test using Odin and Raylib!", 10, 10, 20, rl.WHITE)

	rl.DrawCircle(input.mouse_x, input.mouse_y, state.big ? 20 : 10, rl.YELLOW)

	draw_debug(input)
}
