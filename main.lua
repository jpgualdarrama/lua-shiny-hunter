-- http://tasvideos.org/forum/viewtopic.php?t=4101
-- http://tasvideos.org/forum/viewtopic.php?t=4101&postdays=0&postorder=asc&start=100 my post
-- http://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9mon_data_structure_in_Generation_III
-- ruby/sapphire 0x03004360
-- emerald 0x02024190 J 0x020244EC U
-- firered 0x02024284
-- leafgreen 0x020241e4

-- 64
-- 4360 43C4 4428 448C 44F0 4554
-- 45C0 4624

local natureorder={"Atk","Def","Spd","SpAtk","SpDef"}
local naturename={
"Hardy","Lonely","Brave","Adamant","Naughty",
"Bold","Docile","Relaxed","Impish","Lax",
"Timid","Hasty","Serious","Jolly","Naive",
"Modest","Mild","Quiet","Bashful","Rash",
"Calm","Gentle","Sassy","Careful","Quirky"}

local start=0x03004360
local personality
local trainerid
local magicword
local growthoffset
local miscoffset
local i

local species
local ivs
local hpiv
local atkiv
local defiv
local spdiv
local spatkiv
local spdefiv
local nature
local natinc
local natdec

while true do

personality=memory.readdwordunsigned(start)
trainerid=memory.readdwordunsigned(start+4)
magicword=bit.bxor(personality, trainerid)

i=personality%24

if i<=5 then
 growthoffset=0
elseif i%6<=1 then
 growthoffset=12
elseif i%2==0 then
 growthoffset=24
else
 growthoffset=36
end

if i>=18 then
 miscoffset=0
elseif i%6>=4 then
 miscoffset=12
elseif i%2==1 then
 miscoffset=24
else
 miscoffset=36
end

species=bit.band(bit.bxor(memory.readdwordunsigned(start+32+growthoffset),magicword),0xFFF)

ivs=bit.bxor(memory.readdwordunsigned(start+32+miscoffset+4),magicword)

hpiv=bit.band(ivs,0x1F)
atkiv=bit.band(ivs,0x1F*0x20)/0x20
defiv=bit.band(ivs,0x1F*0x400)/0x400
spdiv=bit.band(ivs,0x1F*0x8000)/0x8000
spatkiv=bit.band(ivs,0x1F*0x100000)/0x100000
spdefiv=bit.band(ivs,0x1F*0x2000000)/0x2000000

nature=personality%25
natinc=math.floor(nature/5)
natdec=nature%5


gui.text(0,0,"HP IV="..hpiv, "yellow")
gui.text(0,10,"Atk IV="..atkiv, "red")
gui.text(50,10,"Def IV="..defiv, "orange")
gui.text(50,0,"Spd IV="..spdiv, "green")
gui.text(0,20,"SpAtk IV="..spatkiv, "red")
gui.text(50,20,"SpDef IV="..spdefiv, "orange")

gui.text(0,30,"Species "..species)
gui.text(0,40,"Nature: "..naturename[nature+1])
gui.text(0,50,natureorder[natinc+1].."+ "..natureorder[natdec+1].."-")
gui.text(0,60,"PID: "..string.format("%08X", personality))


emu.frameadvance()

end
