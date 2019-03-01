import scene2d
import curses

class CursesView
	super View

	var window: Window

	redef fun draw_sprite(s: Sprite) do s.draw_on_curses(window)
end

redef class Sprite
	# Drawing of a sprite in the curse windows
	# i.e how it should be drawn
	fun draw_on_curses(window: Window) is abstract
end


class Cell
	super Sprite

	var isAlive: Bool
	var i: Int
	var j: Int


	fun newState (neighbours: Int) :Bool
	do
		if isAlive then
			if neighbours != 3 and neighbours != 2 then return not isAlive
		else
			if neighbours == 3 then return not isAlive
		end
		return isAlive
	end


	redef fun draw_on_curses(window)
	do
		if isAlive then window.mvaddstr(i,j,"*") else window.mvaddstr(i+1,j," ")
	end
end


class Canvas
	super Sprite

	var lines: Int
	var rows: Int
	var cells: Array[Array[Cell]] is noinit


	init
	do
		cells = new Array[Array[Cell]]
		for i in [0..lines[ do
			self.cells[i] = new Array[Cell]
			for j in [0..rows[ do
				 self.cells[i][j] = new Cell(false,i,j)
			end
		end
	end


	fun randCanvas
	do
		for i in [0..lines[ do
			for j in [0..rows[ do
				self.cells[i][j].isAlive = (2.rand == 0)
			end
		end
	end


	fun liveNeighbours(i, j: Int): Int
	do
		var neighbours = 0
		for n in [-1..1] do
			if n + i >= 0 and n + i < lines then
				for m in [-1..1] do
					if m + j >= 0 and m + j < rows then
						if cells[n + i][m + j].isAlive then
							neighbours += 1
						end
					end
				end
			end
		end

		if cells[i][j].isAlive then neighbours -= 1

		return neighbours
	end


	redef fun draw_on_curses(window)
	do
		for i in [0..lines[ do
			for j in [0..rows[ do
				cells[i][j].draw_on_curses(window)
			end
		end
	end
end


class Game
	super Scene

	var lines: Int
	var rows: Int
	var prev: Canvas is noinit
	var next: Canvas is noinit

	var sprites = new LiveGroup[LiveObject]

	init
	do
		prev = new Canvas(lines, rows)
		next = new Canvas(lines, rows)

		# This is where you would initialize the first canvas
		next.randCanvas
	end


	redef fun update
	do
		prev = next
		next = new Canvas(lines, rows)
		for i in [0..lines[ do
			for j in [0..rows[ do
				next.cells[i][j].isAlive = prev.cells[i][j].newState(prev.liveNeighbours(i,j))
			end
		end
	end

	fun draw_on_curses(view: CursesView)
	do
		var window = view.window

		window.wclear
		next.draw(view)
		#window.mvaddstr(0, 0,   "'s' to stop")
		window.refresh
		sys.nanosleep(0,40000000)

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


var game = new Game(args[0].to_i,args[1].to_i)
var win = new Window

var main_view = new CursesView(win)

while game.exists do
	game.update
	game.draw_on_curses(main_view)
end

win.delwin
win.endwin
win.refresh
