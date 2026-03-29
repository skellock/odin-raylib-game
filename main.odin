package main

import "core:log"
import "core:mem"
import rl "vendor:raylib"

// HACK: prevent unused variable warning while not in debug mode
when !ODIN_DEBUG {
	_ :: mem
}

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080
VIEWPORT_WIDTH :: 1920
VIEWPORT_HEIGHT :: 1080

assets: Assets

main :: proc() {
	// setup a console logger
	context.logger = log.create_console_logger()
	defer log.destroy_console_logger(context.logger)

	// setup memory tracking in debug mode
	when ODIN_DEBUG {
		tracking_allocator: mem.Tracking_Allocator
		mem.tracking_allocator_init(&tracking_allocator, context.allocator)
		context.allocator = mem.tracking_allocator(&tracking_allocator)

		defer {
			for _, value in tracking_allocator.allocation_map {
				log.errorf("%v: Leaked %v bytes\n", value.location, value.size)
			}
			mem.tracking_allocator_destroy(&tracking_allocator)
		}
	}

	// setup raylib
	rl.SetTraceLogLevel(.NONE)
	rl.SetConfigFlags({.MSAA_4X_HINT, .WINDOW_HIGHDPI})
	rl.SetTargetFPS(144)
	rl.SetExitKey(.KEY_NULL)
	rl.ToggleFullscreen()

	// setup audio device
	rl.InitAudioDevice()
	rl.SetMasterVolume(0)
	defer rl.CloseAudioDevice()

	// setup window
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Game")
	defer rl.CloseWindow()

	// prepare the assets
	assets = init_assets()
	defer destroy_assets(&assets)

	// prepare the game
	game := init_game()
	defer destroy_game(&game)

	input := Input{}
	actions := Actions{}

	play_music(&assets.music)

	// main game loop
	for {
		// free the temp allocator each loop
		defer free_all(context.temp_allocator)

		// jet if the window is closed
		if rl.WindowShouldClose() do break

		resolve_input(&input, game)
		resolve_actions(&actions, game, input)

		// jet if the quit_game action is triggered
		if actions.quit_game do break

		update(&game, input, actions)
		draw(game, input)
	}
}

// The main update statement called once per frame.
update :: proc(game: ^Game, input: Input, actions: Actions) {
	update_pause(game, actions)
	update_music(&assets.music, game)

	if game.paused do return

	update_dot(&game.dot, input, actions)
	update_card_view_positions(game)
	update_tooltip(game, input)
	update_reshuffler(game, input, actions)
}

// The main drawing function called once per frame.
draw :: proc(game: Game, input: Input) {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.BeginMode2D(game.camera)
	defer rl.EndMode2D()

	draw_background(input)
	draw_cards(game)
	draw_poker_hand_type_text(game, input)
	draw_poker_odds(game)
	draw_dot(game, input)
	draw_reshuffler(game, input)
	draw_tooltip(game)
	draw_pause(game, input)
	draw_debug(input)
	draw_cursor(game)
}

draw_cursor :: proc(game: Game) {
	if game.hovered_card < 0 {
		rl.SetMouseCursor(.DEFAULT)
	} else {
		rl.SetMouseCursor(.POINTING_HAND)
	}
}
