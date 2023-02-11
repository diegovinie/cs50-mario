

TestState = Class{__includes = BaseState}

function TestState:init()
    self.camX = 0
    self.camY = 0
    self.level = LevelMaker.generate(20, 10)
    self.tileMap = self.level.tileMap
    self.background = 1
    self.backgroundX = 0

    print_r(self.tileMap, 2)

    self.gravityOn = false
    self.gravityAmount = 6

    self.player = Player({
        x = 0,
        y = 0,
        width = 16,
        height = 20,
        texture = 'green-alien',
        map = self.tileMap,
        level = self.level,
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end
        },
    })

    self.player:changeState('falling')

    local enemy
    enemy = Snail({
        texture = 'creatures',
        x = 7 * 16,
        y = 16*5 + 2,
        width = 16,
        height = 16,
        stateMachine = StateMachine {
            ['idle'] = function() return SnailIdleState(self.tileMap, self.player, enemy) end,
                ['moving'] = function() return SnailMovingState(self.tileMap, self.player, enemy) end,
                ['chasing'] = function() return SnailChasingState(self.tileMap, self.player, enemy) end
        }
    })

    enemy:changeState('idle', { wait = 3 } )
    table.insert(self.level.entities, enemy)
end

function TestState:update(dt)
    self.player:update(dt)
    self.level:update(dt)
end

function TestState:render()
    love.graphics.draw(
        gTextures['backgrounds'],
        gFrames['backgrounds'][self.background],
        math.floor( -self.backgroundX),
        0
    )

    love.graphics.draw(
        gTextures['backgrounds'],
        gFrames['backgrounds'][self.background],
        0,
        gTextures['backgrounds']:getHeight() / 3 * 2,
        0,
        1,
        -1
    )

    self.level:render()
    self.player:render()
end


