package main

import rl "vendor:raylib"

main :: proc() {
	// setup state
	game := init_game()
	input := init_input()

	// setup raylib
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.SetTraceLogLevel(.NONE)
	rl.SetTargetFPS(500)

	// setup window
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Game")
	defer rl.CloseWindow()

	// main game loop -- continues until <esc> or window closed
	for !rl.WindowShouldClose() {
		capture_input(&input, game.camera)
		update(&game, &input)
		draw(&game, &input)

		free_all(context.temp_allocator) // free any frame allocations
	}
}
