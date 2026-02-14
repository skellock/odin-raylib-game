package main

import "core:math"

DrawState :: struct {
	current_dot_size: f32,
}

new_draw_state :: proc() -> DrawState {
	state := DrawState{}
	reset_draw_state(&state)
	return state
}

reset_draw_state :: proc(draw_state: ^DrawState) {
	draw_state^ = DrawState{}
}

update_draw_state :: proc(
	draw_state: ^DrawState,
	game_state: ^GameState,
	input_state: ^InputState,
) {
	DOT_GROW_SPEED :: 10.0
	NORMAL_DOT_SIZE :: 10.0
	BIG_DOT_SIZE :: 20.0

	draw_state.current_dot_size = math.lerp(
		draw_state.current_dot_size,
		game_state.big ? NORMAL_DOT_SIZE : BIG_DOT_SIZE,
		DOT_GROW_SPEED * input_state.delta,
	)
}
