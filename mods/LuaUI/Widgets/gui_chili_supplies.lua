
function widget:GetInfo()
    return {
        name = "Chili Supply count",
        desc = "Displays the supply count in the top right corner",
        author = "cam",
        tickets = "#151",
        date = "03-21-2012",
        license = "GNU GPL, v2 or later",
        layer = 0,
        experimental = false,
        enabled   = true
    }
end

include("managers.h.lua")

local supplyLabel
local currentSupplies = ""
local supplyCap = ""

local function UpdateLabel()
    supplyLabel:SetCaption(currentSupplies.."/"..supplyCap)
end

local function UpdateCurrentSupplies(cs)
    --if not cs then 
        --cs = ""
    --end
    currentSupplies = cs
    UpdateLabel()
end

local function UpdateSupplyCap(cap)
    --if not cap then
        --cap = ""
    --end
    supplyCap = cap
    UpdateLabel()
end

function widget:GameFrame(n)
    if n % 15 ~= 1 then return end

    WG.GadgetQuery.CallManagerFunction(
        UpdateCurrentSupplies, Managers.TYPES.SUPPLY, "GetUsedSupplies")

    WG.GadgetQuery.CallManagerFunction(
        UpdateSupplyCap, Managers.TYPES.SUPPLY, "GetSupplyCap")
end

function widget:Initialize()
    if (not WG.Chili) then
        widgetHandler:RemoveWidget()
        return
    end

    Chili = WG.Chili
    local screen0 = Chili.Screen0

    supplyLabel = Chili.Label:New{
        y = 10,
        --width = 100,
        right = 10,
        parent = screen0,
        caption = "",
        fontsize = 14,
        font = {
            size = 16,
            outline = true,
            outlineWidth = 4,
            outlineWeight = 3,
        },
    }

end

