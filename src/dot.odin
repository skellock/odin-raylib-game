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

dot_init :: proc() -> Dot {
	return Dot{color = .Yellow, size = NORMAL_DOT_SIZE, tweens = ease.flux_init(f32)}
}

dot_update :: proc(game: ^Game) {
	if game.actions.move_dot.active {
		dot_move_location(&game.dot, game.actions.move_dot.pos)
	}

	if game.actions.reshuffle {
		dot_cycle_color(&game.dot)
		sounds_play(assets.sounds.blip)
	}

	game.dot.targeting_pos = game.mouse.world_pos
	dot_update_size(game)
	dot_update_tweens(game)
}

dot_get_drawing_color :: proc(game: ^Game) -> rl.Color {
	switch game.dot.color {
	case .Red: return rl.RED
	case .Green: return rl.GREEN
	case .Yellow: return rl.YELLOW
	}
	return rl.WHITE
}

dot_draw :: proc(game: ^Game) {
	dot := game.dot
	dot_color := dot_get_drawing_color(game)
	if !game.console.active {
		rl.DrawLineEx(dot.current_pos, dot.targeting_pos, 2, rl.ColorAlpha(rl.WHITE, 0.25))
	}
	rl.DrawCircleV(dot.current_pos, dot.size, dot_color)
}

@(private = "file")
dot_update_tweens :: proc(game: ^Game) {
	ease.flux_update(&game.dot.tweens, f64(game.time.dt))
}

@(private = "file")
dot_update_size :: proc(game: ^Game) {
	big := game.dot.current_pos.x < f32(game.viewport.width / 2)
	to_size := f32(big ? BIG_DOT_SIZE : NORMAL_DOT_SIZE)

	game.dot.size = math.lerp(game.dot.size, to_size, DOT_GROW_SPEED * game.time.dt)
}

@(private = "file")
dot_move_location :: proc(dot: ^Dot, pos: rl.Vector2) {
	DURATION :: time.Millisecond * 500
	EASE :: ease.Ease.Quadratic_Out
	DELAY: f64 : 0

	_ = ease.flux_to(&dot.tweens, &dot.current_pos.x, pos.x, EASE, DURATION, DELAY)
	_ = ease.flux_to(&dot.tweens, &dot.current_pos.y, pos.y, EASE, DURATION, DELAY)
}

dot_cycle_color :: proc(dot: ^Dot) {
	current := int(dot.color)
	next_color := current >= len(DotColor) - 1 ? 0 : current + 1
	dot.color = DotColor(next_color)
}

dot_destroy :: proc(dot: ^Dot) {
	ease.flux_destroy(dot.tweens)
}

dot_clear_tweens :: proc(game: ^Game) {
	ease.flux_clear(&game.dot.tweens)
}
