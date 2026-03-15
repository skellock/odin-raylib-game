package main

import rl "vendor:raylib"

Fonts :: struct {
	body: rl.Font,
}

init_fonts :: proc() -> Fonts {
	body := rl.LoadFontEx("fonts/Amble-Regular.ttf", 256, nil, 0)
	rl.GenTextureMipmaps(&body.texture)
	rl.SetTextureFilter(body.texture, .BILINEAR)

	return Fonts{body}
}

destroy_fonts :: proc(fonts: ^Fonts) {
	rl.UnloadFont(fonts.body)
}
