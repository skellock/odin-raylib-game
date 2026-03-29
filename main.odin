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

	play_music(&assets.music)

	// main game loop
	for {
		// free the temp allocator each loop
		defer free_all(context.temp_allocator)

		// -- updates
		update_input(&game)
		update_actions(&game)
		update_pause(&game)
		update_music(&assets.music, &game)
		if !game.paused {
			update_dot(&game)
			update_card_view_positions(&game)
			update_tooltip(&game)
			update_reshuffler(&game)
		}

		// -- draws
		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.BeginMode2D(game.camera)
		defer rl.EndMode2D()
		draw_background(&game)
		draw_cards(&game)
		draw_poker_hand_type_text(&game)
		draw_poker_odds(&game)
		draw_dot(&game)
		draw_reshuffler(&game)
		draw_tooltip(&game)
		draw_pause(&game)
		draw_debug(&game)
		draw_cursor(&game)

		// quit the game?
		if game.actions.quit_game do break
		if rl.WindowShouldClose() do break
	}
}
