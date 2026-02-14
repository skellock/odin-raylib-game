package main

import rl "vendor:raylib"

main :: proc() {
	game_state := new_game_state()
	draw_state := new_draw_state()

	input: Input
	rl.InitWindow(1024, 768, "OdinRaylib")
	rl.SetTargetFPS(60)
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		free_all(context.temp_allocator)

		process_input(&input)
		update_game_state(&game_state, &input)
		update_draw_state(&draw_state, &game_state, &input)
		draw(&draw_state, &game_state, &input)
	}
}
