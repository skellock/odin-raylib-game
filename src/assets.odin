package main

Assets :: struct {
	music:       Music,
	sounds:      Sounds,
	card_images: CardImages,
	fonts:       Fonts,
}

init_assets :: proc() -> Assets {
	return Assets{card_images = init_card_images(), music = init_music(), sounds = init_sounds(), fonts = init_fonts()}
}

destroy_assets :: proc(a: ^Assets) {
	destroy_card_images(&a.card_images)
	destroy_music(&a.music)
	destroy_sounds(&a.sounds)
	destroy_fonts(&a.fonts)
}
