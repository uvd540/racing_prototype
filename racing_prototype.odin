package racing_prototype

import "core:fmt"
import rl "vendor:raylib"

car_position: rl.Vector3
car_speed: f32
car_rotation: f32
car_acceleration :: 10
car_steer :: 2
car_friction: f32 = 1

camera_offset :: [3]f32{5, 5, 5}

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(1280, 780, "race")
	defer rl.CloseWindow()

	camera := rl.Camera {
		position   = camera_offset,
		up         = [3]f32{0, 1, 0},
		fovy       = 45,
		target     = [3]f32{0, 0, 0},
		projection = .PERSPECTIVE,
	}

	car_model := rl.LoadModel("assets/vehicle-speedster.glb")
	defer rl.UnloadModel(car_model)

	for !rl.WindowShouldClose() {
		update_car(rl.GetFrameTime())
		camera.position = car_position + camera_offset
		camera.target = car_position
		rl.BeginDrawing()
		rl.EndDrawing()

		rl.ClearBackground(rl.DARKGRAY)
		rl.DrawFPS(10, 10)

		rl.BeginMode3D(camera)
			rl.DrawGrid(500, 10)
			rl.DrawModelEx(car_model, car_position, {0, 1, 0}, (car_rotation*-rl.RAD2DEG)-90, 1, rl.WHITE)
		rl.EndMode3D()
	}
}

update_car :: proc(dt: f32) {
	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {
		car_rotation -= car_steer * dt
	}
	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {
		car_rotation += car_steer * dt
	}
	if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) {
		car_speed += car_acceleration * dt
	}
	if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) {
		car_speed -= car_acceleration * dt
	}
	car_speed = clamp(car_speed, 0, 20)
	car_dir := rl.Vector2Rotate({1, 0}, car_rotation)
	car_position.xz += car_dir * car_speed * dt
}
