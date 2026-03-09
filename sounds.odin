package main

import "core:math/rand"
import rl "vendor:raylib"

Sounds :: struct {
	blip: rl.Sound,
	jump: rl.Sound,
}

init_sounds :: proc() -> Sounds {
	return Sounds{blip = rl.LoadSound("sounds/blip.ogg"), jump = rl.LoadSound("sounds/jump.ogg")}
}

play_sound :: proc(sound: rl.Sound) {
	rl.PlaySound(sound)
}

play_jump_sound :: proc(sounds: Sounds) {
	pitch := rand.float32_range(0.8, 1.2)
	rl.SetSoundVolume(sounds.jump, 0.3)
	rl.SetSoundPitch(sounds.jump, pitch)
	rl.PlaySound(sounds.jump)
}

destroy_sounds :: proc(sounds: ^Sounds) {
	if rl.IsSoundPlaying(sounds.blip) {
		rl.StopSound(sounds.blip)
	}
	if rl.IsSoundPlaying(sounds.jump) {
		rl.StopSound(sounds.jump)
	}
	rl.UnloadSound(sounds.blip)
	rl.UnloadSound(sounds.jump)
}
