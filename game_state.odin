package main

DotColor :: enum {
	Yellow,
	Red,
	Green,
}

GameState :: struct {
	big:   bool,
	color: DotColor,
}

new_game_state :: proc() -> GameState {
	state := GameState{}
	reset_game_state(&state)
	return state
}

reset_game_state :: proc(state: ^GameState) {
	state^ = GameState {
		big   = false,
		color = DotColor.Yellow,
	}
}

update_game_state :: proc(state: ^GameState, input: ^InputState) {
	state.big = input.mouse_x < input.screen_width / 2

	if input.left_mouse_pressed {
		state.color = next_color(state.color)
	}
}

@(private)
next_color :: proc(color: DotColor) -> DotColor {
	current := int(color) >= len(DotColor) - 1 ? 0 : int(color) + 1
	return DotColor(current)
}
