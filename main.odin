package main

import rl "vendor:raylib"

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080
VIEWPORT_WIDTH :: 1920 / 2
VIEWPORT_HEIGHT :: 1080 / 2

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
