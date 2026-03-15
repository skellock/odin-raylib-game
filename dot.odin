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
	color:  DotColor,
	size:   f32,
	x:      f32,
	y:      f32,
	tweens: ease.Flux_Map(f32),
}

init_dot :: proc() -> Dot {
	return Dot{color = .Yellow, size = NORMAL_DOT_SIZE, x = 0, y = 0, tweens = ease.flux_init(f32)}
}

update_dot :: proc(dot: ^Dot, input: Input, actions: Actions) {
	if actions.move_dot.active {
		move_dot_location(dot, actions.move_dot.pos)
	}

	if actions.reshuffle {
		cycle_dot_color(dot)
		play_sound(assets.sounds.blip)
	}

	update_dot_size(dot, input)
	update_dot_tweens(dot, input)
}

draw_dot :: proc(game: Game, input: Input) {
	dot := game.dot
	dot_color: rl.Color

	switch dot.color {
	case .Red:
		dot_color = rl.RED
	case .Green:
		dot_color = rl.GREEN
	case .Yellow:
		dot_color = rl.YELLOW
	}

	if !game.paused {
		rl.DrawLineEx({dot.x, dot.y}, input.mouse.world_pos, 2, rl.ColorAlpha(rl.WHITE, 0.25))
	}

	rl.DrawCircle(i32(dot.x), i32(dot.y), dot.size, dot_color)
}

@(private = "file")
update_dot_tweens :: proc(dot: ^Dot, input: Input) {
	ease.flux_update(&dot.tweens, f64(input.time.dt))
}

@(private = "file")
update_dot_size :: proc(dot: ^Dot, input: Input) {
	big := dot.x < f32(input.viewport.width / 2)
	to_size := f32(big ? BIG_DOT_SIZE : NORMAL_DOT_SIZE)

	dot.size = math.lerp(dot.size, to_size, DOT_GROW_SPEED * input.time.dt)
}

@(private = "file")
move_dot_location :: proc(dot: ^Dot, pos: rl.Vector2) {
	DURATION :: time.Millisecond * 500
	EASE :: ease.Ease.Quadratic_Out
	DELAY: f64 : 0

	_ = ease.flux_to(&dot.tweens, &dot.x, pos.x, EASE, DURATION, DELAY)
	_ = ease.flux_to(&dot.tweens, &dot.y, pos.y, EASE, DURATION, DELAY)
}

cycle_dot_color :: proc(dot: ^Dot) {
	current := int(dot.color)
	next_color := current >= len(DotColor) - 1 ? 0 : current + 1
	dot.color = DotColor(next_color)
}

destroy_dot :: proc(dot: ^Dot) {
	ease.flux_destroy(dot.tweens)
}
