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

dot_color_map := [DotColor]rl.Color {
	.Yellow = rl.YELLOW,
	.Red    = rl.RED,
	.Green  = rl.GREEN,
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
	dt := rl.GetFrameTime()
	if game.actions.move_dot.active {
		dot_move_location(&game.dot, game.actions.move_dot.pos)
	}

	if game.actions.reshuffle {
		dot_cycle_color(&game.dot)
		sounds_play(assets.sounds.blip)
	}

	game.dot.targeting_pos = game.mouse.world_pos
	dot_update_size(&game.dot, dt)
	dot_update_tweens(&game.dot, dt)
}

dot_get_drawing_color :: proc(self: Dot) -> rl.Color {
	return dot_color_map[self.color]
}

dot_draw :: proc(self: Dot, include_line: bool) {
	if include_line {
		rl.DrawLineEx(self.current_pos, self.targeting_pos, 2, rl.ColorAlpha(rl.WHITE, 0.25))
	}
	rl.DrawCircleV(self.current_pos, self.size, dot_get_drawing_color(self))
}

dot_update_tweens :: proc(self: ^Dot, dt: f32) {
	ease.flux_update(&self.tweens, f64(dt))
}

dot_update_size :: proc(self: ^Dot, dt: f32) {
	big := self.current_pos.x < f32(GAME_WIDTH / 2)
	to_size := f32(big ? BIG_DOT_SIZE : NORMAL_DOT_SIZE)

	self.size = math.lerp(self.size, to_size, DOT_GROW_SPEED * dt)
}

dot_move_location :: proc(self: ^Dot, pos: rl.Vector2) {
	DURATION :: time.Millisecond * 500
	EASE :: ease.Ease.Quadratic_Out
	DELAY: f64 : 0

	_ = ease.flux_to(&self.tweens, &self.current_pos.x, pos.x, EASE, DURATION, DELAY)
	_ = ease.flux_to(&self.tweens, &self.current_pos.y, pos.y, EASE, DURATION, DELAY)
}

dot_cycle_color :: proc(self: ^Dot) {
	current := int(self.color)
	next_color := current >= len(DotColor) - 1 ? 0 : current + 1
	self.color = DotColor(next_color)
}

dot_destroy :: proc(self: ^Dot) {
	ease.flux_destroy(self.tweens)
}

dot_clear_tweens :: proc(self: ^Dot) {
	ease.flux_clear(&self.tweens)
}
