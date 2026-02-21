package main

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

destroy_sounds :: proc(sounds: ^Sounds) {
	rl.UnloadSound(sounds.blip)
	rl.UnloadSound(sounds.jump)
}
