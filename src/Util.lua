--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Helper functions for writing Match-3.
]]

---
--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly. ]]
---
---@param atlas love.Image
---@param tilewidth number
---@param tileheight number
---@return table<love.Quad>
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

---
---Divides quads we've generated via slicing our tile sheet into separate tile sets.
---
---@param quads table<love.Quad>
---@param setsX   integer
---@param setsY   integer
---@param sizeX   integer
---@param sizeY   integer
---@return table<love.Quad>
---@nodiscard
function GenerateTileSets(quads, setsX, setsY, sizeX, sizeY)
    local tilesets = {}
    local tableCounter = 0
    local sheetWidth = setsX * sizeX
    local sheetHeight = setsY * sizeY

    -- for each tile set on the X and Y
    for tilesetY = 1, setsY do
        for tilesetX = 1, setsX do

            -- tileset table
            table.insert(tilesets, {})
            tableCounter = tableCounter + 1

            for y = sizeY * (tilesetY - 1) + 1, sizeY * (tilesetY - 1) + 1 + sizeY do
                for x = sizeX * (tilesetX - 1) + 1, sizeX * (tilesetX - 1) + 1 + sizeX do
                    table.insert(tilesets[tableCounter], quads[sheetWidth * (y - 1) + x])
                end
            end
        end
    end

    return tilesets
end

---Return the Post frames
---
---@param quads table<love.Quad>
---@return table<love.Quad>
function GetFlagFrames(quads)
    local frames = {}

    for i = 7, 63, 9 do
        table.insert(frames, quads[i])
    end

    return frames
end

---Return the Flag frames
---
---@param quads table<love.Quad>
---@return table<love.Quad>
function GetPostFrames(quads)
    local frames = {}

    for i = 3, 6 do
        table.insert(frames, quads[i])
    end

    return frames
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r(t, level)
    level = level or (1 / 0)
    local print_r_cache = {}
    local function sub_print_r(t, indent, l)
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table" and l < level) then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8), l + 1)
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end
    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_print_r(t, "  ", 0)
        print("}")
    else
        sub_print_r(t, "  ", 0)
    end
    print()
end

function Transpose(tab)
    local translated = {}

    for x, cols in ipairs(tab) do
        -- local aaa = {}
        table.insert(translated, x, {})
        for y, col in ipairs(cols) do
            table.insert(translated[y], x, col)
        end
    end

    return translated
end

local t1 = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}

function PrintT(ta)
    for index, value in ipairs(ta) do
        for i2, v2 in ipairs(value) do
            print(index, i2, v2)
        end
    end
end

--- Merge two tables but also accept a mapper so the new value will be f(a,b)
--- 
---@param original table
---@param changed table
---@param fun? fun(original: any, changed: any): any by default: f(original, changed) -> changed
---@return table
function MapMergeTables(original, changed, fun)
    fun = fun and fun or function(a, b) return b end

    local result = {}

    for key, value in pairs(original) do
        result[key] = value
    end

    for key, value in pairs(changed) do
        result[key] = fun(original[key], value)
    end

    return result
end

---Execute the function until the result complies the condition
---
---This is meant to use with random functions, but in case, you can change the function parameters with changes and mapper.
--- 
---@generic Res : any Result
---@generic Args : table
---@param condition fun(result: Res): boolean Function that evaluates the result
---@param fn fun(args: Args): Res The function tested
---@param args Args Parameters for the tested function
---@param changes? Args Changes in the parameters, by default it replaces them
---@param mapper? fun(origin: any, changed: any) A function that changes the parameters
---@return Res
function RepeatIf(condition, fn, args, changes, mapper)
    local result = fn(args)
    changes = changes or {}

    return condition(result) and result or RepeatIf(condition, fn, MapMergeTables(args, changes, mapper), changes, mapper)
end
