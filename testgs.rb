require 'green_shoes'

LEFT_OFFSET = 10
TOP_OFFSET = 10

class Game
	BOARD_SIZE = [10,10]
	attr_accessor :board

	def initialize
		@board = new_board
	end

	def new_board
		Array.new(BOARD_SIZE[0]) do
			Array.new(BOARD_SIZE[1]) do
			end
		end
	end
end

def left_top_corner_of_piece(a,b)
	[(a*20+LEFT_OFFSET), (b*20+TOP_OFFSET)]
end

def draw_board
	stack width: width, height: 600 do
		background yellow
		fill blue
		GAME.board.each_with_index do |col, col_index|
			col.each_with_index do |cell, row_index|
				left, top = left_top_corner_of_piece(col_index, row_index)
				strokewidth 1
				stroke rgb(0, 0, 0)
				r = rect(left: left, top: top, width: 20, height: 20)
				GAME.board[col_index][row_index] = r
			end
		end
	end
end

Shoes.app(width: 520, height: 600) do	
	# stroke rgb(1,0,0)
	# fill rgb(0,0,1)
	# rect(10,10,self.width-20,self.height-20)

	GAME = Game.new
	draw_board
	

end