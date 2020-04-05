function erase()
	if love.mouse.isDown(2) then 
		local erase_x = love.mouse.getX() + Camera.x	--x coordinate of the mouse
		local erase_y = love.mouse.getY() + Camera.y	--y coordinate of the mouse
		
		index = 1
		for _, line in pairs(lines) do
			if (line.x1 - 2 < erase_x and line.x2 + 2 > erase_x and line.y1 - 2 < erase_y and line.y2 + 2 > erase_y)
			or (line.x1 + 2 > erase_x and line.x2 - 2 < erase_x and line.y1 + 2 > erase_y and line.y2 - 2 < erase_y)
			or (line.x1 - 2 < erase_x and line.x2 + 2 > erase_x and line.y1 + 2 > erase_y and line.y2 - 2 < erase_y)
			or (line.x1 + 2 > erase_x and line.x2 - 2 < erase_x and line.y1 - 2 < erase_y and line.y2 + 2 > erase_y)
			then
				table.remove(lines, index)
				line.body:setType("dynamic")
			end
			index = index + 1
		end
	end
end