-- Dynamic Progressbars change colours to reflect their value
-- written by cam

include("godlycolors.h.lua")

local function color(r,g,b)
    return {r/255, g/255, b/255, 1}
end

DynamicProgressbar = Progressbar:Inherit{
    classname = "dynamicprogressbar",
    dynvalues = {
        -- min percentage, max percentage, associated colour
        {0, 0.1, GodlyColors.RED},
        {0.10, 0.25, GodlyColors.ORANGE},
        {0.25, 0.50, GodlyColors.LIGHT_YELLOW},
        {0.50, 0.99, GodlyColors.LIGHT_GREEN},
        {1, 1, GodlyColors.GREEN},
    },
}

function DynamicProgressbar:SetValue(v, setcaption)
    DynamicProgressbar.inherited.SetValue(self, v, setcaption)
    local min, max, colour
    local p = (self.value-self.min) / (self.max-self.min)
    for i, dyninfo in ipairs(self.dynvalues) do
        minp, maxp, colour = unpack(dyninfo)
        if p >= minp and p <= maxp then
            self:SetColor(colour)
            break
        end
    end
end
