Screen = {
    w = 1200,
    h = 700
}

Game = {
    started = false,
    over = false,
    score = {
        cur = 0,
        best = 0
    },
    time = -1
}

Images = {
    tapToStart = love.graphics.newImage("images/tap_to_start.png"),
    sprite1 = love.graphics.newImage("images/sprite1.png"),
    sprite2 = love.graphics.newImage("images/sprite2.png"),
    pipe = love.graphics.newImage("images/pipe.png"),
    background = love.graphics.newImage("images/background.png")
}