function gadget:GetInfo()
    return {
        name = "Hero Unit gadget",
        desc = "Gadget to control Hero unit stuff",
        author = "Mani",
        date = "2012-03-17",
        license = "Public Domain",
        layer = 0,
        enabled = true
    }
end

local hero_infantry_id = UnitDefNames["heroinfantry"].id
local hero_ranged_id = UnitDefNames["heroranged"].id
local hero_cavalry_id = UnitDefNames["herocavalry"].id

local GetUnitDefID = Spring.GetUnitDefID


function getHeroInfo()
	local heroes = {}
	
	for _, unitID in pairs(Spring.GetAllUnits()) do
		if GetUnitDefID(unitID) == hero_infantry_id or GetUnitDefID(unitID) == hero_ranged_id or GetUnitDefID(unitID) == hero_cavalry_id then
			local x,y,z = Spring.GetUnitBasePosition(unitID)
			local teamID = Spring.GetUnitTeam(unitID)
			local heroInfo = {x,y,z, unitID, teamID}
			table.insert(heroes, heroInfo) --the list 'heroes' contains the locations of all heroes
		end
	end
	return heroes
end


function applyHeroBonus(listOfHeroInfo)
	local affectedUnits = {}
	
	for i, heroInfo in pairs(listOfHeroInfo) do
		local unitList = Spring.GetUnitsInSphere(heroInfo[1], heroInfo[2], heroInfo[3], 100, heroInfo[5]) --Get units on same team around Hero
		for j,w in pairs(unitList) do
			if w == heroInfo[4] then
				table.remove(unitList, j)
			end
		end
		table.insert(affectedUnits, unitList)
	end
	GG.InfluencedUnits = affectedUnits
--[[	for i,v in pairs(affectedUnits) do
		for j, w in pairs(v) do
			if GetUnitDefID(w) ~= hero_infantry_id and GetUnitDefID(w) ~= hero_ranged_id and GetUnitDefID(w) ~= hero_cavalry_id then
				Spring.AddUnitDamage(w, 0.5)
			end
		end
	end]]--
end

function gadget:GameFrame(n)
	local heroInfo = getHeroInfo()
	if heroInfo ~= nil then
		applyHeroBonus(heroInfo)
	end

end