class Cell
	var isAlive: Bool


	fun newState (neighbours: Int) :Bool
	do
		if isAlive then
			if neighbours != 3 and neighbours != 2 then return not isAlive
		else
			if neighbours == 3 then return not isAlive
		end
		return isAlive
	end


	redef fun to_s
	do
		if isAlive then return "O" else return "."
	end
end


class Canvas
	var height: Int
	var width: Int
	var cells: Array[Array[Cell]] is noinit


	init
	do
		cells = new Array[Array[Cell]]
		for i in [0..height[ do
			self.cells[i] = new Array[Cell]
			for j in [0..width[ do
				 self.cells[i][j] = new Cell(false)
			end
		end
	end


	fun liveNeighbours(i, j: Int): Int
	do
		var neighbours = 0
		for n in [-1..1] do
			if n + i >= 0 and n + i < height then
				for m in [-1..1] do
					if m + j >= 0 and m + j < width then
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


	fun disp
	do
		for i in [0..height[ do
			print cells[i].join(" ")
		end
		print "\n"
	end

end

class Game
	var height: Int
	var width: Int
	var prev: Canvas is noinit
	var next: Canvas is noinit

	init
	do
		prev = new Canvas(height, width)
		next = new Canvas(height, width)

		# This is where you would initialize the first canvas
		next.cells[1][0].isAlive = true
		next.cells[2][0].isAlive = true
		next.cells[3][1].isAlive = true
		next.cells[0][2].isAlive = true
		next.cells[1][3].isAlive = true
		next.cells[2][3].isAlive = true

	end


	fun update
	do
		prev = next
		next = new Canvas(height, width)
		for i in [0..height[ do
			for j in [0..width[ do
				next.cells[i][j].isAlive = prev.cells[i][j].newState(prev.liveNeighbours(i,j))
			end
		end
	end
end


var game = new Game(4,4)

for i in [1..10] do
	game.next.disp
	game.update
end
