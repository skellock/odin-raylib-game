package main

update :: proc(game: ^Game, input: ^Input) {
	update_music(&game.music)
	update_dot(&game.dot, input, &game.sounds)
}
