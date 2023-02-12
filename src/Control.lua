

local keyMap = {
    up = { kb = 'up', gp = 'dpup' },
    right = { kb = 'right', gp = 'dpright' },
    down = { kb = 'down', gp = 'dpdown' },
    left = { kb = 'left', gp = 'dpleft' },
    buttonA = { kb = 'space', gp = 'a' },
    buttonB = { kb = 'lshift', gp = 'b' },
    start = { kb = 'return', gp = 'start' },
    quit = { kb = 'escape', gp = 'back' }
}

Control = Class{}

function Control:init(position)
    self.position = position
    self.up = false
    self.right = false
    self.down = false
    self.left = false
    self.buttonA = false
    self.buttonB = false

    local joysticks = love.joystick.getJoysticks()

    self.joystick = joysticks[position]


end

function Control:update(dt)
    for key, _ in pairs(keyMap) do
        self:updateKey(key)
    end
end

function Control:updateKey(key)
    if self:keyboardDown(key) or self:gamepadDown(key) then
        self[key] = true
    else
        self[key] = false
    end
end

function Control:keyboardDown(label)
    local key = keyMap[label].kb

    return key and love.keyboard.isDown(key)
end

function Control:gamepadDown(label)
    if not self.joystick then return end

    local key = keyMap[label].gp

    return key and self.joystick:isGamepadDown(key)
end


