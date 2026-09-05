package main

import "core:log"
import "core:mem"
import rl "vendor:raylib"

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
	rl.SetTraceLogLevel(.WARNING)
	rl.SetConfigFlags({.MSAA_4X_HINT, .WINDOW_HIGHDPI})
	rl.SetTargetFPS(144)

	// setup audio device
	rl.InitAudioDevice()
	rl.SetMasterVolume(0)
	defer rl.CloseAudioDevice()

	// setup window
	WINDOW_WIDTH :: i32(1920)
	WINDOW_HEIGHT :: i32(1080)
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Game")
	defer rl.CloseWindow()

	// An oversized window can start off-screen; fit and center it on the monitor.
	monitor := rl.GetCurrentMonitor()
	monitor_pos := rl.GetMonitorPosition(monitor)
	monitor_width := rl.GetMonitorWidth(monitor)
	monitor_height := rl.GetMonitorHeight(monitor)
	window_width := min(WINDOW_WIDTH, monitor_width * 9 / 10)
	window_height := min(WINDOW_HEIGHT, monitor_height * 9 / 10)
	rl.SetWindowPosition(i32(monitor_pos.x), i32(monitor_pos.y))
	rl.SetWindowSize(window_width, window_height)
	rl.SetWindowPosition(
		i32(monitor_pos.x) + (monitor_width - window_width) / 2,
		i32(monitor_pos.y) + (monitor_height - window_height) / 2,
	)

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

	keyboard := Keyboard{}
	mouse := Mouse{}

	// main game loop
	for {
		// free the temp allocator each loop
		defer free_all(context.temp_allocator)

		// -- updates ---------------------------------------------------------------
		{
			// process input
			keyboard_update(&keyboard)
			mouse_update(&mouse, game.camera)

			// determine what the user wants to do
			actions_update(&game, keyboard, mouse)

			// are we toggling pause this frame?
			if game.actions.toggle_pause {
				game.paused = !game.paused
				music_toggle(game.paused)
			}

			music_update()
			console_update(&game.console, game.actions, mouse)
			save_game_update(&game)

			// skip game updates if we're paused
			if !game.paused {
				clock_update(&game.clock)
				scarfy_update(&game.scarfy)
				dot_update(&game.dot, game.actions, mouse)
				card_view_update_all_positions(&game)
				card_view_update_all_collisions(&game)
				tooltip_update(&game, mouse)
				reshuffler_update(&game, mouse)
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
			reshuffler_draw(game.reshuffler)
			tooltip_draw(&game)
			clock_draw(&game)
			if game.paused { pause_draw() }
			debug_draw(&game)
			cursor_draw(game)
			console_draw(game.console)
		}

		// -- quitting the game ------------------------------------------------------
		if game.actions.quit_game { break }
		if rl.WindowShouldClose() { break }
	}
}
