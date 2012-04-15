function widget:GetInfo()
    return {
        name		= "GodSelectionWindow",
        desc		= "Used to select god powers before the god unit is spawned",
        author		= "matt",
        date		= "2012-02-10",
        license         = "GNU GPL v2",
        layer		= 1,
        enabled   	= true
    }
end
-- INCLUDES
VFS.Include("LuaUI/Headers/utilities.lua")
include("msgs.h.lua")
include("powers.h.lua")
-- CONSTANTS
-- SYNCED CONTROLS
-- CHILI CONTROLS
local Chili

-- MEMBERS
local listOfPowers = {"","",""}
local team_positions = {}
local ID = Spring.GetMyPlayerID()
local godselLabel
local godselWindow
local errorText = ""

local Powers
local PowerNames


-- SCRIPT FUNCTIONS
function selectPower(row, power, button)
    listOfPowers[row] = power
end

function done()
    if(listOfPowers[1] == "" or listOfPowers[2] == "" or listOfPowers[3] == "") then
        errorText = "You must select a power from each tier"
        loadPanel()
        return false
    end
    LuaMessages.SendLuaRulesMsg(MSG_TYPES.GOD_SELECTED, listOfPowers)
    widgetHandler:RemoveWidget()
end

function ClickFunc(button) 
    if(button.cmdid == 4) then
        done()
        Spring.PlaySoundFile("sounds/buttonconfirm.wav")
        return
    end
    Spring.PlaySoundFile("sounds/button.wav")
    selectPower(button.cmdid, button.caption, button)
    loadPanel()

end

local function DrawButtonTier(tierNum, y0)
    local x0 = 130
    local dx = 110
    local dy = 90
    local tierPowers = table.getvalues(utils.filter(
                           function(p) return p:GetType()==tierNum end, PowerNames))
    table.sort(tierPowers, function(t,u) return t:GetID() < u:GetID() end)
    local i = 0
    for _, power in pairs(tierPowers) do
        local name = power:GetName()
        local button = Chili.Button:New {
            parent = godselWindow,
            x = x0+i*dx,
            y = y0,
            padding = {5, 5, 5, 5},
            margin = {0, 0, 0, 0},
            minWidth = 90,
            minHeight = 90,
            caption = name,
            isDisabled = false,
            cmdid = tierNum,
            OnMouseDown = {ClickFunc},
            state = (listOfPowers[tierNum] == name) and "pressed" or "unpressed",
            tooltip = power:GetTooltip(),
            fontsize = 1,
        }

        local image = Chili.Image:New {
            width="100%";
            height="90%";
            y="6%";
            keepAspect = true,	--isState;
            file = power:GetLargeIcon(),
            parent = button,
        }

        local label = Chili.Label:New{
            x = x0+i*dx + 2,
            y = y0+dy,
            width = 12,
            parent = godselWindow,
            caption = name,
            fontsize = 10,
        }

        if power:GetType() ~= POWERS.TYPES.PASSIVE then
            -- Need to directly access this attribute because going through the
            -- getter accesses the multiplier too, which is synced info
            -- Also adding 0.5 so we round properly
            local cooldown = math.floor(1/power.rechargeRate+0.5)
            local cooldownLabel = Chili.Label:New{
                x = x0+i*dx + 2,
                y = y0+dy+10,
                width = 12,
                parent = godselWindow,
                caption = "Cooldown: "..cooldown.."s",
                fontsize = 10,
            }
        end

        i = i + 1
    end
end

-- WIDGET CODE

function DrawButtons()
    local selected = "unpressed"
    godselLabel = Chili.Label:New{
        x = 50,
        y = '10',
        width = 12,
        parent = godselWindow,
        caption = "Choose your god powers",
        fontsize = 30,
    }

    Power1Label = Chili.Label:New{
        x = '30',
        y = '150',
        width = 12,
        parent = godselWindow,
        caption = "Power 1:",
        fontsize = 24,
    }
    Power2Label = Chili.Label:New{
        x = '30',
        y = '420',
        width = 12,
        parent = godselWindow,
        caption = "Power 2:",
        fontsize = 24,
    }
    Power2Label = Chili.Label:New{
        x = '30',
        y = '720',
        width = 12,
        parent = godselWindow,
        caption = "Power 3:",
        fontsize = 24,
    }

    DrawButtonTier(1, 40)
    DrawButtonTier(2, 170)
    DrawButtonTier(3, 300)

    local button = Chili.Button:New {
        parent = godselWindow,
        x = 370,
        y = 415,
        padding = {5, 5, 5, 5},
        margin = {0, 0, 0, 0},
        minWidth = 40,
        minHeight = 40,
        caption = "Done",
        isDisabled = false,
        cmdid = 4,
        OnMouseDown = {ClickFunc},
    }

    local errorLabel = Chili.Label:New {
        parent = godselWindow,
        autosize=false;
        width="100%";
        height="100%";
        align="left";
        valign="bottom";
        caption = errorText;
        fontSize = 16;
        fontShadow = true;
    }
end

function resetWindow(container)
    container:ClearChildren()
    container.xstep = 1
    container.ystep = 1
end

function loadPanel()
    resetWindow(godselWindow)
    DrawButtons()
end

function widget:Initialize()	
    if (not WG.Chili) then
        widgetHandler:RemoveWidget()
        return
    end

    local godUnitDefID = UnitDefNames["god"].id
    if Spring.GetTeamUnitsSorted(Spring.GetMyTeamID())[godUnitDefID] then 
        widgetHandler:RemoveWidget()
        return
    end

    Powers = WG.Powers
    PowerNames = WG.PowerNames

    Chili      = WG.Chili
    local screen0 = Chili.Screen0

    godselWindow = Chili.Window:New{
        x = '25%',
        y = '25%',	
        dockable = true,
        parent = screen0,
        caption = "",
        clientWidth = 450,
        clientHeight = 465,
        skinName  = "Godly",
    }	

    loadPanel()

end
