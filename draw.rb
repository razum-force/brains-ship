module Draw
	PIECE_WIDTH = 32
	PIECE_HEIGHT = 32
	LEFT_OFFSET = 10
	TOP_OFFSET = 10
	SHIFT = 420

	class Game
		BOARD_SIZE = [10,10]

		attr_accessor :board, :battle_field, :enemy_board, :enemy_battle_field, :comp_shot

		def initialize
			@board = new_board
			@battle_field = new_board
			@enemy_board = new_board
			@enemy_battle_field = new_board
			@comp_shot = init_comp_shots
		end

		def new_board
			Array.new(BOARD_SIZE[0]) do
				Array.new(BOARD_SIZE[1]) do
				end
			end
		end

		def init_comp_shots
			init = Array.new(BOARD_SIZE[0]*BOARD_SIZE[1])
			x = 0
			i = 0
			BOARD_SIZE[0].times do
				y = 0
				BOARD_SIZE[1].times do
					init[i] = [x,y]
					i += 1
					y += 1
				end
				x += 1
			end
			p init
			return init
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

	def fire_enemy(coords)
		col, row = coords
		if GAME.enemy_battle_field[col][row] == nil
			fill blue
			rect(left: GAME.enemy_board[col][row].left, top: GAME.enemy_board[col][row].top, width: PIECE_WIDTH, height: PIECE_HEIGHT)
			GAME.enemy_battle_field[col][row] = 3
		elsif GAME.enemy_battle_field[col][row] == 1
			fill red
			rect(left: GAME.enemy_board[col][row].left, top: GAME.enemy_board[col][row].top, width: PIECE_WIDTH, height: PIECE_HEIGHT)
			GAME.enemy_battle_field[col][row] = 2
		end		
	end

	def comp_fire
		col, row = GAME.comp_shot.shuffle!.pop
		if GAME.battle_field[col][row] == nil
			fill green
			rect(left: GAME.board[col][row].left, top: GAME.board[col][row].top, width: PIECE_WIDTH, height: PIECE_HEIGHT)
			GAME.battle_field[col][row] = 3
		elsif GAME.battle_field[col][row] == 1
			fill red
			rect(left: GAME.board[col][row].left, top: GAME.board[col][row].top, width: PIECE_WIDTH, height: PIECE_HEIGHT)
			GAME.battle_field[col][row] = 2
		end		
	end

	def find_piece(x,y,x_shift)
		GAME.board.each_with_index do |col, col_index|
			col.each_with_index do |row, row_index|
				left, top = left_top_corner_of_piece(col_index, row_index, x_shift)
				right, bottom = right_bottom_corner_of_piece(col_index, row_index, x_shift)
				return col_index, row_index if x >= left && x <= right && y >= top && y <= bottom
			end
		end
		return false #ДОБАВИЛ, ИНАЧЕ ДАВАЛО КРАШ
	end

	def left_top_corner_of_piece(x,y,x_shift) #x_shift = 0 or 1
		[(x*PIECE_WIDTH+LEFT_OFFSET+(x_shift*SHIFT)), (y*PIECE_HEIGHT+TOP_OFFSET)]
	end

	def right_bottom_corner_of_piece(x,y,x_shift) #x_shift = 0 or 1
		[(x*PIECE_WIDTH+LEFT_OFFSET+(x_shift*SHIFT)+PIECE_WIDTH), (y*PIECE_HEIGHT+TOP_OFFSET+PIECE_HEIGHT)]
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
		stack width: 400, height: 500 do
			background yellow
			fill blue
			GAME.board.each_with_index do |col, col_index|
				col.each_with_index do |cell, row_index|
					left, top = left_top_corner_of_piece(col_index, row_index, 0)
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

	def draw_enemy_board
		stack width: 400, height: 500 do
			background yellow
			fill green
			GAME.enemy_board.each_with_index do |col, col_index|
				col.each_with_index do |cell, row_index|
					left, top = left_top_corner_of_piece(col_index, row_index, 1)
					strokewidth 1
					stroke rgb(0, 0, 0)
					r = rect(left: left, top: top, width: PIECE_WIDTH, height: PIECE_HEIGHT)
					GAME.enemy_board[col_index][row_index] = r
				end
			end
		end
	end


end