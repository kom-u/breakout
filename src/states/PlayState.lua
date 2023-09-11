PlayState = Class { __includes = BaseState }

function PlayState:init()
    self.paddle = Paddle()
    self.paused = false

    self.ball = Ball(math.random(7))
    self.ball.deltaX = math.random(-200, 200)
    self.ball.deltaY = math.random(-50, 60)
    self.ball.x = VIRTUAL_WIDTH / 2 - 4
    self.ball.y = VIRTUAL_HEIGHT - 42

    self.bricks = LevelMaker:createMap()
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:isCollide(self.paddle) then
        -- raise ball above paddle in case it goes below it, then reverse dy
        self.ball.y = self.paddle.y - 8
        self.ball.deltaY = -self.ball.deltaY

        --
        -- tweak angle of bounce based on where it hits the paddle
        --

        -- if we hit the paddle on its left side while moving left...
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.deltaX < 0 then
            self.ball.deltaX = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))

            -- else if we hit the paddle on its right side while moving right...
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.deltaX > 0 then
            self.ball.deltaX = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        gSounds['paddle-hit']:play()
    end

    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
        -- only check collision if we're in play
        if brick.inPlay and self.ball:isCollide(brick) then
            -- trigger the brick's hit function, which removes it from play
            brick:hit()

            --
            -- collision code for bricks
            --
            -- we check to see if the opposite side of our velocity is outside of the brick;
            -- if it is, we trigger a collision on that side. else we're within the X + width of
            -- the brick and should check to see if the top or bottom edge is outside of the brick,
            -- colliding on the top or bottom accordingly
            --

            -- left edge; only check if we're moving right
            if self.ball.x + 2 < brick.x and self.ball.deltaX > 0 then
                -- flip x velocity and reset position outside of brick
                self.ball.deltaX = -self.ball.deltaX
                self.ball.x = brick.x - 8

                -- right edge; only check if we're moving left
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.deltaX < 0 then
                -- flip x velocity and reset position outside of brick
                self.ball.deltaX = -self.ball.deltaX
                self.ball.x = brick.x + 32

                -- top edge if no X collisions, always check
            elseif self.ball.y < brick.y then
                -- flip y velocity and reset position outside of brick
                self.ball.deltaY = -self.ball.deltaY
                self.ball.y = brick.y - 8

                -- bottom edge if no X collisions or top collision, last possibility
            else
                -- flip y velocity and reset position outside of brick
                self.ball.deltaY = -self.ball.deltaY
                self.ball.y = brick.y + 16
            end

            -- slightly scale the y velocity to speed up the game
            self.ball.deltaY = self.ball.deltaY * 1.02

            -- only allow colliding with one brick, for corners
            break
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    self.paddle:render()
    self.ball:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end
