Brick = Class {}

function Brick:init(x, y)
    -- used for coloring and score calculation
    self.tier = 0
    self.color = 1

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16

    -- used to determine whether this brick should be rendered
    self.inPlay = true
end

--[[
    Triggers a hit on the brick, taking it out of play if at 0 health or
    changing its color otherwise.
]]
function Brick:hit()
    -- sound on hit
    gSounds['brick-hit-2']:play()

    self.inPlay = false
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'],
            -- multiply color by 4 (-1) to get our color offset, then add tier to that
            -- to draw the correct tier and color brick onto the screen
            gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
            self.x, self.y)
    end
end
