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
		over = false,
		score = {
			cur = 0,
			best = 0
		}
	}
	images = {
		tapToStart = love.graphics.newImage("images/tap_to_start.png"),
		sprite1 = love.graphics.newImage("images/sprite1.png"),
		sprite2 = love.graphics.newImage("images/sprite2.png"),
		background = love.graphics.newImage("images/background.png"),
		pipe = love.graphics.newImage("images/pipe.png")
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
		w = 40,
		h = 40
	}
	ball.body = love.physics.newBody(world, ball.x, ball.y, "static") --place the body in the center of the world and make it dynamic, so it can move around
	ball.shape = love.physics.newRectangleShape(ball.w, ball.h) --the ball's shape has a radius of 20
	ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1) -- Attach fixture to body and give it a density of 1.
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
	ball.body:setAngle(0)
	ground.body:setX(screen.w/2)
	ground.body:setY(screen.h - 50/2)
	for _, pipe in pairs(pipes) do
		pipe.one.body:setX(pipeStats.x)
		pipe.two.body:setX(pipeStats.x)
		pipeStats.x = pipeStats.x + pipeStats.space.x
		pipe.scored = false
	end
	game.started = false
	game.score.cur = 0
  end

  function createPipes()
	space = {}
	space.h = love.math.random(100,160)
	space.y = love.math.random(50, screen.h - (space.h+50))
	block1 = {
		x = pipeStats.x,
		width = pipeStats.w,
		height = space.y - space.h/2
	}
	block1.y = block1.height / 2
	block1.body = love.physics.newBody(world, block1.x, block1.y, "static")
	block1.shape = love.physics.newRectangleShape(block1.width, block1.height)
	block1.fixture = love.physics.newFixture(block1.body, block1.shape, 5) -- A higher density gives it more mass.
   
	block2 = {
		x = pipeStats.x,
		width = pipeStats.w,
		height = screen.h - (block1.height + space.h)
	}
	block2.y = block1.height + space.h + block2.height/2
	block2.body = love.physics.newBody(world, block2.x, block2.y, "static")
	block2.shape = love.physics.newRectangleShape(block2.width, block2.height)
	block2.fixture = love.physics.newFixture(block2.body, block2.shape, 1)
	pipeStats.x = pipeStats.x + pipeStats.space.x
	return {one = block1, two = block2, scored=false, space = space}
  end
   
  function love.update(dt)
	Camera:follow(dt, ball)
	world:update(dt) --this puts the world into motion
	for _, pipe in pairs(pipes) do
		if pipe.one.body:getX() < ball.body:getX() - (screen.w/2 + pipeStats.w/2) then	-- If the pipe is off the screen
			--reset the pipe to come onto the screen
			pipe.one.body:setX(ball.body:getX() + screen.w + pipeStats.w/2)
			pipe.two.body:setX(ball.body:getX() + screen.w + pipeStats.w/2)
			pipe.scored = false
		end
		if pipe.one.body:getX() <= ball.body:getX() and pipe.scored == false then
			game.score.cur = game.score.cur + 1
			pipe.scored = true
			if game.score.cur > game.score.best then
				game.score.best = game.score.cur
			end
		end
		distance1, _, _, _, _ = love.physics.getDistance(ball.fixture, pipe.one.fixture)
		distance2, _, _, _, _ = love.physics.getDistance(ball.fixture, pipe.two.fixture)
		distance3, _, _, _, _ = love.physics.getDistance(ball.fixture, ground.fixture)
		if distance1 == 0 or distance2 == 0 or distance3 == 0 then	--If the player hit a pipe or the ground
			if game.over == false then	
				game.over = true
				ball.body:setLinearVelocity(0, 0)
				ball.body:setX(ball.body:getX())	--This line is why we need the if statement, otherwise the ball just keeps travelling backwards
			end
			if distance3 == 0 then
				ball.body:setType("static")
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
	
	love.graphics.setColor(1,1,1) --set the drawing color to red for the ball
	ball.img = images.sprite1
	ball.x = ball.body:getX() - Camera.x
	ball.y = ball.body:getY()
	ball.angle = ball.body:getAngle()
	ball.sx = (ball.w)/ball.img:getWidth() 
	ball.sy = (ball.h)/ball.img:getHeight()
	ball.orientX = ball.img:getWidth()/2
	ball.orientY = ball.img:getHeight()/2
	love.graphics.draw(ball.img, ball.x, ball.y, ball.angle, ball.sx, ball.sy, ball.orientX, ball.orientY)
--	love.graphics.circle("fill", ball.body:getX() - Camera.x, ball.body:getY(), ball.shape:getRadius())
   
	love.graphics.setColor(0.20, 0.20, 0.20) -- set the drawing color to grey for the blocks
	for _, pipe in pairs(pipes) do	--Draw the pipes
		pipe.img = images.pipe
		pipe.x = pipe.one.body:getX() + pipeStats.w/2 - Camera.x 
		pipe.y = pipe.one.body:getY() + pipe.one.height/2
		pipe.o = math.pi
		pipe.sx = pipe.one.width/pipe.img:getWidth()
		love.graphics.draw(pipe.img, pipe.x, pipe.y, pipe.o, pipe.sx, 1)

		pipe.img = images.pipe
		pipe.x = pipe.two.body:getX() - pipeStats.w/2 - Camera.x
		pipe.y = pipe.two.body:getY() - pipe.two.height/2
		pipe.o = 0
		pipe.sx = pipe.two.width/pipe.img:getWidth()
		love.graphics.draw(pipe.img, pipe.x, pipe.y, pipe.o, pipe.sx, 1)
	end

	if game.started == false then
		love.graphics.draw(images.tapToStart, screen.w/2 - images.tapToStart:getWidth()/2, screen.h/2 - images.tapToStart:getHeight()/2)
	else
		font = love.graphics.newFont(14)
		text = love.graphics.newText(font, "Score: "..game.score.cur)
		love.graphics.draw(text, screen.w/2, screen.h * 3/4)
	end

  end

function love.keypressed(button)
	if button == "space" then
		if game.over == false then
			game.started = true
			ball.body:setType("dynamic")
			ball.body:setLinearVelocity(200, 0)
			ball.body:applyLinearImpulse(0, -100)
			ball.body:setAngle(-0.3)
			ball.body:setAngularVelocity(0)
			ball.body:applyAngularImpulse( 70 )
		else
			newGame()	
		end
	end
end