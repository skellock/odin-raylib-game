package main

import rl "vendor:raylib"

state := GameState{}

main :: proc() {
	user_input: UserInput
	rl.InitWindow(1024, 768, "OdinRaylib")
	rl.SetTargetFPS(60)
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		free_all(context.temp_allocator)
		process_user_input(&user_input)
		update(user_input)
		draw(user_input)
	}
}

update :: proc(user_input: UserInput) {
	state.big = user_input.mouse_x < user_input.screen_width / 2
}

draw :: proc(user_input: UserInput) {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.SKYBLUE)

	x := user_input.screen_width / 2
	sh := user_input.screen_height
	rl.DrawRectangle(0, 0, x, sh, rl.BLUE)
	rl.DrawRectangle(x - 1, 0, 2, sh, rl.ColorAlpha(rl.WHITE, 0.5))

	rl.DrawText("This is a test using Odin and Raylib!", 10, 10, 20, rl.WHITE)


	rl.DrawCircle(user_input.mouse_x, user_input.mouse_y, state.big ? 20 : 10, rl.YELLOW)

	draw_debug()
}
