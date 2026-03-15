package main

import rl "vendor:raylib"

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080
VIEWPORT_WIDTH :: 1920 / 2
VIEWPORT_HEIGHT :: 1080 / 2

music: Music
sounds: Sounds
card_images: CardImages

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

	// initialize the assets
	card_images = init_card_images()
	music = init_music()
	sounds = init_sounds()

	game := init_game(card_images)
	input := init_input()

	play_music(&music)

	// main game loop -- continues until <esc> or window closed
	for !rl.WindowShouldClose() {
		capture_input(game, &input)
		update(&game, input, card_images)
		draw(game, input)
		free_all(context.temp_allocator)
	}

	destroy_card_images(&card_images)
	destroy_music(&music)
	destroy_sounds(&sounds)
	destroy_game(&game)
}

// The main update statement called once per frame.
update :: proc(game: ^Game, input: Input, card_images: CardImages) {
	update_music(&music)
	update_dot(&game.dot, input, &sounds)
	update_card_view_positions(game.card_views[:])
	update_tooltip(game, input)
	update_reshuffler(game, input, card_images)
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
