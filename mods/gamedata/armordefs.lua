
local armorDefs = {
	infantry = {
			"soldier",
			"warrior",
			"general",
		},

	ranged = {
			"hunter",
			"marksman",
			"archer",
		},
	
	cavalry = {
			"scout",
			"horseman",
			"knight",
		},
		
	hero = {
			"heroinfantry",
			"heroranged",
			"herocavalry",
			"demigod",
		},
	
	clergy = {
			"priest",
			"prophet",
		},
		
	god = {
			"god",
		},
}

for categoryName, categoryTable in pairs(armorDefs) do
	local t = {}
	for _, unitName in pairs(categoryTable) do
		t[unitName] = 1
	end
	armorDefs[categoryName] = t
end

return armorDefs