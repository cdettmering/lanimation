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



--- Lanimation ---
-- Spritesheet animation library for LOVE 2D
-- NOTE: This library does not support jagged sprite sheets, although it is
--       acceptable to have the very last row jagged.

LANIMATION_PATH = LANIMATION_PATH or 'lanimation/'

-- Return the library packed in a table


chanimation =  { SpriteSheet = require(LANIMATION_PATH .. 'SpriteSheet'), 
                 Animation = require(LANIMATION_PATH .. 'Animation'),
                 AnimationPath = require(LANIMATION_PATH .. 'AnimationPath'), 
                 interpolation = require(LANIMATION_PATH .. 'interpolation') }

return chanimation
