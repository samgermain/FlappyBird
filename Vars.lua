Screen = {
    w = 1200,
    h = 700
}

Sounds = {
    hit = love.audio.newSource("sounds/hit.wav", "static"),
    fail = love.audio.newSource("sounds/fail.wav", "static"),
    point = love.audio.newSource("sounds/point.wav", "static"),
    swoosh = love.audio.newSource("sounds/swoosh.wav", "static"),
    wing = love.audio.newSource("sounds/wing.wav", "static")
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