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
		color = .Yellow,
	}
}

update_game_state :: proc(game: ^GameState, input: ^InputState) {
	game.big = input.mouse.x < input.screen_width / 2

	if input.mouse.left_pressed {
		game.color = next_color(game.color)
	}
}

@(private)
next_color :: proc(color: DotColor) -> DotColor {
	current := int(color) >= len(DotColor) - 1 ? 0 : int(color) + 1
	return DotColor(current)
}
