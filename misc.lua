function PrintT(ta)
    for index, value in ipairs(ta) do
        for i2, v2 in ipairs(value) do
            print(index, i2, v2)
        end
    end
end

function PrintT2(ta)
    for index, value in ipairs(ta) do
        local line = 'line ' .. index .. ': '
        for i2, v2 in ipairs(value) do
            line = line .. ' ' .. v2
        end
        print(line)
    end
end

function Transpose(tab)
    local translated = {}

    for i = 1, #tab[1] do
        table.insert(translated, i, {})
    end

    for y, row in ipairs(tab) do
        for x, cel in ipairs(row) do
            table.insert(translated[x], y, cel)
        end
    end

    return translated
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r(t, level)
    level = level or (1/0)
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

local t1 = {
    { 1, 2, 3 },
    { 4, 5, 6 },
    { 7, 8, 9 }
}
local t2 = Transpose(t1)

local t3 = {
    {
        {11, 12, 13},
    },
    {
        {21, 22, 23}
    }
}

local t4 = {
    {
        {
            {111, 112, 113},
            {121, 122, 123}
        },
        {
            {211, 212, 213},
            {221, 222, 223}
        }
    },
    {
        { 21, 22, 23 },
        { 31, 32, 33}
    }
}

-- PrintT2(t1)
-- PrintT2(t2)

print_r(t4, 2)