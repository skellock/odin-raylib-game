package main

import rl "vendor:raylib"

WINDOW_WIDTH :: 1024
WINDOW_HEIGHT :: 1024
VIEWPORT_WIDTH :: 512
VIEWPORT_HEIGHT :: 512

main :: proc() {
	// setup raylib
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.SetTraceLogLevel(.NONE)
	rl.SetTargetFPS(500)

	// setup window
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Game")
	defer rl.CloseWindow()

	// setup state
	game := init_game()
	input := init_input()

	// main game loop -- continues until <esc> or window closed
	for !rl.WindowShouldClose() {
		capture_input(&game, &input)
		update(&game, &input)
		draw(&game, &input)

		free_all(context.temp_allocator) // free any frame allocations
	}
}
