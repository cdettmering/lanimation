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



--- SpriteSheet ---

-- Setup
local assert = assert
local SpriteSheet = {}
local SpriteSheet_mt = {}
SpriteSheet_mt.__index = SpriteSheet

-- Creates a new SpriteSheet, this function requires all 3 parameters to be valid
-- param image: A LOVE Image that contains an entire sprite sheet
-- param frameWidth: The width of an individual frame (frame width cannot be 
--                   dynamic)
-- param frameHeight: The height of an individual frame (frame height cannot
--                    be dynamic)
function SpriteSheet:new(image, frameWidth, frameHeight)
    assert(image and frameWidth and frameHeight, 'SpriteSheet:new - Needs ' .. 
           'all 3 parameters: image, width of frame, width of height')

    local spritesheet = {}
    spritesheet.image = image
    spritesheet.frameWidth = frameWidth
    spritesheet.frameHeight = frameHeight
    spritesheet.numberOfRows = spritesheet.image:getHeight() / spritesheet.frameHeight
    spritesheet.numberOfColumns = spritesheet.image:getWidth() / spritesheet.frameWidth

    return setmetatable(spritesheet, SpriteSheet_mt)
end

return SpriteSheet
