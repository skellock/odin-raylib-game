package main

import "core:log"
import "core:mem"
import rl "vendor:raylib"

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080

assets: Assets
tracking_allocator: mem.Tracking_Allocator

main :: proc() {
	// setup a console logger
	context.logger = log.create_console_logger()
	defer log.destroy_console_logger(context.logger)

	// setup memory tracking in debug mode
	when ODIN_DEBUG {
		mem.tracking_allocator_init(&tracking_allocator, context.allocator)
		context.allocator = mem.tracking_allocator(&tracking_allocator)

		defer {
			if len(tracking_allocator.allocation_map) == 0 {
				log.debug("No memory leaks detected 🎉.")
			} else {
				for _, value in tracking_allocator.allocation_map {
					log.errorf("%v: Leaked %v bytes\n", value.location, value.size)
				}
			}
			mem.tracking_allocator_destroy(&tracking_allocator)
		}
	}

	// setup raylib
	rl.SetTraceLogLevel(.NONE)
	rl.SetConfigFlags({.MSAA_4X_HINT, .WINDOW_HIGHDPI})
	rl.SetTargetFPS(144)

	// setup audio device
	rl.InitAudioDevice()
	rl.SetMasterVolume(0)
	defer rl.CloseAudioDevice()

	// setup window
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Game")
	defer rl.CloseWindow()

	// configure raylib settings that should be set after window initialization
	rl.SetExitKey(.KEY_NULL)
	// rl.ToggleFullscreen()

	// prepare the assets
	assets = assets_init()
	defer assets_destroy(&assets)

	// prepare the game
	game := game_init()
	defer game_destroy(&game)

	// HACK: extra steps so the tests don't rely on a Raylib window
	scarfy_load(&game.scarfy)
	tiling_load(&game.tiling)

	play_music(&assets.music)

	// main game loop
	for {
		// free the temp allocator each loop
		defer free_all(context.temp_allocator)

		// -- updates ---------------------------------------------------------------
		{
			// update the basic state that other update_* functions rely on
			time_update(&game)
			screen_update(&game)
			viewport_update(&game)
			keyboard_update(&game)
			mouse_update(&game)

			// determine what the user wants to do
			actions_update(&game)

			pause_update(&game)
			console_update(&game)
			music_update(&game)

			if game.actions.load_game { save_game_read(&game) }
			if game.actions.save_game { save_game_write(&game) }

			// skip game updates if we're paused
			if !game.paused {
				clock_update(&game)
				scarfy_update(&game)
				dot_update(&game)
				card_view_update_all_positions(&game)
				card_view_update_all_collisions(&game)
				tooltip_update(&game)
				reshuffler_update(&game)
			}
		}

		// -- drawing ---------------------------------------------------------------
		{
			rl.BeginDrawing()
			defer rl.EndDrawing()

			rl.BeginMode2D(game.camera)
			defer rl.EndMode2D()

			background_draw(&game)
			tiling_draw(&game)
			scarfy_draw(&game)
			card_view_draw_all(&game)
			poker_hand_draw_type_text(&game)
			poker_odds_draw(&game)
			dot_draw(&game)
			reshuffler_draw(&game)
			tooltip_draw(&game)
			clock_draw(&game)
			if game.paused { pause_draw(&game) }
			debug_draw(&game)
			cursor_draw(&game)
			console_draw(&game)
		}

		// -- quitting the game ------------------------------------------------------
		if game.actions.quit_game { break }
		if rl.WindowShouldClose() { break }
	}
}
