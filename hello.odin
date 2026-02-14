package main

import rl "vendor:raylib"

main :: proc() {
	game_state := GameState{}
	reset_game(&game_state)

	draw_state := DrawState{}
	reset_draw_state(&draw_state)

	input: Input
	rl.InitWindow(1024, 768, "OdinRaylib")
	rl.SetTargetFPS(60)
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		free_all(context.temp_allocator)

		process_input(&input)
		update_game(&game_state, &input)
		update_draw_state(&draw_state, &game_state, &input)
		draw(&draw_state, &game_state, &input)
	}
}
