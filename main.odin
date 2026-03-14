package main

import rl "vendor:raylib"

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080
VIEWPORT_WIDTH :: 1920 / 2
VIEWPORT_HEIGHT :: 1080 / 2

main :: proc() {
	// setup raylib
	rl.SetTraceLogLevel(.NONE)
	rl.SetConfigFlags(
		{
			/*.VSYNC_HINT,*/
			.MSAA_4X_HINT,
		},
	)
	rl.SetTargetFPS(144)

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
	music := init_music()
	sounds := init_sounds()

	play_music(music)

	// main game loop -- continues until <esc> or window closed
	for !rl.WindowShouldClose() {
		capture_input(game, &input)
		update_music(&music)
		update_dot(&game.dot, input, sounds)
		update(&game, input)
		draw(game, input)
		free_all(context.temp_allocator)
	}

	destroy_game(&game)
	destroy_music(&music)
	destroy_sounds(&sounds)
}

// The main update statement called once per frame.
update :: proc(game: ^Game, input: Input) {
	update_card_view_positions(game.hand[:])
	update_tooltip(game, input)
	update_reshuffler(game, input)
}

// The main drawing function called once per frame.
draw :: proc(game: Game, input: Input) {
	rl.BeginDrawing()
	rl.BeginMode2D(game.camera)

	draw_background(input)
	draw_cards(game)
	draw_poker_hand_type_text(game, input)
	draw_poker_odds(game)
	draw_dot(game, input)
	draw_reshuffler(game, input)
	draw_tooltip(game)
	draw_debug(input)

	rl.EndMode2D()
	rl.EndDrawing()
}
