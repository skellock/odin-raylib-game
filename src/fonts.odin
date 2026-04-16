package main

import rl "vendor:raylib"

Fonts :: struct {
	body: rl.Font,
}

fonts_init :: proc() -> Fonts {
	body := rl.LoadFontEx("fonts/Amble-Regular.ttf", 256, nil, 0)
	rl.GenTextureMipmaps(&body.texture)
	rl.SetTextureFilter(body.texture, .BILINEAR)

	return Fonts{body}
}

fonts_destroy :: proc(fonts: ^Fonts) {
	rl.UnloadFont(fonts.body)
}
