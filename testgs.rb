require 'green_shoes'
require './draw'
require './ship'

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


Shoes.app(width: 800, height: 600) do	
	extend Draw

	GAME = Draw::Game.new
	SHIP = Ship.new
	setup_done = false
	draw_board
	draw_enemy_board


	button("OK") do
		if ships_added? && !setup_done
			alert "Корабли расставлены! начинаем игру"
			setup_done = true
		elsif !setup_done
			alert "Что-то пошло не так. Исправьте расстановку!"
			SHIP = Ship.new
		else
			alert "Вы уже начали игру, стреляйте по полю противника!"
		end
	end

	click do |button, x, y|
		if (coords = find_piece(x,y,0)) && (!setup_done)
			toggle_rectangle(coords)
		end
		if (coords = find_piece(x,y,1)) && setup_done
			fire_enemy(coords)
		end
	end

end