
PowerManager = Manager:Inherit{
    classname = "PowerManager",
}

local this = PowerManager
local inherited = this.inherited

function PowerManager:New(obj)
    obj = inherited.New(self, obj)
    obj.powers = obj.elements
    return obj
end

--function PowerManager:AddElement(powerName)
    --inherited.AddElement(self, powerName)
    --self.elements[powerName] = PowerNames[powerName]:New({self.GetTeamID()})
--end

