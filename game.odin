package main

Game :: struct {
	dot: Dot,
}

init_game :: proc() -> Game {
	return Game{dot = init_dot()}
}
