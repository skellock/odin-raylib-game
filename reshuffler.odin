package main

import "core:fmt"
import rl "vendor:raylib"

RESHUFFLE_COOLDOWN :: f32(3.0)

Reshuffler :: struct {
	cooldown: Timer,
}

init_reshuffler :: proc() -> Reshuffler {
	return Reshuffler{cooldown = init_timer(RESHUFFLE_COOLDOWN, one_shot = true)}
}

update_reshuffler :: proc(game: ^Game, input: Input) {
	update_timer(&game.reshuffler.cooldown, input.time.dt)

	if input.mouse.right_pressed && !game.reshuffler.cooldown.active {
		shuffle_deck(&game.deck)
		deal_to_hand(game)
		start_timer(&game.reshuffler.cooldown)
	}
}

draw_reshuffler :: proc(game: Game, input: Input) {
	cooldown := game.reshuffler.cooldown
	if !cooldown.active do return

	remaining := cooldown.duration - cooldown.elapsed
	text := fmt.ctprintf("%.1f", remaining)

	FONT_SIZE :: i32(7)
	OFFSET_Y :: i32(12)

	x := input.mouse.world_x
	y := input.mouse.world_y + OFFSET_Y
	rl.DrawText(text, x, y, FONT_SIZE, rl.WHITE)
}

destroy_reshuffler :: proc(reshuffler: ^Reshuffler) {
	destroy_timer(&reshuffler.cooldown)
}
