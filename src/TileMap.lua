--[[
    GD50
    Super Mario Bros. Remake

    -- TileMap Class --
]]

TileMap = Class{}

function TileMap:init(width, height)
    self.width = width
    self.height = height
    self.tiles = {}
end

--[[
    If our tiles were animated, this is potentially where we could iterate over all of them
    and update either per-tile or per-map animations for appropriately flagged tiles!
]]
function TileMap:update(dt)

end

--[[
    Returns the x, y of a tile given an x, y of coordinates in the world space.
]]
function TileMap:pointToTile(x, y)
    if x < 0 or x > self.width * TILE_SIZE or y < 0 or y > self.height * TILE_SIZE then
        return nil
    end

    return self.tiles[math.floor(y / TILE_SIZE) + 1][math.floor(x / TILE_SIZE) + 1]
end

function TileMap:render()
    for y = 1, self.height do
        for x = 1, self.width do
            self.tiles[y][x]:render()
        end
    end
end

function TileMap:checkColumnSoil(x)
    for y, cols in ipairs(self.tiles) do
        if cols[x].id == TILE_ID_GROUND then
            return true
        end
    end
    return false
end

function TileMap:findTopperY(x)
    for y, cols in ipairs(self.tiles) do
        if cols[x].topper then
            return y
        end
    end

    return nil
end

function TileMap:findSaveSlots(params)
    local height = params.height or 0
    local endSlot = params.backwards and 1 or self.width
    local step = params.backwards and -1 or 1

    for x = params.refX, endSlot, step do
        if self:checkColumnSoil(x) then
            local topper = self:findTopperY(x)
            local y = topper - 1 - height
            if y > 0 then
                return { x = x, y = y }
            end
        end
    end

    error('No safe place')
end

function TileMap:findSafeFreeSlot(objects, params)
    local refX = params.refX
    local sgn = params.backwards and -1 or 1

    local condition = function(pos)
        -- print_r(pos)
        local candidate = {
            x = (pos.x - 1) * TILE_SIZE,
            y = (pos.y - 1) * TILE_SIZE,
            width = TILE_SIZE,
            height = TILE_SIZE
        }

        -- print_r(candidate)
        for _, object in pairs(objects) do
            if object:collides(candidate) then
                return false
            end
        end

        return true
    end

    local changes = { refX = 1 }
    local mapper = function(prev, pos) return prev + sgn * pos end

    return RepeatIf(condition, function(x) return self:findSaveSlots(x) end, params, changes, mapper)
end
