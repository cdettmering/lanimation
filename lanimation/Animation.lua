--[[Copyright (c) 2011 Chad Dettmering

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.--]]



--- Animation ---

-- Setup local access 
local floor = math.floor
local min = math.min
local max = math.max
local love = love
local assert = assert
local Animation = {}
local Animation_mt = {}
Animation_mt.__index = Animation

-- Creates a new Animation, this function requires that 'spritesheet' is a
-- Chanimation SpriteSheet created from SpriteSheet:new.
-- param spritesheet: A Chanimation SpriteSheet created from SpriteSheet:new
-- param startFrame: The starting frame of this animation (frames start counting 
--                   at 1)
-- param endFrame: The ending frame of this animation (frames start counting at 1)
-- param frameDelay: The time delay (in seconds) between frame updates
-- param mode: Specifies the mode in which to play the Animation. Valid modes
--             include: 
--             'once' - Plays the Animation one time through and stops
--             'loop' - Plays the Animation through and repeats infinitely
--             'bounce' - Plays the Animation one time through and then reverses
--                        direction. This creates a ping-pong effect, where the
--                        Animation keeps playing forward, reverse, forward, 
--                        reverse
-- param direction: Specifies the direction in which to play the Animation. Valid
--                  directions include:
--                  'forward' - Plays the Animation from startFrame to endFrame
--                  'reverse' - Plays the Animation from endFrame to startFrame
function Animation:new(spritesheet, startFrame, endFrame, frameDelay, mode, direction)
    assert(spritesheet, 'Animation:new - Needs a valid spritesheet created ' ..
                        'from SpriteSheet:new')

    local animation = {}
    animation.spritesheet = spritesheet
    animation.startFrame = startFrame or 0
    animation.endFrame = endFrame or 0
    animation.frameDelay = frameDelay or 0.1
    animation.mode = mode or 'once'
    animation.direction = direction or 'forward'
    animation.isPlaying = false
    
    -- Private:

    -- if the direction is reverse, then start at the end
    if animation.direction == 'reverse' then
        animation._currentFrame = animation.endFrame
    else
        animation._currentFrame = animation.startFrame
    end

    animation._totalTimeElapsed = 0
    animation._numberOfFrames = animation.endFrame - animation.startFrame + 1

    -- Setup a table of LOVE Quads, these quads will define the frame for the
    -- animation sequence.
    animation._quads = {}
    for i = animation.startFrame, animation.endFrame do
        
        -- compute x value for top left corner of frame inside the sprite sheet
        local x = floor(i /  animation.spritesheet.numberOfColumns)

        -- compute y value for top left corner of frame inside the sprite sheet
        local y = i % animation.spritesheet.numberOfRows

        animation._quads[i] = love.graphics.newQuad(x * animation.spritesheet.frameWidth,
                                             y * animation.spritesheet.frameHeight,
                                             animation.spritesheet.frameWidth,
                                             animation.spritesheet.frameHeight,
                                             animation.spritesheet.image:getWidth(),
                                             animation.spritesheet.image:getHeight()
                                             )
    end

    return setmetatable(animation, Animation_mt)
end

-- Updates the Animation
-- param dt: Time elapsed since last frame (in seconds)
function Animation:update(dt)
    -- add in the time elapsed since last frame
    self._totalTimeElapsed = self._totalTimeElapsed + dt

    -- if the total time elapsed since the last frame update has exceeded the
    -- defined frame delay, then go to the next frame
    if self._totalTimeElapsed > self.frameDelay then
        self._totalTimeElapsed = self._totalTimeElapsed - self.frameDelay
        self:_nextFrame()
    end
end

function Animation:draw(x, y, r, sx, sy, ox, oy)
    love.graphics.draw(self.spritesheet.image, self._quads[self._currentFrame], x, y, r, sx, sy, ox, oy)
end

-- Stops the Animation at the current frame
function Animation:stop()
    self.isPlaying = false
end

-- Starts the Animation at the current frame. NOTE: This function must be called
-- once after the Animation is created to start the sequence.
function Animation:play()
    self.isPlaying = true
end

-- Sets the mode of the Animation, same mode from Animation:new
function Animation:setMode(mode)
    self.mode = mode or 'once'
end

-- Sets the direction of the Animation, same direction from Animation:new
function Animation:setDirection(direction)
    self.direction = direction or 'forward'
end

-- Sets the frameDelay of the Animation, same frameDelay from Animation:new
function Animation:setFrameDelay(delay)
    self.frameDelay = delay or 0.1
end


-- Steps the Animation to the next frame
function Animation:_nextFrame()

    -- don't even attempt to play the next frame if the animation is currently
    -- inactive
    if not self.isPlaying then return end

    -- if the animation is going forward increment the frame by 1
    if self.direction == 'forward' then
        self._currentFrame = self._currentFrame + 1
        -- check if the animation is over
        if self._currentFrame > self._numberOfFrames then
            -- stop at the last frame for 'once' mode
            if self.mode == 'once' then
                self:stop()
                self._currentFrame = self._numberOfFrames
            -- go back to beginning for 'loop' mode
            elseif self.mode == 'loop' then
                self._currentFrame = self.startFrame
            -- set the direction to reverse to get the 'bounce' effect
            elseif self.mode == 'bounce' then
                self.direction = 'reverse'

                --try not to repeat the last frame twice
                self._currentFrame = max(self._numberOfFrames - 1, self.startFrame)
            end
        end
    elseif self.direction == 'reverse' then
        self._currentFrame = self._currentFrame - 1
        if self._currentFrame < self.startFrame then
            if self.mode == 'once' then
                self:stop()
                self._currentFrame = self.startFrame
            elseif self.mode == 'loop' then
                self._position = self._numberOfFrames
            elseif self.mode == 'bounce' then
                self.direction = 'forward'

                --try not to repeat the first frame twice
                self._currentFrame = min(self.startFrame + 1, self.endFrame)
            end
        end
    end
end

return Animation
