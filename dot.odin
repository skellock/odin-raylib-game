package main

import "core:math"
import "core:math/ease"
import "core:time"
import rl "vendor:raylib"

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

update_dot :: proc(dot: ^Dot, input: ^Input) {
	if input.mouse.left_pressed {
		move_dot_location(dot, input)
	}

	if input.mouse.right_pressed {
		cycle_dot_color(dot)
	}

	update_dot_size(dot, input)
	update_dot_tweens(dot, input)
}

draw_dot :: proc(dot: ^Dot, input: ^Input) {
	dot_color: rl.Color

	switch dot.color {
	case .Red:
		dot_color = rl.RED
	case .Green:
		dot_color = rl.GREEN
	case .Yellow:
		dot_color = rl.YELLOW
	}

	rl.DrawLineEx(
		{dot.x, dot.y},
		{f32(input.mouse.world_x), f32(input.mouse.world_y)},
		2,
		rl.ColorAlpha(rl.WHITE, 0.25),
	)

	rl.DrawCircle(i32(dot.x), i32(dot.y), dot.size, dot_color)
}

@(private = "file")
update_dot_tweens :: proc(dot: ^Dot, input: ^Input) {
	ease.flux_update(&dot.tweens, input.time.frame64)
}

@(private = "file")
update_dot_size :: proc(dot: ^Dot, input: ^Input) {
	big := dot.x < f32(input.viewport.width / 2)
	to_size := f32(big ? BIG_DOT_SIZE : NORMAL_DOT_SIZE)

	dot.size = math.lerp(dot.size, to_size, DOT_GROW_SPEED * input.time.frame32)
}

@(private = "file")
move_dot_location :: proc(dot: ^Dot, input: ^Input) {
	DURATION :: time.Millisecond * 500
	EASE :: ease.Ease.Quadratic_Out
	DELAY: f64 : 0

	_ = ease.flux_to(&dot.tweens, &dot.x, f32(input.mouse.world_x), EASE, DURATION, DELAY)
	_ = ease.flux_to(&dot.tweens, &dot.y, f32(input.mouse.world_y), EASE, DURATION, DELAY)
}

@(private = "file")
cycle_dot_color :: proc(dot: ^Dot) {
	current := int(dot.color)
	next_color := current >= len(DotColor) - 1 ? 0 : current + 1
	dot.color = DotColor(next_color)
}
