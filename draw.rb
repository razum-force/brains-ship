module Draw
	PIECE_WIDTH = 32
	PIECE_HEIGHT = 32
	LEFT_OFFSET = 10
	TOP_OFFSET = 10

	class Game
		BOARD_SIZE = [10,10]

		attr_accessor :board, :battle_field

		def initialize
			@board = new_board
			@battle_field = new_board
		end

		def new_board
			Array.new(BOARD_SIZE[0]) do
				Array.new(BOARD_SIZE[1]) do
				end
			end
		end
	end

	def mark_on_battle_field(col,row)
		GAME.battle_field[col][row] ||= 1
	end

	def unmark_on_battle_field(col,row)
		GAME.battle_field[col][row] = nil
	end

	# def battle_field
	# 	GAME.battle_field
	# end

	def toggle_rectangle(coords)
		col, row = coords
		if GAME.battle_field[col][row] == 1
			fill blue
			rect(left: GAME.board[col][row].left, top: GAME.board[col][row].top, width: PIECE_WIDTH, height: PIECE_HEIGHT)
			unmark_on_battle_field(col, row)
		else
			fill black
			rect(left: GAME.board[col][row].left, top: GAME.board[col][row].top, width: PIECE_WIDTH, height: PIECE_HEIGHT)
			mark_on_battle_field(col, row)
		end		
	end

	def find_piece(x,y)
		GAME.board.each_with_index do |col, col_index|
			col.each_with_index do |row, row_index|
				left, top = left_top_corner_of_piece(col_index, row_index)
				right, bottom = right_bottom_corner_of_piece(col_index, row_index)
				return col_index, row_index if x >= left && x <= right && y >= top && y <= bottom
			end
		end
		return false #ДОБАВИЛ, ИНАЧЕ ДАВАЛО КРАШ
	end

	def left_top_corner_of_piece(x,y)
		[(x*PIECE_WIDTH+LEFT_OFFSET), (y*PIECE_HEIGHT+TOP_OFFSET)]
	end

	def right_bottom_corner_of_piece(x,y)
		[(x*PIECE_WIDTH+LEFT_OFFSET+PIECE_WIDTH), (y*PIECE_HEIGHT+TOP_OFFSET+PIECE_HEIGHT)]
	end

	def clear_board
		GAME.battle_field.each_with_index do |col, col_index|
			col.each_with_index do |cell, row_index|
				GAME.battle_field[col_index][row_index] = nil
			end
		end
		draw_board
	end


	def draw_board
		stack width: width, height: 500 do
			background yellow
			fill blue
			GAME.board.each_with_index do |col, col_index|
				col.each_with_index do |cell, row_index|
					left, top = left_top_corner_of_piece(col_index, row_index)
					strokewidth 1
					stroke rgb(0, 0, 0)
					if GAME.battle_field[col_index][row_index] == nil
						fill blue
					else
						fill black
					end
					r = rect(left: left, top: top, width: PIECE_WIDTH, height: PIECE_HEIGHT)
					GAME.board[col_index][row_index] = r
				end
			end
		end
	end
end