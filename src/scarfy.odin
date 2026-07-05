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

scarfy_update :: proc(self: ^Scarfy) {
	fw := self.animator.frame_rec.width
	fh := self.animator.frame_rec.height
	x := (f32(GAME_WIDTH) - fw) / 2
	y := (f32(GAME_HEIGHT) - fh) / 2
	self.pos = {x, y}

	anim.play(&self.animator)
}

scarfy_draw :: proc(self: Scarfy, dot: Dot) {
	animator := self.animator
	rect := rl.Rectangle{self.pos.x, self.pos.y, self.animator.frame_width, self.animator.frame_height}
	collided := rl.CheckCollisionCircleRec(dot.current_pos, dot.size, rect)
	color := collided ? rl.ColorAlpha(rl.WHITE, 0.5) : rl.WHITE

	rl.DrawTextureRec(animator.sprite, animator.frame_rec, self.pos, color)
}
