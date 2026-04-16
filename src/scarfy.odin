package main

import anim "animator"
import rl "vendor:raylib"

Scarfy :: struct {
	animator: anim.Animator,
	texture:  rl.Texture,
	pos:      rl.Vector2,
}

scarfy_init :: proc() -> Scarfy {
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

scarfy_load :: proc(scarfy: ^Scarfy) {
	scarfy.texture = rl.LoadTexture("images/scarfy.png")
	anim.assign_sprite(&scarfy.animator, scarfy.texture)
}

scarfy_destroy :: proc(scarfy: ^Scarfy) {
	if scarfy.texture.id != 0 {
		rl.UnloadTexture(scarfy.texture)
	}
}

scarfy_update :: proc(game: ^Game) {
	vw := f32(game.viewport.width)
	vh := f32(game.viewport.height)
	fw := game.scarfy.animator.frame_rec.width
	fh := game.scarfy.animator.frame_rec.height
	x := (vw - fw) / 2
	y := (vh - fh) / 2
	game.scarfy.pos = {x, y}

	anim.play(&game.scarfy.animator)
}

scarfy_draw :: proc(game: ^Game) {
	animator := &game.scarfy.animator
	scarfy_rect := scarfy_get_rect(game)
	collided := rl.CheckCollisionCircleRec(game.dot.current_pos, game.dot.size, scarfy_rect)
	color := collided ? rl.ColorAlpha(rl.WHITE, 0.5) : rl.WHITE

	rl.DrawTextureRec(animator.sprite, animator.frame_rec, game.scarfy.pos, color)
}

scarfy_get_rect :: proc(game: ^Game) -> rl.Rectangle {
	return rl.Rectangle {
		game.scarfy.pos.x,
		game.scarfy.pos.y,
		game.scarfy.animator.frame_width,
		game.scarfy.animator.frame_height,
	}
}
