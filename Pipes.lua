require('Vars')
require('World')
require('Bird')
require('Camera')

Pipes = {
	pipes = {},
	w = 50,
    x = Screen.w,
    space = {
        x = Screen.w/2
    }
}
function Pipes.create()
	space = {}
	space.h = love.math.random(100,160)
	space.y = love.math.random(50, Screen.h - (space.h+50))
	block1 = {
		x = Pipes.x,
		width = Pipes.w,
		height = space.y - space.h/2
	}
	block1.y = block1.height / 2
	block1.body = love.physics.newBody(World, block1.x, block1.y, "static")
	block1.shape = love.physics.newRectangleShape(block1.width, block1.height)
	block1.fixture = love.physics.newFixture(block1.body, block1.shape, 5) -- A higher density gives it more mass.
   
	block2 = {
		x = Pipes.x,
		width = Pipes.w,
		height = Screen.h - (block1.height + space.h)
	}
	block2.y = block1.height + space.h + block2.height/2
	block2.body = love.physics.newBody(World, block2.x, block2.y, "static")
	block2.shape = love.physics.newRectangleShape(block2.width, block2.height)
	block2.fixture = love.physics.newFixture(block2.body, block2.shape, 1)
	Pipes.x = Pipes.x + Pipes.space.x
	return {one = block1, two = block2, scored=false, space = space}
  end

while Pipes.x < Screen.w*2+1 do
    table.insert(Pipes.pipes, Pipes.create())	
end

function Pipes.reset()
    for _, pipe in pairs(Pipes.pipes) do
		pipe.one.body:setX(Pipes.x)
		pipe.two.body:setX(Pipes.x)
		Pipes.x = Pipes.x + Pipes.space.x
		pipe.scored = false
    end
end

function Pipes:updatePosition(pipe)
    if pipe.one.body:getX() < Bird.body:getX() - (Screen.w/2 + Pipes.w/2) then	-- If the pipe is off the Screen
        --reset the pipe to come onto the Screen
        pipe.one.body:setX(Bird.body:getX() + Screen.w + Pipes.w/2)
        pipe.two.body:setX(Bird.body:getX() + Screen.w + Pipes.w/2)
		pipe.scored = false
		Pipes:updateSpacing(pipe)
    end
end

function Pipes:updateSpacing(pipe)
	space = {}
	space.h = love.math.random(100,160)
	space.y = love.math.random(50, Screen.h - (space.h+50))

	pipe.one.height = space.y - space.h/2
	pipe.two.height = Screen.h - (block1.height + space.h)

	pipe.one.y = pipe.one.height / 2
	pipe.one.body:setY(pipe.one.height / 2)
	pipe.two.y = pipe.one.height + space.h + pipe.two.height/2
	pipe.two.body:setY(pipe.one.height + space.h + pipe.two.height/2)

	pipe.one.fixture:destroy()
	pipe.one.shape = love.physics.newRectangleShape(pipe.one.width, pipe.one.height)
	pipe.one.fixture = love.physics.newFixture(pipe.one.body, pipe.one.shape, 1)
	pipe.two.fixture:destroy()
	pipe.two.shape = love.physics.newRectangleShape(pipe.two.width, pipe.two.height)
	pipe.two.fixture = love.physics.newFixture(pipe.two.body, pipe.two.shape, 1)
end

  function Pipes.draw()
    love.graphics.setColor(0.20, 0.20, 0.20) -- set the drawing color to grey for the blocks
	for _, pipe in pairs(Pipes.pipes) do	--Draw the Pipes
		pipe.img = Images.pipe
		pipe.x = pipe.one.body:getX() + Pipes.w/2 - Camera.x 
		pipe.y = pipe.one.body:getY() + pipe.one.height/2
		pipe.o = math.pi
		pipe.sx = pipe.one.width/pipe.img:getWidth()
		love.graphics.draw(pipe.img, pipe.x, pipe.y, pipe.o, pipe.sx, 1)

		pipe.img = Images.pipe
		pipe.x = pipe.two.body:getX() - Pipes.w/2 - Camera.x
		pipe.y = pipe.two.body:getY() - pipe.two.height/2
		pipe.o = 0
		pipe.sx = pipe.two.width/pipe.img:getWidth()
		love.graphics.draw(pipe.img, pipe.x, pipe.y, pipe.o, pipe.sx, 1)
	end  
  end

  function Pipes:collision(pipe)
    distance1, _, _, _, _ = love.physics.getDistance(Bird.fixture, pipe.one.fixture)
	distance2, _, _, _, _ = love.physics.getDistance(Bird.fixture, pipe.two.fixture)
	if distance1 == 0 or distance2 == 0 then	--If the player hit a pipe or the Ground
		if Game.over == false then	
			Game.over = true
			Bird.body:setLinearVelocity(0, 0)
			Bird.body:setX(Bird.body:getX())	--This line is why we need the if statement, otherwise the Bird just keeps travelling backwards
			Sounds.hit:play()
			Sounds.fail:play()
		end
    end
end