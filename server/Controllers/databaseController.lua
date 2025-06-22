local resource = GetCurrentResourceName()
local path = GetResourcePath(resource)
local databaseFile = path.."/shared/database.lua"

local function onRessourceStop(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  StoreDatabase()
end

AddEventHandler('onResourceStop', onRessourceStop)

function StoreDatabase()
  if not Config.useDb then
    local f,m = io.open(databaseFile,"w")
    if not f then
      print("FAILED TO SAVE DATABASE: "..tostring(m).."!")
      return
    end
    f:write("Database = {\n")
    f:write("    maxSocityId = " .. Database.maxSocityId .. ",\n")
    f:write("    maxMemberId = " .. Database.maxMemberId .. ",\n")
    f:write("    maxRoleId = " .. Database.maxRoleId .. ",\n")
    f:write("    maxIdentityId = " .. Database.maxIdentityId .. ",\n")
    f:write("    maxPlayerId = " .. Database.maxPlayerId .. ",\n")
    f:write("    maxAccountId = " .. Database.maxAccountId .. ",\n")
    f:write("    societies = {\n")
    for _,society in pairs(Societies) do
      society.storeInFile(f)
    end
    f:write("    },\n")
    f:write("    roles = {\n")
    for _,society in pairs(Societies) do
        for _,role in pairs(society.getRoles()) do
          role.storeInFile(f)
        end
    end
    f:write("    },\n")
    f:write("    members = {\n")
    for _,society in pairs(Societies) do
        for _,member in pairs(society.getMembers()) do
            member.storeInFile(f)
        end
    end
    f:write("    },\n")
    f:write("    identities = {\n")
    for _,identity in pairs(Identities) do
      identity.storeInFile(f)
    end
    f:write("    },\n")
    f:write("    players = {\n")
    for _,player in pairs(Players) do
      player.storeInFile(f)
    end
    f:write("   }\n")
    f:write("}\n")
    f:close()
    print("Database saved successfully.")
  end
end


RegisterCommand("savedatabase", function(source, args, rawCommand)
  if source == 0 then
    StoreDatabase()
  else
    print("This command can only be used from the server console.")
  end
end, false)

MySQL = {
    
}