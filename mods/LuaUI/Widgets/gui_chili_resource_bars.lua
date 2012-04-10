-- This code is based off of Zero-K's resource bar code.
-- http://code.google.com/p/zero-k/source/browse/trunk/mods/zk/LuaUI/Widgets/gui_chili_resource_bars.lua
function widget:GetInfo()
    return {
        name      = "Chili Resource Bars",
        desc      = "",
        author    = "Kaitlin",
        date      = "2012",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        experimental = false,
        enabled   = true
    }
end

include("colors.h.lua")
include("managers.h.lua")

local abs = math.abs
local echo = Spring.Echo
local GetMyTeamID = Spring.GetMyTeamID
local GetTeamResources = Spring.GetTeamResources
local GetTimer = Spring.GetTimer
local DiffTimers = Spring.DiffTimers
local Chili

local col_metal = {136/255,214/255,251/255,1}
local col_energy = {1,1,0,1}
local col_buildpower = {0.8, 0.8, 0.2, 1}

local window
local bar_energy
local bar_energy_overlay
local lbl_energy
local lbl_e_expense
local lbl_e_income
local blink = 0
local blink_periode = 2
local blink_alpha = 1
local blinkE_status = false
local time_old = 0
local excessE = false
local supplyLabel
local villagerLabel
local currentSupplies = 0 
local supplyCap = 0 

local builderDefs = {}
for id,ud in pairs(UnitDefs) do
    if (ud.builder) then
        builderDefs[#builderDefs+1] = id
    elseif (ud.buildSpeed > 0) then
        builderDefs[#builderDefs+1] = id
    end
end

options = { 
    eexcessflashalways = {name='Always Flash On Energy Excess', type='bool', value=false},
    onlyShowExpense = {name='Only Show Expense', type='bool', value=false},
    workerUsage = {name = "Show Worker Usage", type = "bool", value=false, OnChange = option_workerUsageUpdate},
    energyFlash = {name = "Energy Stall Flash", type = "number", value=0.1, min=0,max=1,step=0.02},
    opacity = {
        name = "Opacity",
        type = "number",
        value = 0, min = 0, max = 1, step = 0.01,
        OnChange = function(self) window.color = {1,1,1,self.value}; window:Invalidate() end,
    }
}

function widget:Update(s)
    blink = (blink+s)%blink_periode
    blink_alpha = math.abs(blink_periode/2 - blink)
    if blinkE_status then
        if excessE then
            bar_energy_overlay:SetColor({0,0,0,0})
            bar_energy:SetColor(1-0.5*blink_alpha,1,0,0.65 + 0.35 *blink_alpha)
        else
            bar_energy_overlay:SetColor(1,0,0,blink_alpha)
        end
    end
end

local function Format(input)
    local leadingString = GreenStr .. "+"
    if input < 0 then
        leadingString = RedStr .. "-"
    end
    input = math.abs(input)
    if input < 0.01 then
        return WhiteStr .. "0"
    elseif input < 5 then
        return leadingString .. ("%.2f"):format(input) .. WhiteStr
    elseif input < 50 then
        return leadingString .. ("%.1f"):format(input) .. WhiteStr
    elseif input < 10^3 then
        return leadingString .. ("%.0f"):format(input) .. WhiteStr
    elseif input < 10^4 then
        return leadingString .. ("%.2f"):format(input/1000) .. "k" .. WhiteStr
    elseif input < 10^5 then
        return leadingString .. ("%.1f"):format(input/1000) .. "k" .. WhiteStr
    else
        return leadingString .. ("%.0f"):format(input/1000) .. "k" .. WhiteStr
    end
end


local function UpdateSupplyLabel()
    supplyLabel:SetCaption(currentSupplies.."/"..math.floor(supplyCap))
end

local function UpdateCurrentSupplies(cs)
    currentSupplies = tonumber(cs)
    UpdateSupplyLabel()
end

local function UpdateSupplyCap(cap)
    supplyCap = tonumber(cap)
    UpdateSupplyLabel()
end

function widget:GameFrame(n)
    if (n%32 ~= 2) or not window then 
        return 
    end

    WG.GadgetQuery.CallManagerFunction(
        UpdateCurrentSupplies, Managers.TYPES.SUPPLY, "GetUsedSupplies")

    WG.GadgetQuery.CallManagerFunction(
        UpdateSupplyCap, Managers.TYPES.SUPPLY, "GetSupplyCap")

    local myTeamID = GetMyTeamID()
    local myAllyTeamID = Spring.GetMyAllyTeamID()
    local teams = Spring.GetTeamList(myAllyTeamID)
    local totalConstruction = 0
    local totalExpense = 0
    local teamMInco = 0
    local teamMSpent = 0
    local teamFreeStorage = 0
    for i = 1, #teams do
        local eCurr, eStor, ePull, eInco, eExpe, eShar, eSent, eReci = GetTeamResources(teams[i], "energy")
        totalExpense = totalExpense + eExpe
    end
    local eCurr, eStor, ePull, eInco, eExpe, eShar, eSent, eReci = GetTeamResources(myTeamID, "energy")

    local wastingE = false

    local stallingE = (eCurr <= eStor * options.energyFlash.value) and (eCurr < 1000) and (eCurr >= 0)
    if stallingE or wastingE then
        blinkE_status = true
        bar_energy:SetValue( 100 )
        excessE = wastingE
    elseif (blinkE_status) then
        blinkE_status = false
        bar_energy:SetColor( col_energy )
    end

    local ePercent = 100 * eCurr / eStor

    bar_energy:SetValue( ePercent )
    if stallingE then
        bar_energy_overlay:SetCaption( (RedStr.."%i/%i"):format(eCurr, eStor) )
    elseif wastingE then
        bar_energy_overlay:SetCaption( (GreenStr.."%i/%i"):format(eCurr, eStor) )
    else
        bar_energy_overlay:SetCaption( ("%i/%i"):format(eCurr, eStor) )
    end

    local eTotal
    if options.onlyShowExpense.value then
        eTotal = eInco - eExpe
    else
        eTotal = eInco - ePull
    end
    if (eTotal >= 2) then
        lbl_energy.font:SetColor(0,1,0,1)
    elseif (eTotal > 0.1) then
        lbl_energy.font:SetColor(1,0.7,0,1)
    else            
        lbl_energy.font:SetColor(1,0,0,1)
    end
    local abs_eTotal = abs(eTotal)
    if (abs_eTotal<0.1) then
        lbl_energy:SetCaption( "\1770" )
    elseif (abs_eTotal>=10)and((abs(eTotal%1)<0.1)or(abs_eTotal>99)) then
        lbl_energy:SetCaption( ("%+.0f"):format(eTotal) )
    else
        lbl_energy:SetCaption( ("%+.1f"):format(eTotal) )
    end
    if options.onlyShowExpense.value then
        lbl_e_expense:SetCaption( ("%.1f"):format(eExpe) )
    else
        lbl_e_expense:SetCaption( ("%.1f"):format(ePull) )
    end
    lbl_e_income:SetCaption( ("%.1f"):format(eInco) )

    local villagers = GetTeamResources(myTeamID, "metal")
    villagerLabel:SetCaption(math.floor(villagers+0.5))
end


function widget:Initialize()
    Chili = WG.Chili
    if (not Chili) then
        widgetHandler:RemoveWidget()
        return
    end

    time_old = GetTimer()
    Spring.SendCommands("resbar 0")
    CreateWindow()
end


function widget:Shutdown()
    window:Dispose()
    Spring.SendCommands("resbar 1")
end


function CreateWindow()
    local bars = 2
    local function p(a)
        return tostring(a).."%"
    end
    local screenWidth,screenHeight = Spring.GetWindowGeometry()
    window = Chili.Window:New{
        color = {1,1,1,options.opacity.value},
        parent = Chili.Screen0,
        dockable = true,
        name="ResourceBars",
        padding = {0,0,0,0},
        right = 10,
        y = 0,
        clientWidth  = 430,
        clientHeight = 50,
        draggable = false,
        resizable = false,
        tweakDraggable = true,
        tweakResizable = true,
        minimizable = false,
    }
    Chili.Image:New{
        parent = window,
        height = p(100/bars),
        width  = 25,
        --right  = 10,
        x = 70,
        y      = p(100/bars),
        file   = 'anims/cursorConvert_0.png',
    }
    bar_energy_overlay = Chili.Progressbar:New{
        parent = window,
        color  = col_energy,
        height = p(100/bars),
        value  = 100,
        right  = 36,
        x      = 100,
        y      = p(100/bars),
        noSkin = true,
        font   = {color = {1,1,1,1}, outlineColor = {0,0,0,0.7}, },
    }
    bar_energy = Chili.Progressbar:New{
        parent = window,
        color  = col_energy,
        height = p(100/bars),
        right  = 36,
        x      = 100,
        y      = p(100/bars),
        tooltip = "Local Faith Economy",
        font   = {color = {1,1,1,1}, outlineColor = {0,0,0,0.7}, },
    }
    lbl_energy = Chili.Label:New{
        parent = window,
        height = p(100/bars),
        width  = 60,
        --x      = 0,
        right = 1,
        y      = p(100/bars),
        valign = "center",
        align  = "right",
        caption = "0",
        autosize = false,
        font   = {size = 19, outline = true, outlineWidth = 4, outlineWeight = 3,},
        tooltip = "Your net faith generation.",
    }
    lbl_e_income = Chili.Label:New{
        parent = nil,
        height = p(50/bars),
        width  = 40,
        x      = 60,
        y      = p(100/bars),
        caption = "10.0",
        valign  = "center",
        align   = "center",
        autosize = false,
        font   = {size = 12, outline = true, color = {0,1,0,1}},
        tooltip = "Your faith generation.",
    }
    lbl_e_expense = Chili.Label:New{
        parent = nil,
        height = p(50/bars),
        width  = 40,
        x      = 60,
        y      = p(150/bars),
        caption = "10.0",
        valign = "center",
        align  = "center",
        autosize = false,
        font   = {size = 12, outline = true, color = {1,0,0,1}},
        tooltip = "This is the faith demand of your units.",
    }

    Chili.Image:New{
        parent = window,
        width  = 25,
        height = 25,
        right  = 100,
        y      = 1,
        file   = "bitmaps/icons/supplies.png",
    }

    supplyLabel = Chili.Label:New{
        y = 1,
        --width = 100,
        right = 50,
        parent = window,
        caption = "",
        --fontsize = 14,
		tooltip = "Your current population, out of the max possible population.",
        font = {
            size = 14,
            outline = true,
            outlineWidth = 4,
            outlineWeight = 3,
        },
    }
	
    Chili.Image:New{
        parent = window,
        width  = 25,
        height = 25,
        right  = 180,
        y      = 1,
        file   = "bitmaps/icons/villagers.png",
    }

    villagerLabel = Chili.Label:New{
        y = 1,
        --width = 100,
        right = 160,
        parent = window,
        caption = "",
        --fontsize = 14,
		tooltip = "Your current villager count",
        font = {
            size = 14,
            outline = true,
            outlineWidth = 4,
            outlineWeight = 3,
        },
    }
	-- Activate the tooltip for a label, because Spring doesn't do this by default.
	function supplyLabel:HitTest(x,y) return self end
    function bar_energy:HitTest(x,y) return self end
    function lbl_energy:HitTest(x,y) return self end
end


function DestroyWindow()
    window:Dispose()
    window = nil
end


