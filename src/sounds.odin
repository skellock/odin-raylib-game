package main

import "core:math/rand"
import rl "vendor:raylib"

Sounds :: struct {
	blip: rl.Sound,
	jump: rl.Sound,
}

sounds_init :: proc() -> Sounds {
	return Sounds{blip = rl.LoadSound("sounds/blip.ogg"), jump = rl.LoadSound("sounds/jump.ogg")}
}

sounds_play :: proc(sound: rl.Sound) {
	rl.PlaySound(sound)
}

sounds_play_jump :: proc(sounds: ^Sounds) {
	pitch := rand.float32_range(0.8, 1.2)
	rl.SetSoundVolume(sounds.jump, 0.3)
	rl.SetSoundPitch(sounds.jump, pitch)
	rl.PlaySound(sounds.jump)
}

sounds_destroy :: proc(sounds: ^Sounds) {
	if rl.IsSoundPlaying(sounds.blip) {
		rl.StopSound(sounds.blip)
	}
	if rl.IsSoundPlaying(sounds.jump) {
		rl.StopSound(sounds.jump)
	}
	rl.UnloadSound(sounds.blip)
	rl.UnloadSound(sounds.jump)
}
