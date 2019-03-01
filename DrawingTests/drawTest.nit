module drawTest
import scene2d
import curses

class CursesView
	super View

	var window: Window

	redef fun draw_sprite(s: Sprite) do s.draw_on_curses(window)
end

redef class Sprite
	# Drawing of a sprite in the curse windows
	fun draw_on_curses(window: Window) is abstract
end

class Character
	super Sprite

	var hor: Int
	var ver: Int

	init
	do
		self.x = 0
		self.y = 0
	end

	fun move
	do
		self.x += self.hor
		self.y += self.ver
	end

	redef fun update
	do
		move
	end

	redef fun draw_on_curses(window)
	do
		var x = self.x/100
		var y = self.y/100
		window.mvaddstr(y,x,"0")
	end
end

class PlayScene
	super Scene

	var char1 = new Character(1,2)
	var char2 = new Character(2,2)

	var sprites = new LiveGroup[LiveObject]

	init
	do
		sprites.add(char1)
		sprites.add(char2)
	end

	redef fun update
	do
		sprites.update
	end

	fun draw_on_curses(view: CursesView)
	do
		var window = view.window

		window.wclear
		sprites.draw(view)
		window.mvaddstr(0, 0,   "'s' to stop")
		window.refresh
		sys.nanosleep(0,4800000)

		while sys.stdin.poll_in do
			if sys.stdin.eof then return
			var c = sys.stdin.read_char
			if c == 's' then
				self.exists = false
				return
			end
		end
	end
end

var game = new PlayScene
var win = new Window

var main_view = new CursesView(win)

while game.exists do
	game.update
	game.draw_on_curses(main_view)
end

win.delwin
win.endwin
win.refresh
