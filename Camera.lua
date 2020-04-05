Camera = {
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Initialize the x and y coordinates of Camera to a starter value
	x = 0,
	y = 0
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
}

function Camera.update(dt)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--[CODE 5 LINES] Make the camera move to the left and right with the left and right arrow keys. Exactly the same as Quiddtich
	if love.keyboard.isDown("right") then --RIGHT ARROW BUTTON IS DOWN then
		Camera.x = Camera.x + 5
	elseif love.keyboard.isDown("left") then
		Camera.x = Camera.x - 5
	end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--[CODE 5 LINES] Make the camera move to the up and down with the up and down arrow keys. Exactly the same as Quiddtich
	if love.keyboard.isDown("up") then
		Camera.y = Camera.y - 5
	elseif love.keyboard.isDown("down") then
		Camera.y = Camera.y + 5
	end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
end

function Camera:follow(dt, rider)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Make Camera.x and Camera.y follow the rider. Exactly the same as Quidditch
	Camera.x = rider.body:getX() - love.graphics.getWidth()/2
	Camera.y = rider.body:getY() - love.graphics.getHeight()/2
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
end
