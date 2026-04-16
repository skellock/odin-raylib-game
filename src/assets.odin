package main

Assets :: struct {
	music:       Music,
	sounds:      Sounds,
	card_images: CardImages,
	fonts:       Fonts,
}

assets_init :: proc() -> Assets {
	return Assets{card_images = card_images_init(), music = music_init(), sounds = sounds_init(), fonts = fonts_init()}
}

assets_destroy :: proc(a: ^Assets) {
	card_images_destroy(&a.card_images)
	music_destroy(&a.music)
	sounds_destroy(&a.sounds)
	fonts_destroy(&a.fonts)
}
