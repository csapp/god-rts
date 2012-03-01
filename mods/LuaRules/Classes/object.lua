-- This is adapted from Chili
--//=============================================================================

VFS.Include("LuaUI/Headers/utilities.lua")

Object = {
    classname = 'object',
    OnDispose = {},
}

do
    local __lowerkeys = {}
    Object.__lowerkeys = __lowerkeys
    for i,v in pairs(Object) do
        if (type(i)=="string") then
            __lowerkeys[i:lower()] = i
        end
    end
end

local this = Object
local inherited = this.inherited

--//=============================================================================
--// used to generate unique objects names

local cic = {} 
local function GetUniqueId(classname)
    local ci = cic[classname] or 0
    cic[classname] = ci + 1
    return ci
end

--//=============================================================================

function Object:New(obj)
    obj = obj or {}

    --// check if the user made some lower-/uppercase failures
    for i,v in pairs(obj) do
        if (not self[i])and(isstring(i)) then
            local correctName = self.__lowerkeys[i:lower()]
            if (correctName)and(obj[correctName] == nil) then
                obj[correctName] = v
            end
        end
    end

    --// give name
    if (not obj.name) then
        obj.name = self.classname .. GetUniqueId(self.classname)
    end

    --// make an instance
    for i,v in pairs(self) do --// `self` means the class here and not the instance!
        if (i ~= "inherited") then
            local t = type(v)
            local ot = type(obj[i])
            if (t=="table")or(t=="metatable") then
                if (ot == "nil") then
                    obj[i] = {};
                    ot = "table";
                end
                if (ot ~= "table")and(ot ~= "metatable") then
                    Spring.Echo("LuaRules Object: " .. obj.name .. ": Wrong param type given to " .. i .. ": got " .. ot .. " expected table.")
                    obj[i] = {}
                end

                table.merge(obj[i],v)
                if (t=="metatable") then
                    setmetatable(obj[i], getmetatable(v))
                end
            elseif (ot == "nil") then
                obj[i] = v
            end
        end
    end
    setmetatable(obj,{__index = self})

    --// auto dispose remaining Dlists etc. when garbage collector frees this object
    --local hobj = MakeHardLink(obj,function() obj:Dispose(); obj=nil; end)

    --return hobj
    return obj
end


function Object:Dispose()
    if (not self.disposed) then
        self:CallListeners(self.OnDispose)
        self.disposed = true

        --TaskHandler.RemoveObject(self)
        ----DebugHandler:UnregisterObject(self) --// not needed

        --if (UnlinkSafe(self.parent)) then
            --self.parent:RemoveChild(self)
        --end
        --self.parent = nil

        --local children = self.children
        --local cn = #children
        --for i=cn,1,-1 do
            --local child = children[i]
            ----if (child.parent == self) then
            --child:SetParent(nil)
            ----end
        --end
        --self.children = {}
    end
end


function Object:Clone()
    local newinst = {}
    -- FIXME
    return newinst
end


function Object:Inherit(class)
    class.inherited = self

    for i,v in pairs(self) do
        if (class[i] == nil)and(i ~= "inherited")and(i ~= "__lowerkeys") then
            t = type(v)
            if (t == "table") --[[or(t=="metatable")--]] then
                class[i] = table.shallowcopy(v)
            else
                class[i] = v
            end
        end
    end

    local __lowerkeys = {}
    class.__lowerkeys = __lowerkeys
    for i,v in pairs(class) do
        if (type(i)=="string") then
            __lowerkeys[i:lower()] = i
        end
    end

    return class
end

function Object:InheritsFrom(classname)
    if (self.classname == classname) then
        return true
    elseif not self.inherited then
        return false
    else
        return self.inherited.InheritsFrom(self.inherited,classname)
    end
end

function Object:CallListeners(listeners, ...)
    for i=1,#listeners do
        local eventListener = listeners[i]
        if eventListener(self, ...) then
            return true
        end
    end
end


function Object:CallListenersInverse(listeners, ...)
    for i=#listeners,1,-1 do
        local eventListener = listeners[i]
        if eventListener(self, ...) then
            return true
        end
    end
end

