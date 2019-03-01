import gamnit::flat
import gamnit::landscape
import geometry::points_and_lines
import gamnit::display
import gamnit::textures


class Logo

	var texture = new TextureAsset("logoDVD.png")
	var position = new Point3d[Float](0.0, 0.0, 0.0)
	var speed = new Point3d[Float](4.0, 4.0, 0.0)
	var sprite: Sprite is noinit

	init
	do
		sprite = new Sprite(texture, position)
	end

	fun move(h,w: Float)
	do
		position.x += speed.x
		position.y += speed.y

		var top = position.y + texture.height*sprite.scale/2.0
		var bottom = position.y - texture.height*sprite.scale/2.0
		var left = position.x - texture.width*sprite.scale/2.0
		var right = position.x + texture.width*sprite.scale/2.0

		if left <= -w/2.0 then
			speed.x *= -1.0
			glClearColor(0.7, 0.3, 0.3, 1.0)
		end
		if bottom <= -h/2.0 then
			speed.y *= -1.0
			glClearColor(0.0, 0.7, 0.0, 1.0)
		end
		if right >= w/2.0 then
			speed.x *= -1.0
			glClearColor(0.3, 0.3, 0.7, 1.0)
		end
		if top >= h/2.0 then
			speed.y *= -1.0
			glClearColor(0.7, 0.7, 0.3, 1.0)
		end

	end
end

redef class App
	var logo = new Logo

	redef fun create_scene
	do
		super

		sprites.add logo.sprite
		logo.sprite.scale = 1.0
		#glClearColor(0.5, 0.8, 1.0, 1.0)
		world_camera.reset_height display.height.to_f
	end

	redef fun update (dt)
	do
		logo.move(display.height.to_f,display.width.to_f)
	end

	redef fun accept_event(event)
	do
		if super then return true

		if event isa QuitEvent or
		  (event isa KeyEvent and event.name == "escape" and event.is_up) then
			# When window close button, escape or back key is pressed
			print "Ran at {current_fps} FPS in the last few seconds"

			print "Performance statistics to detect bottlenecks:"
			print sys.perfs

			# Quit abruptly
			exit 0
		end
		return false
	end
end
