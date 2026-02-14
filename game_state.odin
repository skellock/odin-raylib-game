package main

DotColor :: enum {
	Yellow,
	Red,
	Green,
}

GameState :: struct {
	// Is the dot really big?
	big:   bool,
	// The colour of the dot
	color: DotColor,
}

reset_game :: proc(state: ^GameState) {
	state^ = GameState {
		big   = false,
		color = DotColor.Yellow,
	}
}

update_game :: proc(state: ^GameState, input: Input) {
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
