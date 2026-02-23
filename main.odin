package main

import rl "vendor:raylib"

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080
VIEWPORT_WIDTH :: 1920 / 2
VIEWPORT_HEIGHT :: 1080 / 2

main :: proc() {
	// setup raylib
	rl.SetTraceLogLevel(.NONE)
	rl.SetConfigFlags({.VSYNC_HINT, .MSAA_4X_HINT})
	rl.SetTargetFPS(500)

	// setup audio device
	rl.InitAudioDevice()
	rl.SetMasterVolume(0)
	defer rl.CloseAudioDevice()

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

	destroy_game(&game)
}
