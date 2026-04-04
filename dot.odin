package main

import "core:math"
import "core:math/ease"
import "core:time"
import rl "vendor:raylib"

DOT_GROW_SPEED :: 10.0
NORMAL_DOT_SIZE :: 4.0
BIG_DOT_SIZE :: 10.0

DotColor :: enum {
	Yellow,
	Red,
	Green,
}

Dot :: struct {
	color:         DotColor,
	size:          f32,
	current_pos:   rl.Vector2,
	targeting_pos: rl.Vector2,
	tweens:        ease.Flux_Map(f32),
}

init_dot :: proc() -> Dot {
	return Dot{color = .Yellow, size = NORMAL_DOT_SIZE, tweens = ease.flux_init(f32)}
}

update_dot :: proc(game: ^Game) {
	if game.actions.move_dot.active {
		move_dot_location(&game.dot, game.actions.move_dot.pos)
	}

	if game.actions.reshuffle {
		cycle_dot_color(&game.dot)
		play_sound(assets.sounds.blip)
	}

	game.dot.targeting_pos = game.mouse.world_pos
	update_dot_size(game)
	update_dot_tweens(game)
}

get_dot_drawing_color :: proc(game: ^Game) -> rl.Color {
	switch game.dot.color {
	case .Red:
		return rl.RED
	case .Green:
		return rl.GREEN
	case .Yellow:
		return rl.YELLOW
	}
	return rl.WHITE
}

draw_dot :: proc(game: ^Game) {
	dot := game.dot
	dot_color := get_dot_drawing_color(game)
	if !game.console.active {
		rl.DrawLineEx(dot.current_pos, dot.targeting_pos, 2, rl.ColorAlpha(rl.WHITE, 0.25))
	}
	rl.DrawCircleV(dot.current_pos, dot.size, dot_color)
}

@(private = "file")
update_dot_tweens :: proc(game: ^Game) {
	ease.flux_update(&game.dot.tweens, f64(game.time.dt))
}

@(private = "file")
update_dot_size :: proc(game: ^Game) {
	big := game.dot.current_pos.x < f32(game.viewport.width / 2)
	to_size := f32(big ? BIG_DOT_SIZE : NORMAL_DOT_SIZE)

	game.dot.size = math.lerp(game.dot.size, to_size, DOT_GROW_SPEED * game.time.dt)
}

@(private = "file")
move_dot_location :: proc(dot: ^Dot, pos: rl.Vector2) {
	DURATION :: time.Millisecond * 500
	EASE :: ease.Ease.Quadratic_Out
	DELAY: f64 : 0

	_ = ease.flux_to(&dot.tweens, &dot.current_pos.x, pos.x, EASE, DURATION, DELAY)
	_ = ease.flux_to(&dot.tweens, &dot.current_pos.y, pos.y, EASE, DURATION, DELAY)
}

cycle_dot_color :: proc(dot: ^Dot) {
	current := int(dot.color)
	next_color := current >= len(DotColor) - 1 ? 0 : current + 1
	dot.color = DotColor(next_color)
}

destroy_dot :: proc(dot: ^Dot) {
	ease.flux_destroy(dot.tweens)
}

clear_dot_tweens :: proc(game: ^Game) {
	ease.flux_clear(&game.dot.tweens)
}
