package main

import rl "vendor:raylib"

main :: proc() {
	// setup state
	game := new_game_state()
	draw := new_draw_state()
	input := new_input_state()

	// setup raylib
	rl.SetTraceLogLevel(.NONE)
	rl.SetTargetFPS(60)
	rl.InitWindow(1024, 768, "OdinRaylib")
	defer rl.CloseWindow()

	// main loop
	for !rl.WindowShouldClose() {
		defer free_all(context.temp_allocator)

		update_input_state(&input)
		update_game_state(&game, &input)
		update_draw_state(&draw, &game, &input)

		draw_game(&draw, &game, &input)
		draw_debug(&input)
	}
}
