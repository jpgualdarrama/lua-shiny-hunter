-- http://tasvideos.org/forum/viewtopic.php?t=4101
-- http://tasvideos.org/forum/viewtopic.php?t=4101&postdays=0&postorder=asc&start=100 my post
-- http://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9mon_data_structure_in_Generation_III
-- luacheck: globals memory bit gui emu joypad
local RUBY_START = 0x03000000 -- luacheck: ignore
local SAPPHIRE_START = RUBY_START -- luacheck: ignore
-- Japanese
local EMERALD_J_START = 0x02024190 -- luacheck: ignore
-- US
local EMERALD_U_START = 0x020244EC -- luacheck: ignore
local FIRERED_START = 0x02024284 -- luacheck: ignore
local LEAFGREEN_START = 0x020241e4 -- luacheck: ignore

-- 0x64 between each pokemon
local PARTY_OFFSETS = {0x4360, 0x43C4, 0x4428, 0x448C, 0x44F0, 0x4554} -- luacheck: ignore
local OPPONENT_OFFSETS = {0x45C0, 0x4624} -- luacheck: ignore

-- Not entirely sure what it is for, but this byte changes from 0xFF when in a battle
local RUBY_BATTLE_MARKER = 0x3000002

-- local natureorder = {"Atk", "Def", "Spd", "SpAtk", "SpDef"}
-- local naturename = {
--     "Hardy", "Lonely", "Brave", "Adamant", "Naughty", "Bold", "Docile",
--     "Relaxed", "Impish", "Lax", "Timid", "Hasty", "Serious", "Jolly", "Naive",
--     "Modest", "Mild", "Quiet", "Bashful", "Rash", "Calm", "Gentle", "Sassy",
--     "Careful", "Quirky"
-- }

local start = RUBY_START + OPPONENT_OFFSETS[1]
local personality
local trainerid
-- local magicword
-- local growthoffset
-- local miscoffset
-- local i

-- local species
-- local ivs
-- local hpiv
-- local atkiv
-- local defiv
-- local spdiv
-- local spatkiv
-- local spdefiv
-- local nature
-- local natinc
-- local natdec

local personality1
local personality2
local secretID
local originalID
local isShiny
local inBattle

local function gatherOpponentData()
    personality = memory.readdwordunsigned(start)
    trainerid = memory.readdwordunsigned(start + 4)
    -- magicword = bit.bxor(personality, trainerid)

    -- i = personality % 24
    -- if i <= 5 then
    --     growthoffset = 0
    -- elseif i % 6 <= 1 then
    --     growthoffset = 12
    -- elseif i % 2 == 0 then
    --     growthoffset = 24
    -- else
    --     growthoffset = 36
    -- end

    -- if i >= 18 then
    --     miscoffset = 0
    -- elseif i % 6 >= 4 then
    --     miscoffset = 12
    -- elseif i % 2 == 1 then
    --     miscoffset = 24
    -- else
    --     miscoffset = 36
    -- end

    -- species = bit.band(bit.bxor(memory.readdwordunsigned(
    --                                 start + 32 + growthoffset), magicword),
    --                    0xFFF)

    -- ivs = bit.bxor(memory.readdwordunsigned(start + 32 + miscoffset + 4),
    --                magicword)

    -- hpiv = bit.band(ivs, 0x1F)
    -- atkiv = bit.band(ivs, 0x1F * 0x20) / 0x20
    -- defiv = bit.band(ivs, 0x1F * 0x400) / 0x400
    -- spdiv = bit.band(ivs, 0x1F * 0x8000) / 0x8000
    -- spatkiv = bit.band(ivs, 0x1F * 0x100000) / 0x100000
    -- spdefiv = bit.band(ivs, 0x1F * 0x2000000) / 0x2000000

    -- nature = personality % 25
    -- natinc = math.floor(nature / 5)
    -- natdec = nature % 5
end

local function processOpponentData()
    inBattle = memory.readbyte(RUBY_BATTLE_MARKER) ~= 0xFF

    personality1 = bit.band(bit.arshift(personality, 16), 0xFFFF);
    personality2 = bit.band(personality, 0xFFFF);
    secretID = bit.arshift(trainerid, 16);
    originalID = bit.band(trainerid, 0xFFFF);

    local shinyFactor = bit.bxor(personality1, personality2);
    shinyFactor = bit.bxor(shinyFactor, secretID);
    shinyFactor = bit.bxor(shinyFactor, originalID);
    isShiny = shinyFactor < 8
end

local function printOpponentData()
    -- gui.text(0, 0, "HP IV=" .. hpiv, "yellow")
    -- gui.text(0, 10, "Atk IV=" .. atkiv, "red")
    -- gui.text(50, 10, "Def IV=" .. defiv, "orange")
    -- gui.text(50, 0, "Spd IV=" .. spdiv, "green")
    -- gui.text(0, 20, "SpAtk IV=" .. spatkiv, "red")
    -- gui.text(50, 20, "SpDef IV=" .. spdefiv, "orange")
    -- gui.text(0, 30, "Species " .. species)
    -- gui.text(0, 40, "Nature: " .. naturename[nature + 1])
    -- gui.text(0, 50, natureorder[natinc + 1] .. "+ " .. natureorder[natdec + 1] .. "-")
    -- gui.text(0, 70, "P1: " .. string.format("%04X", personality1), "yellow")
    -- gui.text(50, 70, "P2: " .. string.format("%04X", personality2), "yellow")
    -- gui.text(0, 80, "STID: " .. secretID, "yellow")
    -- gui.text(50, 80, "OTID: " .. originalID, "yellow")
    -- gui.text(0, 20, "PID: " .. string.format("%08X", personality), "yellow")
    gui.text(0, 0, "Shiny?: " .. tostring(isShiny), "yellow")
    -- gui.text(0, 10, "Battle?: " .. tostring(inBattle), "yellow")
end

local WAIT = {name = "WAIT", button = {}, delay = 100};
local RIGHT = {name = "RIGHT", button = {right = true}, delay = 50};
local RIGHT2 = {name = "RIGHT2", button = {right = true}, delay = 100};
local LEFT = {name = "LEFT", button = {left = true}, delay = 50};
local LEFT2 = {name = "LEFT2", button = {left = true}, delay = 100};
local APPEARED = {name = "APPEARED", button = {A = true}, delay = 500};
local FIGHT = {name = "FIGHT", button = {A = true}, delay = 100};
local FIGHT2 = {name = "FIGHT2", button = {A = true}, delay = 100};
local FIGHT3 = {name = "FIGHT3", button = {A = true}, delay = 100};
local FIGHT4 = {name = "FIGHT4", button = {A = true}, delay = 100};
local FIGHT5 = {name = "FIGHT5", button = {A = true}, delay = 100};

local currentState = WAIT;
local function setState()
    if currentState == WAIT then
        if inBattle then
            currentState = APPEARED
        else
            currentState = RIGHT
        end
    elseif currentState == RIGHT then
        if inBattle then
            currentState = APPEARED
        else
            currentState = RIGHT2
        end
    elseif currentState == RIGHT2 then
        if inBattle then
            currentState = APPEARED
        else
            currentState = LEFT
        end
    elseif currentState == LEFT then
        if inBattle then
            currentState = APPEARED
        else
            currentState = LEFT2
        end
    elseif currentState == LEFT2 then
        if inBattle then
            currentState = APPEARED
        else
            currentState = RIGHT
        end
    elseif currentState == APPEARED then
        currentState = FIGHT
    elseif currentState == FIGHT then
        currentState = FIGHT2
    elseif currentState == FIGHT2 then
        currentState = FIGHT3
    elseif currentState == FIGHT3 then
        currentState = FIGHT4
    elseif currentState == FIGHT4 then
        currentState = FIGHT5
    elseif currentState == FIGHT5 then
        currentState = WAIT
    end
end

local goalFrame = emu.framecount();

local function reachedGoalFrame() return emu.framecount() >= goalFrame end
local function updateGoalFrame() goalFrame = goalFrame + currentState.delay; end

local debounce;
while true do
    gui.text(0, 90, "State: " .. currentState.name)
    gatherOpponentData()
    processOpponentData()
    if inBattle then printOpponentData() end

    if reachedGoalFrame() then
        if not debounce then
            debounce = true
            setState()
            updateGoalFrame()
            emu.print(emu.framecount(), debounce, currentState)
            joypad.set(1, currentState.button)
        end
    else
        debounce = false
    end

    emu.frameadvance()

end
