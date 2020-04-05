require('Camera')
--App ID:  ca-app-pub-6273488784837824~4269860143
--Ad unit id: ca-app-pub-6273488784837824/7494611678

function love.load()
	love.physics.setMeter(64) --the height of a meter our worlds will be 64px
	world = love.physics.newWorld(0, 15.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
	screen = {
		w = 1200,
		h = 700
	}
	pipeStats = {
		w = 50,
		x = screen.w,
		space = {
			x = screen.w/2
		}
	}
	game = {
		started = false,
		over = false
	}

	--let's create the ground
	ground = {
		x = screen.w/2,
		y = screen.h - 50/2,
		width = screen.w*2,
		height = pipeStats.w
	}
	ground.body = love.physics.newBody(world, ground.x, ground.y, "static") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (1700/2, 1000-50/2)
	ground.shape = love.physics.newRectangleShape(ground.width, ground.height) --make a rectangle with a width of 1700 and a height of 50
	ground.fixture = love.physics.newFixture(ground.body, ground.shape, 1); --attach shape to body, give it a density of 1. 
	
	ball = {
		x = screen.w/2,
		y = screen.h/2,
		radius = 20
	}
	ball.body = love.physics.newBody(world, ball.x, ball.y, "static") --place the body in the center of the world and make it dynamic, so it can move around
	ball.shape = love.physics.newCircleShape(ball.radius) --the ball's shape has a radius of 20
	ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1) -- Attach fixture to body and give it a density of 1.
	ball.fixture:setRestitution(0) --let the ball bounce 
	ball.fixture:setFriction(0)
   
	pipes = {}
	while pipeStats.x < screen.w*2+1 do
		table.insert(pipes, createPipes())	
	end

	--initial graphics setup
	love.graphics.setBackgroundColor(0.41, 0.53, 0.97) --set the background color to a nice blue
	love.window.setMode(screen.w, screen.h) --set the window dimensions to 650 by 650
  end

  function newGame()
	pipeStats.x = screen.w
	game.over = false
	ball.body:setX(screen.w/2)
	ball.body:setY(screen.h/2)
	ball.body:setType("static")
	ball.body:setLinearVelocity(0, 0)
	for _, pipe in pairs(pipes) do
		pipe.one.body:setX(pipeStats.x)
		pipe.two.body:setX(pipeStats.x)
		pipeStats.x = pipeStats.x + pipeStats.space.x
	end
	game.started = false
  end

  function createPipes()
	pipeStats.space.h = love.math.random(100,160)
	pipeStats.space.y = love.math.random(50, screen.h - (pipeStats.space.h+50))
	block1 = {
		x = pipeStats.x,
		width = pipeStats.w,
		height = pipeStats.space.y - pipeStats.space.h/2
	}
	block1.y = block1.height / 2
	block1.body = love.physics.newBody(world, block1.x, block1.y, "static")
	block1.shape = love.physics.newRectangleShape(block1.width, block1.height)
	block1.fixture = love.physics.newFixture(block1.body, block1.shape, 5) -- A higher density gives it more mass.
   
	block2 = {
		x = pipeStats.x,
		width = pipeStats.w,
		height = screen.h - (block1.height + pipeStats.space.h)
	}
	block2.y = block1.height + pipeStats.space.h + block2.height/2
	block2.body = love.physics.newBody(world, block2.x, block2.y, "static")
	block2.shape = love.physics.newRectangleShape(block2.width, block2.height)
	block2.fixture = love.physics.newFixture(block2.body, block2.shape, 1)
	pipeStats.x = pipeStats.x + pipeStats.space.x
	return {one = block1, two = block2}
  end
   
  function love.update(dt)
	Camera:follow(dt, ball)
	world:update(dt) --this puts the world into motion
	for _, pipe in pairs(pipes) do
		if pipe.one.body:getX() < ball.body:getX() - (screen.w/2 + pipeStats.w/2) then	-- If the pipe is way off the screen
			--reset the pipe to come up soon
			pipe.one.body:setX(ball.body:getX() + screen.w + pipeStats.w/2)
			pipe.two.body:setX(ball.body:getX() + screen.w + pipeStats.w/2)
		end
		distance1, _, _, _, _ = love.physics.getDistance(ball.fixture, pipe.one.fixture)
		distance2, _, _, _, _ = love.physics.getDistance(ball.fixture, pipe.two.fixture)
		distance3, _, _, _, _ = love.physics.getDistance(ball.fixture, ground.fixture)
		if distance1 == 0 or distance2 == 0 or distance3 == 0 then
			if game.over == false then
				game.over = true
				ball.body:setLinearVelocity(0, 0)
				ball.body:setX(ball.body:getX() - 1)
				-- ball.body:setY(ground.body:getY() - 2)
			end
		end
	end
	if ground.body:getX() < ball.body:getX() - screen.w then
		ground.body:setX(ball.body:getX())
	end
  end
   
  function love.draw()
	love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
	love.graphics.rectangle("fill", 0, ground.y - ground.height/2, ground.width, ground.height) -- draw a "filled in" polygon using the ground's coordinates
	
	love.graphics.setColor(0.76, 0.18, 0.05) --set the drawing color to red for the ball
	love.graphics.circle("fill", ball.body:getX() - Camera.x, ball.body:getY(), ball.shape:getRadius())
   
	love.graphics.setColor(0.20, 0.20, 0.20) -- set the drawing color to grey for the blocks
	for _, pipe in pairs(pipes) do
		x1, y1, x2, y2, x3, y3, x4, y4 = pipe.one.body:getWorldPoints(pipe.one.shape:getPoints())
		love.graphics.polygon("fill", x1 - Camera.x, y1, x2 - Camera.x, y2, x3 - Camera.x, y3, x4 - Camera.x, y4)
		x1, y1, x2, y2, x3, y3, x4, y4 = pipe.two.body:getWorldPoints(pipe.two.shape:getPoints())
		love.graphics.polygon("fill", x1 - Camera.x, y1, x2 - Camera.x, y2, x3 - Camera.x, y3, x4 - Camera.x, y4)	
	end



  end

function love.keypressed(button)
	if button == "space" then
		if game.over == false then
			ball.body:setType("dynamic")
			ball.body:setLinearVelocity(200, 0)
			ball.body:applyLinearImpulse(0, -100)
		end
	elseif button == "r" then
		newGame()
	end
end