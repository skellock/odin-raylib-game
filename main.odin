package main

import rl "vendor:raylib"

main :: proc() {
	// setup state
	game := init_game()
	input := init_input()

	// setup raylib
	rl.SetTraceLogLevel(.NONE)
	rl.SetTargetFPS(60)

	// setup window
	rl.InitWindow(1024, 768, "OdinRaylib")
	defer rl.CloseWindow()

	// main game loop -- continues until <esc> or window closed
	for !rl.WindowShouldClose() {
		capture_input(&input)
		update(&game, &input)
		draw(&game, &input)

		free_all(context.temp_allocator) // free any frame allocations
	}
}
