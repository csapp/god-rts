Manager = Object:Inherit{
    classname = "Manager",
    teamID = -1,
    elements = {}
}

local this = Manager
local inherited = this.inherited

function Manager:New(teamID)
    obj = inherited.New(self, {teamID=teamID})
    return obj
end

function Manager:GetTeamID()
    return self.teamID
end

function Manager:GetElement(id)
    return self.elements[id]
end

function Manager:GetElements()
    return self.elements
end

function Manager:AddElement(id, element)
    self.elements[id] = element
end

function Manager:SetElement(id, value)
    self:AddElement(id, value)
end

function Manager:RemoveElement(id)
    self.elements[id] = nil
end

function Manager:CallOnAll(funcname, args)
    args = args or {}
    local results = {}
    for id, element in pairs(self:GetElements()) do
        results[id] = element[funcname](element, unpack(args))
    end
    return results
end
