require('Vars')
require('Bird')

Background = {
    img = Images.background,
    y = 0,
    x1 = 0,
    x2 = Images.background:getWidth(),
    sy = Screen.h / Images.background:getHeight()
}

function Background.reset()
    Background.x1 = 0
    Background.x2 = Background.img:getWidth()
end

function Background.scroll()
    if Background.x1 < Background.x2 and Background.x2 < Bird.body:getX() - Screen.w/2 then
        Background.x1 = Background.x2 + Background.img:getWidth()
    elseif Background.x2 < Background.x1 and Background.x1 < Bird.body:getX() - Screen.w/2 then
        Background.x2 = Background.x1 + Background.img:getWidth()
    end
end

function Background.draw()
    love.graphics.draw(Background.img, Background.x1 - Camera.x, Background.y, 0, 1, Background.sy)
    love.graphics.draw(Background.img, Background.x2 - Camera.x, Background.y, 0, 1, Background.sy)
end