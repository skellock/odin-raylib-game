package main

import "core:log"
import "core:mem"
import rl "vendor:raylib"

// Hack to prevent unsused variable warning while not in debug mode.
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

		// example_memory_leak := make([]int, 4096)
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

	// initialize the assets
	assets = init_assets()

	game := init_game()
	input := Input{}
	actions := Actions{}

	play_music(&assets.music)

	rl.SetExitKey(.KEY_NULL)
	// main game loop -- continues until <esc> or window closed
	for !rl.WindowShouldClose() {
		resolve_input(&input, game)
		resolve_actions(&actions, game, input)
		if actions.quit_game do break
		update(&game, input, actions)
		draw(game, input)
		free_all(context.temp_allocator)
	}

	destroy_assets(&assets)
	destroy_game(&game)
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
	rl.BeginMode2D(game.camera)

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

	rl.EndMode2D()
	rl.EndDrawing()
}

draw_cursor :: proc(game: Game) {
	if game.hovered_card < 0 {
		rl.SetMouseCursor(.DEFAULT)
	} else {
		rl.SetMouseCursor(.POINTING_HAND)
	}
}
