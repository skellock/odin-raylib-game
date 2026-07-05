package main

import "core:log"
import "core:mem"
import rl "vendor:raylib"

GAME_WIDTH :: i32(1920)
GAME_HEIGHT :: i32(1080)
WINDOW_WIDTH :: GAME_WIDTH
WINDOW_HEIGHT :: GAME_HEIGHT

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

	music_play(&assets.music)

	// main game loop
	for {
		// free the temp allocator each loop
		defer free_all(context.temp_allocator)

		// -- updates ---------------------------------------------------------------
		{
			// update the basic state that other update_* functions rely on
			time_update(&game.time)
			keyboard_update(&game.keyboard)
			mouse_update(&game.mouse, game.camera)

			// determine what the user wants to do
			actions_update(&game)

			// are we toggling pause this frame?
			if game.actions.toggle_pause {
				game.paused = !game.paused
				music_toggle(game.paused)
			}

			music_update()
			console_update(&game)

			// load & save game stuff TODO: likely the wrong spot for this
			if game.actions.load_game {
				if save, ok := save_game_read(); ok {
					save_game_restore(save, &game)
				}
			}
			if game.actions.save_game {
				save_game_write(save_game_init(game))
			}

			// skip game updates if we're paused
			if !game.paused {
				clock_update(&game.clock)
				scarfy_update(&game.scarfy)
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

			background_draw()
			tiling_draw(game.tiling)
			scarfy_draw(game.scarfy, game.dot)
			card_view_draw_all(game)
			poker_hand_draw_type_text(game)
			poker_odds_draw(game)
			dot_draw(game.dot, !game.console.active)
			reshuffler_draw(game)
			tooltip_draw(game)
			clock_draw(game.clock)
			if game.paused { pause_draw() }
			debug_draw()
			cursor_draw(game)
			console_draw(game.console)
		}

		// -- quitting the game ------------------------------------------------------
		if game.actions.quit_game { break }
		if rl.WindowShouldClose() { break }
	}
}
