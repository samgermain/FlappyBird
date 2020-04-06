require('Camera')
require('Background')
require('Bird')
require('World')
require('Ground')
require('Pipes')
--Android banner
--App ID:  ca-app-pub-6273488784837824~4269860143
--Ad unit id: ca-app-pub-6273488784837824/7494611678

function love.load()
	--initial graphics setup
	love.graphics.setBackgroundColor(0.41, 0.53, 0.97) --set the background color to a nice blue
	love.window.setMode(Screen.w, Screen.h) --set the window dimensions to 650 by 650
end

function newGame()
	Pipes.x = Screen.w
	Game.over = false
	Bird.reset()
	Ground.reset()
	Pipes.reset()
	Background.reset()
	Game.started = false
	Game.score.cur = 0
end
   
function love.update(dt)
	Camera:follow(dt, Bird)
	World:update(dt) 
	for _, pipe in pairs(Pipes.pipes) do
		Pipes:updatePosition(pipe)
		if pipe.one.body:getX() <= Bird.body:getX() and pipe.scored == false then	--Check if the player has passed a set of pipes
			Game.score.cur = Game.score.cur + 1
			pipe.scored = true
			if Game.score.cur > Game.score.best then
				Game.score.best = Game.score.cur
			end
		end
		Pipes:collision(pipe)
	end
	Ground.collision()
	Background.scroll()
	Ground.updatePosition()
end
   
function love.draw()
	Background.draw()
	Bird.draw()
	Ground.draw()
	Pipes.draw()

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
			Game.time = love.timer.getTime()
			Bird.jump()
		else
			newGame()	
		end
	end
end