require('Camera')
require('Background')
require('Bird')
require('World')
--Android banner
--App ID:  ca-app-pub-6273488784837824~4269860143
--Ad unit id: ca-app-pub-6273488784837824/7494611678

function love.load()

	--let's create the ground
	ground = {
		x = Screen.w/2,
		y = Screen.h - 50/2,
		width = Screen.w*2,
		height = PipeStats.w
	}
	ground.body = love.physics.newBody(World, ground.x, ground.y, "static") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (1700/2, 1000-50/2)
	ground.shape = love.physics.newRectangleShape(ground.width, ground.height) --make a rectangle with a width of 1700 and a height of 50
	ground.fixture = love.physics.newFixture(ground.body, ground.shape, 1); --attach shape to body, give it a density of 1. 

	pipes = {}
	while PipeStats.x < Screen.w*2+1 do
		table.insert(pipes, createPipes())	
	end

	--initial graphics setup
	love.graphics.setBackgroundColor(0.41, 0.53, 0.97) --set the background color to a nice blue
	love.window.setMode(Screen.w, Screen.h) --set the window dimensions to 650 by 650
  end

  function newGame()
	PipeStats.x = Screen.w
	Game.over = false
	Bird.reset()
	ground.body:setX(Screen.w/2)
	ground.body:setY(Screen.h - 50/2)
	for _, pipe in pairs(pipes) do
		pipe.one.body:setX(PipeStats.x)
		pipe.two.body:setX(PipeStats.x)
		PipeStats.x = PipeStats.x + PipeStats.space.x
		pipe.scored = false
     	end
	Background.reset()
	Game.started = false
	Game.score.cur = 0
  end

  function createPipes()
	space = {}
	space.h = love.math.random(100,160)
	space.y = love.math.random(50, Screen.h - (space.h+50))
	block1 = {
		x = PipeStats.x,
		width = PipeStats.w,
		height = space.y - space.h/2
	}
	block1.y = block1.height / 2
	block1.body = love.physics.newBody(World, block1.x, block1.y, "static")
	block1.shape = love.physics.newRectangleShape(block1.width, block1.height)
	block1.fixture = love.physics.newFixture(block1.body, block1.shape, 5) -- A higher density gives it more mass.
   
	block2 = {
		x = PipeStats.x,
		width = PipeStats.w,
		height = Screen.h - (block1.height + space.h)
	}
	block2.y = block1.height + space.h + block2.height/2
	block2.body = love.physics.newBody(World, block2.x, block2.y, "static")
	block2.shape = love.physics.newRectangleShape(block2.width, block2.height)
	block2.fixture = love.physics.newFixture(block2.body, block2.shape, 1)
	PipeStats.x = PipeStats.x + PipeStats.space.x
	return {one = block1, two = block2, scored=false, space = space}
  end
   
  function love.update(dt)
	Camera:follow(dt, Bird)
	World:update(dt) --this puts the World into motion
	for _, pipe in pairs(pipes) do
		if pipe.one.body:getX() < Bird.body:getX() - (Screen.w/2 + PipeStats.w/2) then	-- If the pipe is off the Screen
			--reset the pipe to come onto the Screen
			pipe.one.body:setX(Bird.body:getX() + Screen.w + PipeStats.w/2)
			pipe.two.body:setX(Bird.body:getX() + Screen.w + PipeStats.w/2)
			pipe.scored = false
		end
		if pipe.one.body:getX() <= Bird.body:getX() and pipe.scored == false then
			Game.score.cur = Game.score.cur + 1
			pipe.scored = true
			if Game.score.cur > Game.score.best then
				Game.score.best = Game.score.cur
			end
		end
		Bird:collision(pipe)
	end

	Background.scroll()

	if ground.body:getX() < Bird.body:getX() - Screen.w then
		ground.body:setX(Bird.body:getX())
	end
  end
   
  function love.draw()
	--background
	Background.draw()

	love.graphics.setColor(1,1,1) --set the drawing color to red for the Bird

	Bird.draw()
	love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
	love.graphics.rectangle("fill", 0, ground.y - ground.height/2, ground.width, ground.height) -- draw a "filled in" polygon using the ground's coordinates
	

	love.graphics.setColor(0.20, 0.20, 0.20) -- set the drawing color to grey for the blocks
	for _, pipe in pairs(pipes) do	--Draw the pipes
		pipe.img = Images.pipe
		pipe.x = pipe.one.body:getX() + PipeStats.w/2 - Camera.x 
		pipe.y = pipe.one.body:getY() + pipe.one.height/2
		pipe.o = math.pi
		pipe.sx = pipe.one.width/pipe.img:getWidth()
		love.graphics.draw(pipe.img, pipe.x, pipe.y, pipe.o, pipe.sx, 1)

		pipe.img = Images.pipe
		pipe.x = pipe.two.body:getX() - PipeStats.w/2 - Camera.x
		pipe.y = pipe.two.body:getY() - pipe.two.height/2
		pipe.o = 0
		pipe.sx = pipe.two.width/pipe.img:getWidth()
		love.graphics.draw(pipe.img, pipe.x, pipe.y, pipe.o, pipe.sx, 1)
	end

	if Game.started == false then
		love.graphics.draw(Images.tapToStart, Screen.w/2 - Images.tapToStart:getWidth()/2, Screen.h/2 - Images.tapToStart:getHeight()/2)
	else
		font = love.graphics.newFont(14)
		text = love.graphics.newText(font, "Score: "..Game.score.cur)
		love.graphics.draw(text, Screen.w/2, Screen.h * 3/4)
	end

  end

function love.keypressed(button)
	if button == "space" then
		if Game.over == false then
			Game.started = true
			Bird.jump()
		else
			newGame()	
		end
	end
end