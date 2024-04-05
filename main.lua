love = require("love")

function love.load()
    love.window.setTitle("Shooting Gallery")
    target = {
        x = 300,
        y = 300,
        radius = 50
    }
    score = 0
    timer = 0
    gameState = 1

    gameFont = love.graphics.newFont(40)

    sprites = {
        sky = love.graphics.newImage('sprites/sky.png'),
        crosshairs = love.graphics.newImage('sprites/crosshairs.png'),
        target = love.graphics.newImage('sprites/target.png')
    }

    sounds = {
        music = love.audio.newSource('sounds/music.mp3', 'static'),
        shot = love.audio.newSource('sounds/shot.ogg', 'static')
    }
    sounds.music:setLooping(true)
    love.mouse.setVisible(false)
    love.audio.play(sounds.music)
end

function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end

    if timer < 0 then
        timer = 0
        gameState = 1
        score = 0
    end
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0)

    love.graphics.setFont(gameFont)
    love.graphics.print("Pontos: "..score, 5, 5)
    love.graphics.print("Tempo: "..math.ceil(timer), love.graphics.getWidth() - 220, 5)

    if gameState == 1 then
        love.graphics.printf("Clique em qualquer lugar para começar", 0, 250, love.graphics.getWidth(), "center")
    end

    if gameState == 2 then
        love.graphics.draw(sprites.target, target.x- target.radius, target.y- target.radius)
    end
    love.graphics.draw(sprites.crosshairs, love.mouse.getX()- 20, love.mouse.getY() - 20)
 end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and gameState == 2 then
        love.audio.stop(sounds.shot)
        love.audio.play(sounds.shot)
        local distance = distanceBetween(x, y, target.x, target.y)
        if distance <= target.radius then
            score = score + 1
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        else
            score = score - 1
        end
    elseif button == 1 and gameState == 1 then
        gameState = 2
        timer = 30
    end
end

function distanceBetween(x1, y1, x2, y2)
    distance = math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
    return distance
end
