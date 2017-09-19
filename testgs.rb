require 'green_shoes'
require './draw'
require './ship'
require 'pry-byebug'

def ships_added?
	corner_correct = true
	GAME.board.each_with_index do |col, col_index|
		break unless corner_correct
		col.each_with_index do |row, row_index|
			if GAME.battle_field[col_index][row_index] == 1 && SHIP.non_repeat_coords?(col_index, row_index)
				corner_correct = SHIP.correct_corners?(col_index, row_index, GAME.battle_field)
				break unless corner_correct
				SHIP.find_ship(col_index, row_index, ship = [], GAME.battle_field)
			end
		end
	end
	SHIP.add_ship_to_hash
	corner_correct && SHIP.correct_amount?
end

def add_enemy_ship
	# GAME.enemy_battle_field[0][0] = 1
	# GAME.enemy_battle_field[1][0] = 1
	# GAME.enemy_battle_field[2][0] = 1
	# GAME.enemy_battle_field[3][0] = 1

	# GAME.enemy_battle_field[5][1] = 1
	# GAME.enemy_battle_field[6][1] = 1
	# GAME.enemy_battle_field[7][1] = 1

	# GAME.enemy_battle_field[5][3] = 1
	# GAME.enemy_battle_field[6][3] = 1
	# GAME.enemy_battle_field[7][3] = 1

	# GAME.enemy_battle_field[8][5] = 1
	# GAME.enemy_battle_field[9][5] = 1

	# GAME.enemy_battle_field[8][7] = 1
	# GAME.enemy_battle_field[9][7] = 1

	# GAME.enemy_battle_field[8][9] = 1
	# GAME.enemy_battle_field[9][9] = 1

	# GAME.enemy_battle_field[3][3] = 1

	# GAME.enemy_battle_field[3][7] = 1

	# GAME.enemy_battle_field[0][9] = 1

	# GAME.enemy_battle_field[5][9] = 1

	# SHIP_ENEMY.overall << [[0,0],[1,0],[2,0],[3,0]]
	# SHIP_ENEMY.overall << [[5,1],[6,1],[7,1]]
	# SHIP_ENEMY.overall << [[5,3],[6,3],[7,3]]
	# SHIP_ENEMY.overall << [[8,5],[9,5]]
	# SHIP_ENEMY.overall << [[8,7],[9,7]]
	# SHIP_ENEMY.overall << [[8,9],[9,9]]
	# SHIP_ENEMY.overall << [[3,3]]
	# SHIP_ENEMY.overall << [[3,7]]
	# SHIP_ENEMY.overall << [[0,9]]
	# SHIP_ENEMY.overall << [[5,9]]
	# SHIP_ENEMY.add_ship_to_hash

	
	# col, row = GAME.comp_shot.shuffle.pop

	SHIP_ENEMY.add_ships
	SHIP_ENEMY.mark_on_field(GAME.enemy_battle_field)
	SHIP_ENEMY.add_ship_to_hash
end

def player_win?
	GAME.enemy_battle_field.flatten.count(2) == 20
end

def computer_win?
	GAME.battle_field.flatten.count(2) == 20
end

Shoes.app(width: 800, height: 600) do	
	extend Draw

	GAME = Draw::Game.new
	SHIP = Ship.new
	setup_done = false
	draw_board
	draw_enemy_board


	button("OK") do
		if setup_done
			alert "Вы уже начали игру, стреляйте по полю противника!"
		else
			if ships_added?
				alert "Корабли расставлены! начинаем игру"
				setup_done = true
				SHIP_ENEMY = Ship.new
				add_enemy_ship
			else
				alert "Что-то пошло не так. Исправьте расстановку!"
				SHIP = Ship.new
			end
		end
	end

	click do |button, x, y|
		if (coords = find_piece(x,y,0)) && (!setup_done)
			toggle_rectangle(coords)
		end
		if (coords = find_piece(x,y,1)) && setup_done
			fire_enemy(coords)
			if player_win? #НАДО СДЕЛАТЬ!!!
				alert "Вы победили!"
				abort
			end
			comp_fire #НАДО СДЕЛАТЬ!!!
			if computer_win? #НАДО СДЕЛАТЬ!!!
				alert "Вы проиграли... (((((("
				abort
			end
		end
	end

end