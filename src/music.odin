package main

import rl "vendor:raylib"

Music :: struct {
	cvb: rl.Music,
}

music_init :: proc() -> Music {
	music := Music {
		cvb = rl.LoadMusicStream("sounds/cvb.mp3"),
	}
	rl.SetMusicVolume(music.cvb, 0.3)
	return music
}

music_play :: proc(music: ^Music) {
	if rl.IsMusicValid(music.cvb) {
		rl.PlayMusicStream(music.cvb)
	}
}

music_toggle :: proc(pause: bool) {
	if pause {
		music_pause()
	} else {
		music_resume()
	}
}

music_pause :: proc() {
	rl.PauseMusicStream(assets.music.cvb)
}

music_resume :: proc() {
	rl.ResumeMusicStream(assets.music.cvb)
}

music_update :: proc() {
	rl.UpdateMusicStream(assets.music.cvb)
}

music_destroy :: proc(music: ^Music) {
	if rl.IsMusicStreamPlaying(music.cvb) {
		rl.StopMusicStream(music.cvb)
	}
	rl.UnloadMusicStream(music.cvb)
}
