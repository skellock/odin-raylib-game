package main

import rl "vendor:raylib"

main :: proc() {
	// setup state
	game_state := new_game_state()
	draw_state := new_draw_state()
	input_state: InputState

	// setup raylib
	rl.InitWindow(1024, 768, "OdinRaylib")
	rl.SetTargetFPS(60)
	defer rl.CloseWindow()

	// main loop
	for !rl.WindowShouldClose() {
		free_all(context.temp_allocator)

		update_input_state(&input_state)
		update_game_state(&game_state, &input_state)
		update_draw_state(&draw_state, &game_state, &input_state)

		draw(&draw_state, &game_state, &input_state)
	}
}
