--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StartState = Class{__includes = BaseState}

function StartState:init()
    self.map = LevelMaker.generate(100, 10)
    self.background = math.random(3)
end

function StartState:update(dt)
    -- anti bouncing needed | love.keyboard.wasPressed('enter')
    -- gControl:keyPressed('start')
    if gControl.keysPressed.start or gControl.keysPressed.buttonA then
        gStateMachine:change('play')
    end
end

function StartState:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0, 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0,
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    self.map:render()

    gUI.renderMainTitle('Super 50 Bros.')

    gUI.renderLowerTitle('Press Enter')
end