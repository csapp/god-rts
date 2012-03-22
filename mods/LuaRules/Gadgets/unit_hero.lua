function gadget:GetInfo()
    return {
        name = "Hero Unit gadget",
        desc = "Gadget to control Hero unit stuff",
        author = "Mani",
        tickets = "#131",
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
			table.insert(heroes, heroInfo) --the list 'heroes' contains the locations, unitIDs and teamIDs of all heroes
		end
	end
	return heroes
end


function applyHeroBonus(listOfHeroInfo)
	local affectedUnits = {}
	
	for i, heroInfo in pairs(listOfHeroInfo) do
		local unitList = Spring.GetUnitsInSphere(heroInfo[1], heroInfo[2], heroInfo[3], 100, heroInfo[5]) --Get units on same team around Hero within radius
		for j,w in pairs(unitList) do
			if w == heroInfo[4] then
				table.remove(unitList, j) -- remove the Hero from this list since he doesn't get affected by the bonus
			end
		end
		table.insert(affectedUnits, unitList) -- gather a list of lists containing all units near heroes
	end
	GG.InfluencedUnits = affectedUnits	--post this to the global list 'GG', so that the attribute system can handle applying bonuses
end

function gadget:GameFrame(n)
	local heroInfo = getHeroInfo()
	if heroInfo ~= nil then
		applyHeroBonus(heroInfo)
	end

end
