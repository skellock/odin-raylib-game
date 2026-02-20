package main

update :: proc(game: ^Game, input: ^Input) {
	update_dot(&game.dot, input)
}
