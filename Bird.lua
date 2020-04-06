require('Vars')
require('World')

Bird = {
    x = Screen.w/2,
    y = Screen.h/2,
    w = 40,
    h = 40
}
Bird.body = love.physics.newBody(World, Bird.x, Bird.y, "static") --place the body in the center of the world and make it dynamic, so it can move around
Bird.shape = love.physics.newRectangleShape(Bird.w, Bird.h) --the Bird's shape has a radius of 20
Bird.fixture = love.physics.newFixture(Bird.body, Bird.shape, 1) -- Attach fixture to body and give it a density of 1.
Bird.fixture:setFriction(0)

function Bird.reset()
    Bird.body:setX(Screen.w/2)
	Bird.body:setY(Screen.h/2)
	Bird.body:setType("static")
	Bird.body:setLinearVelocity(0, 0)
    Bird.body:setAngle(0)
end

function Bird.draw()
    if love.timer.getTime() - Game.time < 0.2 then
        Bird.img = Images.sprite1
    else
        Bird.img = Images.sprite2
    end
    Bird.x = Bird.body:getX() - Camera.x
	Bird.y = Bird.body:getY()
	Bird.angle = Bird.body:getAngle()
	Bird.sx = (Bird.w)/Bird.img:getWidth() 
	Bird.sy = (Bird.h)/Bird.img:getHeight()
	Bird.orientX = Bird.img:getWidth()/2
	Bird.orientY = Bird.img:getHeight()/2
	love.graphics.draw(Bird.img, Bird.x, Bird.y, Bird.angle, Bird.sx, Bird.sy, Bird.orientX, Bird.orientY)
end

function Bird.jump()
    Bird.body:setType("dynamic")
    Bird.body:setLinearVelocity(200, 0)
    Bird.body:applyLinearImpulse(0, -100)
    Bird.body:setAngle(-0.3)
    Bird.body:setAngularVelocity(0)
    Bird.body:applyAngularImpulse( 70 )
end