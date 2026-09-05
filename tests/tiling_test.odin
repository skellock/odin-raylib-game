#+feature using-stmt
package tests

import main "../src"
import ldtk "../src/ldtk"
import "core:testing"

@(test)
tile_layer_owns_identifier_test :: proc(t: ^testing.T) {
	using main, testing

	identifier_buf := [5]byte{'W', 'a', 'l', 'l', 's'}
	collision_values := [1]int{1}
	instance := ldtk.Layer_Instance {
		identifier   = string(identifier_buf[:]),
		grid_size    = 8,
		c_width      = 1,
		c_height     = 1,
		int_grid_csv = collision_values[:],
	}
	layer := tile_layer_init(instance, ldtk.Level{})
	defer tile_layer_destroy(&layer)

	// Reuse the source storage, as happens when the temporary allocator is reset.
	identifier_buf[0] = 'F'
	expect_value(t, layer.identifier, "Walls")
	expect_value(t, layer.collision_tiles[0], u8(1))
}
