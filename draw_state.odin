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

reset_draw_state :: proc(draw: ^DrawState) {
	draw^ = DrawState{}
}

update_draw_state :: proc(draw: ^DrawState, game: ^GameState, input: ^InputState) {
	draw.current_dot_size = math.lerp(
		draw.current_dot_size,
		game.big ? NORMAL_DOT_SIZE : BIG_DOT_SIZE,
		DOT_GROW_SPEED * input.delta,
	)
}
