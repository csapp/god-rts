-- Dynamic Progressbars change colours to reflect their value
-- written by cam

DynamicProgressbar = Progressbar:Inherit{
    classname = "dynamicprogressbar",
    dynvalues = {
        -- min percentage, max percentage, associated colour
        {0, 0.1, {1,0,0,1}},
        {0.10, 0.25, {250/255,167/255,58/255,1}},
        {0.25, 0.50, {1,1,0,1}},
        {0.50, 1, {0,1,0,1}},
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
