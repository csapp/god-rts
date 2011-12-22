-- Based on a gadget created by Baczek at 
-- http://springrts.com/wiki/SetMoveTypeDataExample
-- and a gadget in zero-k
-- LuaRules/Gadgets/unit_transport_ai_buttons.lua

include("LuaRules/Configs/customcmds.h.lua")

function gadget:GetInfo()
    return {
        name = "Clergy units",
        desc = "Gadget to control Clergy units",
        author = "cam",
        date = "2011-12-21",
        license = "Public Domain",
        layer = -255,
        enabled = true
    }
end

if (not gadgetHandler:IsSyncedCode()) then
  return
end

local EditUnitCmdDesc = Spring.EditUnitCmdDesc
local FindUnitCmdDesc = Spring.FindUnitCmdDesc
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local GiveOrderToUnit = Spring.GiveOrderToUnit

local convertCmd = {
      id      = CMD_CONVERT,
      name    = "Convert",
      action  = "convert",
      type    = CMDTYPE.ICON,
      tooltip = "Convert a neutral village",
      params = {},
}

function gadget:Initialize()
    gadgetHandler:RegisterCMDID(CMD_CONVERT)
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if (unitDefID == UnitDefNames['priest'].id) then
        InsertUnitCmdDesc(unitID, CMD_CONVERT, convertCmd)
    end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
    if (cmdID == CMD_CONVERT) then
        Spring.Echo("Convert a village!")
        return false
    end
    return true
end

