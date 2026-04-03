package main

import "core:log"
import "ldtk"
import rl "vendor:raylib"

TILE_SIZE :: 32 // TODO: don't hardcode somehow

TileFlip :: enum {
	FlipNone,
	FlipX,
	FlipY,
	FlipBoth,
}

Tile :: struct {
	src:  rl.Vector2,
	dst:  rl.Vector2,
	flip: TileFlip,
}

TileLayer :: struct {
	identifier:      string,
	tiles:           []Tile,
	collision_tiles: []u8,
	offset:          rl.Vector2,
	rows:            i32,
	cols:            i32,
	pixel_width:     i32,
	pixel_height:    i32,
}

Tiling :: struct {
	texture: rl.Texture,
	layers:  [8]TileLayer, // hardcode for now
}

init_tiling :: proc() -> Tiling {
	tiling := Tiling{}
	return tiling
}

@(private = "file")
load_layer :: proc(instance: ldtk.Layer_Instance, level: ldtk.Level) -> TileLayer {
	layer := TileLayer {
		identifier   = instance.identifier,
		cols         = i32(instance.c_width),
		rows         = i32(instance.c_height),
		offset       = {f32(instance.px_total_offset_x), f32(instance.px_total_offset_y)},
		pixel_width  = i32(level.px_width),
		pixel_height = i32(level.px_height),
	}

	// prepare the collision tiles
	layer.collision_tiles = make([]u8, layer.cols * layer.rows)
	for val, idx in instance.int_grid_csv {
		layer.collision_tiles[idx] = u8(val)
	}

	// prepare the tile goodies
	layer.tiles = make([]Tile, len(instance.auto_layer_tiles))
	multiplier := f32(TILE_SIZE) / f32(instance.grid_size)
	for val, idx in instance.auto_layer_tiles {
		layer.tiles[idx].dst.x = f32(val.px.x) * multiplier
		layer.tiles[idx].dst.y = f32(val.px.y) * multiplier
		layer.tiles[idx].src.x = f32(val.src.x)
		layer.tiles[idx].src.y = f32(val.src.y)

		// NOTE: is there a more Odin-y way to do this?
		if bool(val.f & 1) {
			layer.tiles[idx].flip = .FlipX
		} else if bool(val.f & 2) {
			layer.tiles[idx].flip = .FlipY
		} else if bool(val.f & 3) {
			layer.tiles[idx].flip = .FlipBoth
		} else {
			layer.tiles[idx].flip = .FlipNone
		}

	}


	return layer
}

load_tiling :: proc(tiling: ^Tiling) {
	tiling.texture = rl.LoadTexture("tiles/Cavernas_by_Adam_Saltsman.png")

	if project, ok := ldtk.load_from_file("tiles/world.ldtk", context.temp_allocator).?; ok {
		// NOTE: assume 1 level for now
		for level in project.levels {
			for layer, idx in level.layer_instances {
				switch layer.type {
				case .IntGrid:
					layer := load_layer(layer, level)
					tiling.layers[idx] = layer

				case .Entities:

				case .AutoLayer:

				case .Tiles:
				}
			}
		}

	} else {
		log.error("Unable to load world.ldtk")
	}
}

destroy_tiling :: proc(tiling: ^Tiling) {
	rl.UnloadTexture(tiling.texture)

	for &layer in tiling.layers {
		delete(layer.tiles)
		delete(layer.collision_tiles)
	}
}

draw_tiling :: proc(game: ^Game) {

	for layer in game.tiling.layers {
		screen_offset := rl.Vector2 {
			f32(game.viewport.width - (TILE_SIZE * layer.cols)) / 2.0,
			f32(game.viewport.height - (TILE_SIZE * layer.rows)) / 2.0,
		}
		origin := rl.Vector2{f32(TILE_SIZE / 2), f32(TILE_SIZE / 2)}

		for tile in layer.tiles {
			src_rect := rl.Rectangle {
				x      = tile.src.x,
				y      = tile.src.y,
				height = 8,
				width  = 8,
			}
			if tile.flip == .FlipX || tile.flip == .FlipBoth {
				src_rect.width *= -1
			}
			if tile.flip == .FlipY || tile.flip == .FlipBoth {
				src_rect.height *= -1
			}

			dst_rect := rl.Rectangle {
				x      = tile.dst.x + layer.offset.x + screen_offset.x,
				y      = tile.dst.y + layer.offset.y + screen_offset.y,
				width  = f32(TILE_SIZE),
				height = f32(TILE_SIZE),
			}

			rl.DrawTexturePro(game.tiling.texture, src_rect, dst_rect, origin, 0, rl.WHITE)

		}
	}
}
