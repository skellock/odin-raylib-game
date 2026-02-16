package main

import "core:math"
import "core:math/ease"
import "core:time"

DrawState :: struct {
	current_dot_size: f32,
	dot_x:            f32,
	dot_y:            f32,
	movements:        ease.Flux_Map(f32),
}

new_draw_state :: proc() -> DrawState {
	state := DrawState{}
	reset_draw_state(&state)
	return state
}

reset_draw_state :: proc(draw: ^DrawState) {
	draw.current_dot_size = NORMAL_DOT_SIZE
	draw.dot_x = 0
	draw.dot_y = 0
	draw.movements = ease.flux_init(f32)
}

update_draw_state :: proc(draw: ^DrawState, game: ^GameState, input: ^InputState) {
	// take action
	if input.mouse.left_pressed {
		update_dot_location(draw, input)
	}

	// update the movement animations
	ease.flux_update(&draw.movements, f64(input.delta))

	update_dot_size(draw, input)
}

@(private)
update_dot_size :: proc(draw: ^DrawState, input: ^InputState) {
	big := draw.dot_x < f32(input.screen_width / 2)
	to_size := f32(big ? BIG_DOT_SIZE : NORMAL_DOT_SIZE)

	draw.current_dot_size = math.lerp(draw.current_dot_size, to_size, DOT_GROW_SPEED * input.delta)
}

@(private)
update_dot_location :: proc(draw: ^DrawState, input: ^InputState) {
	DURATION :: time.Millisecond * 500
	EASE :: ease.Ease.Quadratic_Out
	DELAY: f64 : 0

	_ = ease.flux_to(&draw.movements, &draw.dot_x, f32(input.mouse.x), EASE, DURATION, DELAY)
	_ = ease.flux_to(&draw.movements, &draw.dot_y, f32(input.mouse.y), EASE, DURATION, DELAY)
}
