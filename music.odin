package main

import rl "vendor:raylib"

Music :: struct {
	cvb: rl.Music,
}

init_music :: proc() -> Music {
	music := Music {
		cvb = rl.LoadMusicStream("sounds/cvb.mp3"),
	}
	rl.SetMusicVolume(music.cvb, 0.3)
	return music
}

play_music :: proc(music: ^Music) {
	if rl.IsMusicValid(music.cvb) {
		rl.PlayMusicStream(music.cvb)
	}
}

update_music :: proc(game: ^Game) {
	if game.actions.toggle_pause {
		if game.paused {
			rl.PauseMusicStream(assets.music.cvb)
		} else {
			rl.ResumeMusicStream(assets.music.cvb)
		}
	}
	rl.UpdateMusicStream(assets.music.cvb)
}

destroy_music :: proc(music: ^Music) {
	if rl.IsMusicStreamPlaying(music.cvb) {
		rl.StopMusicStream(music.cvb)
	}
	rl.UnloadMusicStream(music.cvb)
}
