local resource = GetCurrentResourceName()
local path = GetResourcePath(resource)
local databaseFile = path.."/shared/database.lua"

function storeDatabase()
  if not Config.useDb then
    local f,m = io.open(databaseFile,"w")
    local roles = {}
    local members = {}
    if not f then
      print("FAILED TO SAVE DATABASE: "..tostring(m).."!")
      return
    end
    f:write("database = {\n")
    f:write("    maxSocityId = " .. database.maxSocityId .. ",\n")
    f:write("    maxMemberId = " .. database.maxMemberId .. ",\n")
    f:write("    maxRoleId = " .. database.maxRoleId .. ",\n")
    f:write("    maxIdentityId = " .. database.maxIdentityId .. ",\n")
    f:write("    maxPlayerId = " .. database.maxPlayerId .. ",\n")
    f:write("    societies = {\n")
    for _,society in pairs(societies) do
      f:write("        {\n")
      f:write("            id = " .. society.getId() .. ",\n")
      f:write("            name = \"" .. society.getName() .. "\",\n")
      f:write("            label = \"" .. society.getLabel() .. "\",\n")
      f:write("        },\n")
    end
    f:write("    },\n")
    f:write("    roles = {\n")
    for _,society in pairs(societies) do
        for _,role in pairs(society.getRoles()) do
            f:write("        {\n")
            f:write("            id = " .. role.getId() .. ",\n")
            f:write("            societyId = " .. role.getSocietyId() .. ",\n")
            f:write("            name = \"" .. role.getName() .. "\",\n")
            f:write("            label = \"" .. role.getLabel() .. "\",\n")
            f:write("            salary = " .. role.getSalary() .. ",\n")
            f:write("            isDefault = " .. tostring(role.getIsDefault()) .. "\n")
            f:write("        },\n")
        end
    end
    f:write("    },\n")
    f:write("    members = {\n")
    for _,society in pairs(societies) do
        for _,member in pairs(society.getMembers()) do
            f:write("        {\n")
            f:write("            id = " .. member.getId() .. ",\n")
            f:write("            societyId = " .. member.getSocietyId() .. ",\n")
            f:write("            roleId = " .. member.getRoleId() .. ",\n")
            f:write("            playerId = " .. member.getPlayerId() .. "\n")
            f:write("        },\n")
        end
    end
    f:write("    },\n")
    f:write("    identities = {\n")
    for _,identity in pairs(identities) do
      f:write("        {\n")
      f:write("            id = " .. identity.getId() .. ",\n")
      f:write("            firstname = \"" .. identity.getFirstname() .. "\",\n")
      f:write("            lastname = \"" .. identity.getLastname() .. "\",\n")
      f:write("            dateofbirth = \"" .. identity.getDateOfBirth() .. "\"\n")
      f:write("        },\n")
    end
    f:write("    },\n")
    f:write("    players = {\n")
    for _,player in pairs(players) do
      f:write("        {\n")
      f:write("            id = " .. player.getId() .. ",\n")
      f:write("            identityId = " .. player.getIdentityId() .. ",\n")
      f:write("            identifier = \"" .. player.getIdentifier() .. "\",\n")
      f:write("            money = " .. player.getMoney() .. "\n")
      f:write("        },\n")
    end
    f:write("   }\n")
    f:write("}\n")
    f:close()
    print("Database saved successfully.")
  end
end