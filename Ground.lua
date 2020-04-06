require('Vars')
require('Bird')

Ground = {
    x = Screen.w/2,
    y = Screen.h - 50/2,
    width = Screen.w*2,
    height = PipeStats.w
}
Ground.body = love.physics.newBody(World, Ground.x, Ground.y, "static") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (1700/2, 1000-50/2)
Ground.shape = love.physics.newRectangleShape(Ground.width, Ground.height) --make a rectangle with a width of 1700 and a height of 50
Ground.fixture = love.physics.newFixture(Ground.body, Ground.shape, 1); --attach shape to body, give it a density of 1. 

function Ground.reset()
    Ground.body:setX(Screen.w/2)
    Ground.body:setY(Screen.h - 50/2)
end

function Ground.draw()
    love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the Ground
	love.graphics.rectangle("fill", 0, Ground.y - Ground.height/2, Ground.width, Ground.height) -- draw a "filled in" polygon using the Ground's coordinates
end

function Ground.collision()
	distance3, _, _, _, _ = love.physics.getDistance(Bird.fixture, Ground.fixture)
	if distance3 == 0 and Game.over == false then	--If the player hit a pipe or the Ground
			Game.over = true
			Bird.body:setLinearVelocity(0, 0)
			Bird.body:setX(Bird.body:getX())	--This line is why we need the if statement, otherwise the Bird just keeps travelling backwards
			Bird.body:setType("static")
    end
end

function Ground.updatePosition()
    if Ground.body:getX() < Bird.body:getX() - Screen.w then
		Ground.body:setX(Bird.body:getX())
	end
end