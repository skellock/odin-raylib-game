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

	// HACK: extra steps so the tests don't rely on a Raylib window
	load_scarfy(&game.scarfy)
	load_tiling(&game.tiling)

	play_music(&assets.music)

	// main game loop
	for {
		// free the temp allocator each loop
		defer free_all(context.temp_allocator)

		// -- updates ---------------------------------------------------------------
		{
			// update the basic state that other update_* functions rely on
			update_time(&game)
			update_screen(&game)
			update_viewport(&game)
			update_keyboard(&game)
			update_mouse(&game)

			// determine what the user wants to do
			update_actions(&game)

			// update the pause state
			update_pause(&game)

			update_music(&game)

			// skip game updates if we're paused
			if !game.paused {
				update_clock(&game)
				update_scarfy(&game)
				update_dot(&game)
				update_card_view_positions(&game)
				update_card_view_collisions(&game)
				update_tooltip(&game)
				update_reshuffler(&game)
			}
		}

		// -- drawing ---------------------------------------------------------------
		{
			rl.BeginDrawing()
			defer rl.EndDrawing()
			rl.BeginMode2D(game.camera)
			defer rl.EndMode2D()

			draw_background(&game)
			draw_tiling(&game)
			draw_scarfy(&game)
			draw_card_views(&game)
			draw_poker_hand_type_text(&game)
			draw_poker_odds(&game)
			draw_dot(&game)
			draw_reshuffler(&game)
			draw_tooltip(&game)
			if game.paused {
				draw_paused(&game)
			}
			draw_clock(&game)
			draw_debug(&game)
			draw_cursor(&game)
		}

		// -- quitting the game ------------------------------------------------------
		{
			if game.actions.quit_game do break
			if rl.WindowShouldClose() do break
		}
	}
}
