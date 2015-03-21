lanimation = require('lanimation/lanimation')

function love.load()
    love.window.setTitle('lanimation test')

    spritesheet = lanimation.SpriteSheet:new(love.graphics.newImage('star-green.png'), 80, 80)
    animation = lanimation.Animation:new(spritesheet, 1, 71, 0.1, 'loop')
    animation:play()

    spritesheet2 = lanimation.SpriteSheet:new(love.graphics.newImage('anim-boogie.png'), 32, 32)
    animation2 = lanimation.Animation:new(spritesheet2, 1, 6, 0.1, 'loop')
    animation2:play()

    animationPath = lanimation.AnimationPath:new(lanimation.interpolation.root)
    animationPath:addPoint(0, 175, 100, 0, 1, 1)
    animationPath:addPoint(5, 475, 100, 0, 1, 1)
    animationPath:addPoint(10, 475, 400, 0, 1, 1)
    animationPath:addPoint(15, 475, 100, 0, 1, 1)
    animationPath:addPoint(20, 475, 100, 0, 5, 5)
    animationPath:addPoint(25, 475, 100, 0, 1, 1)
    animationPath:addPoint(30, 475, 100, 6.28, 1)

    animationPath:play()
                                               
    love.graphics.setBackgroundColor(75,75,75)
end

function love.update(dt)
    animation:update(dt)
    animation2:update(dt)
    animationPath:update(dt)
end

function love.draw()
    animation:draw(100, 100)
    x, y, r, sx, sy = animationPath:getCurrentValues()
    animation2:draw(animationPath:getCurrentValues())
end
