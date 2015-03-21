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



--- AnimationPath ---

-- Setup local access
local assert = assert
local interpolation = require(LANIMATION_PATH .. 'interpolation')
local AnimationPath = {}
local AnimationPath_mt = {}
AnimationPath_mt.__index = AnimationPath

-- Creates a new AnimationPath
-- param interpolationFunction: The function to use when interpolating the
--                              animation values. Predefined functions are 
--                              available in chanimation.interpolation.
--                              Default is chanimation.interpolation.linear
function AnimationPath:new(interpolationFunction)
    
    local path = {}
    path.xPath = {}
    path.yPath = {}
    path.rPath = {}
    path.sxPath = {}
    path.syPath = {}
    path.timePath = {}
    path.isPlaying = false
    
    -- Private:
    path._pointCount = 1
    path._elapsedTime = 0
    path._currentPoint = 1
    path._duration = 0
    path._currentX = 0
    path._currentY = 0
    path._currentR = 0
    path._currentSX = 0
    path._currentSY = 0
    path._func = interpolationFunction or interpolation.linear

    return setmetatable(path, AnimationPath_mt)
end

-- Adds a point to the AnimationPath, a point can only be added if the AnimationPath
-- is stopped. This function is a no-op for AnimationPath objects that are playing.
-- param time: The time at which to be at this point (in seconds).
--             NOTE: Time is relative to the start of the AnimationPath, this is
--             NOT absolute or global time. For example if this parameter is set 
--             to 5, then this point will be reached 5 seconds after the
--             AnimationPath begins playing.
-- param x: The x value of the point's position
-- param y: The y value of the point's position
-- param r: The rotation of the point
-- param sx: The x value of the point's scale value
-- param sy: The y value of the point's scale value
function AnimationPath:addPoint(time, x, y, r, sx, sy)
    -- cannot add a point to an animation path that is playing
    if(self.isPlaying) then
        return
    end

    assert(time, 'AnimationPath:addPoint - Requires time parameter to be set')

    local _x = x or 0
    local _y = y or 0
    local _r = r or 0
    local _sx = sx or 1
    local _sy = sy or 1


    self.xPath[self._pointCount] = _x
    self.yPath[self._pointCount] = _y
    self.rPath[self._pointCount] = _r
    self.sxPath[self._pointCount] = _sx
    self.syPath[self._pointCount] = _sy
    self.timePath[self._pointCount] = time
    self._pointCount = self._pointCount + 1
end

-- Updates the AnimationPath
-- param dt: Time elapsed since last update (in seconds).
function AnimationPath:update(dt)
    -- do not update if we are stopped
    if not self.isPlaying then return end

    self._elapsedTime = self._elapsedTime + dt

    -- time is greater than the point the path was getting to, meaning the path
    -- needs to go towards the next point
    if self._elapsedTime >= self._duration then
        self._elapsedTime = self._elapsedTime - self._duration
        self._currentPoint = self._currentPoint + 1
        -- at the last point? then the path has finished, so stop
        if self._currentPoint == self._pointCount then
            -- set all values to the last frame
            self._currentX = self.xPath[self._pointCount - 1]
            self._currentY = self.yPath[self._pointCount - 1]
            self._currentR = self.rPath[self._pointCount - 1]
            self._currentSX = self.sxPath[self._pointCount - 1]
            self._currentSY = self.syPath[self._pointCount - 1]

            -- stop
            self:stop()
            return
        -- not at last point just yet...update target time
        else
            self._duration = self.timePath[self._currentPoint] - 
                               self.timePath[self._currentPoint - 1]
        end

    end

    --interpolate all of the values
    self._currentX = self._func(self.xPath[self._currentPoint - 1], 
                                self.xPath[self._currentPoint],
                                self._elapsedTime,
                                self._duration)

    self._currentY = self._func(self.yPath[self._currentPoint - 1], 
                                self.yPath[self._currentPoint],
                                self._elapsedTime,
                                self._duration)

    self._currentR = self._func(self.rPath[self._currentPoint - 1], 
                                self.rPath[self._currentPoint],
                                self._elapsedTime,
                                self._duration)

    self._currentSX = self._func(self.sxPath[self._currentPoint - 1], 
                                 self.sxPath[self._currentPoint],
                                 self._elapsedTime,
                                 self._duration)

    self._currentSY = self._func(self.syPath[self._currentPoint - 1], 
                                 self.syPath[self._currentPoint],
                                 self._elapsedTime,
                                 self._duration)
end

-- Gets the current values of the AnimationPath
-- return: x, y, r, sx, sy
--
-- NOTE: This function is meant to be used as the parameters to draw()
-- Example: Animation:draw(AnimationPath:getCurrentValues)
function AnimationPath:getCurrentValues()
    return self._currentX, self._currentY, self._currentR, self._currentSX, 
           self._currentSY
end

-- Begins the AnimationPath
-- NOTE: Points cannot be added until a call to stop has been issued.
function AnimationPath:play()
    if self:_validatePoints() then
        self.isPlaying = true
    end
end

-- Stops the AnimationPath
function AnimationPath:stop()
    self.isPlaying = false
end

-- Private:


-- Validates the points in the Animation to make sure the Path doesn't go
-- backwards in time.
function AnimationPath:_validatePoints()
    -- need at least 2 points to interpolate correctly
    if self._pointCount <= 2 then
        return false
    end

    for i = 1, self._pointCount - 2 do
        -- make sure the time is ascending, everything else does not matter
        if self.timePath[i] > self.timePath[i + 1] then
            return false
        end
    end

    self._duration = self.timePath[1]
    return true
end

return AnimationPath
