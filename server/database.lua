local resource = GetCurrentResourceName()
local path = GetResourcePath(resource)
local databaseFile = path.."/shared/database.lua"

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
            f:write("        {\n")
            f:write("            id = " .. role.getId() .. ",\n")
            f:write("            societyId = " .. role.getSocietyId() .. ",\n")
            f:write("            name = \"" .. role.getName() .. "\",\n")
            f:write("            label = \"" .. role.getLabel() .. "\",\n")
            f:write("            salary = " .. role.getSalary() .. ",\n")
            f:write("            isDefault = " .. tostring(role.getIsDefault()) .. ",\n")
            f:write("            canPromote = {\n")
            for _,promotableRole in pairs(role.getPromotableRoles()) do
                f:write("                " .. promotableRole.getId() .. ",\n")
            end
            f:write("            },\n")
            f:write("            canDemote = {\n")
            for _,demotableRole in pairs(role.getDemotableRoles()) do
                f:write("                " .. demotableRole.getId() .. ",\n")
            end
            f:write("            }\n")
            f:write("        },\n")
        end
    end
    f:write("    },\n")
    f:write("    members = {\n")
    for _,society in pairs(Societies) do
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
    for _,identity in pairs(Identities) do
      f:write("        {\n")
      f:write("            id = " .. identity.getId() .. ",\n")
      f:write("            firstname = \"" .. identity.getFirstname() .. "\",\n")
      f:write("            lastname = \"" .. identity.getLastname() .. "\",\n")
      f:write("            dateofbirth = \"" .. identity.getDateOfBirth() .. "\"\n")
      f:write("        },\n")
    end
    f:write("    },\n")
    f:write("    players = {\n")
    for _,player in pairs(Players) do
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


RegisterCommand("savedatabase", function(source, args, rawCommand)
  if source == 0 then
    StoreDatabase()
  else
    print("This command can only be used from the server console.")
  end
end, false)

MySQL = {
    
}