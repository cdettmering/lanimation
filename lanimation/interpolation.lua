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



--- interpolation ---


-- Setup local access
local pow = math.pow
local sqrt = math.sqrt

-- Performs linear interpolation
-- param start: The starting point of the interpolation.
-- param finish: The ending point of the interpolation.
-- param time: The current time elapsed since the start of the interpolation.
-- param duration: The total duration time (in seconds) of the interpolation.
local function linear(start, finish, time, duration)
    local s = start or 0
    local e = finish or 0
    local t = time or 0
    local d = duration or 1

    return (s + ((e - s) * (t / d)))
end

local function square(start, finish, time, duration)
    local s = start or 0
    local e = finish or 0
    local t = time or 0
    local d = duration or 1

    local factor = pow(t / d, 2)

    return (s + ((e - s) * factor))
end

local function root(start, finish, time, duration)
    local s = start or 0
    local e = finish or 0
    local t = time or 0
    local d = duration or 1

    return (s + ((e - s) * sqrt(t / d)))
end

local interpolation = { linear = linear, square = square, root = root }


return interpolation
