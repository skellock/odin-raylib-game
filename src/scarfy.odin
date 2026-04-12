package main

import anim "animator"
import rl "vendor:raylib"

Scarfy :: struct {
	animator: anim.Animator,
	texture:  rl.Texture,
	pos:      rl.Vector2,
}

init_scarfy :: proc() -> Scarfy {
	animator := anim.new_animator(
		animator_name = "omgscarfy",
		frames_per_row = 6,
		num_rows = 1,
		speed = 7,
		play_in_reverse = false,
		continuous = true,
		looping = true,
	)

	return Scarfy{animator = animator}
}

load_scarfy :: proc(scarfy: ^Scarfy) {
	scarfy.texture = rl.LoadTexture("images/scarfy.png")
	anim.assign_sprite(&scarfy.animator, scarfy.texture)
}

destroy_scarfy :: proc(scarfy: ^Scarfy) {
	if scarfy.texture.id != 0 {
		rl.UnloadTexture(scarfy.texture)
	}
}

update_scarfy :: proc(game: ^Game) {
	vw := f32(game.viewport.width)
	vh := f32(game.viewport.height)
	fw := game.scarfy.animator.frame_rec.width
	fh := game.scarfy.animator.frame_rec.height
	x := (vw - fw) / 2
	y := (vh - fh) / 2
	game.scarfy.pos = {x, y}

	anim.play(&game.scarfy.animator)
}

draw_scarfy :: proc(game: ^Game) {
	animator := &game.scarfy.animator
	scarfy_rect := get_scarfy_rect(game)
	collided := rl.CheckCollisionCircleRec(game.dot.current_pos, game.dot.size, scarfy_rect)
	color := collided ? rl.ColorAlpha(rl.WHITE, 0.5) : rl.WHITE

	rl.DrawTextureRec(animator.sprite, animator.frame_rec, game.scarfy.pos, color)
}

get_scarfy_rect :: proc(game: ^Game) -> rl.Rectangle {
	return rl.Rectangle {
		x = game.scarfy.pos.x,
		y = game.scarfy.pos.y,
		width = game.scarfy.animator.frame_width,
		height = game.scarfy.animator.frame_height,
	}
}
