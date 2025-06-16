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
    for _,society in ipairs(societies) do
      for _,role in ipairs(society.roles) do
        roles[role.id] = role
      end
      for _,member in ipairs(society.members) do
        members[member.id] = member
      end
      f:write("        {\n")
      f:write("            id = " .. society.id .. ",\n")
      f:write("            name = \"" .. society.name .. "\",\n")
      f:write("            label = \"" .. society.label .. "\",\n")
      f:write("        },\n")
    end
    f:write("    },\n")
    f:write("    roles = {\n")
    for _,role in roles do
      f:write("        {\n")
      f:write("            id = " .. role.id .. ",\n")
      f:write("            societyId = " .. role.societyId .. ",\n")
      f:write("            name = \"" .. role.name .. "\",\n")
      f:write("            label = \"" .. role.label .. "\",\n")
      f:write("            salary = " .. role.salary .. ",\n")
      f:write("            isDefault = " .. tostring(role.isDefault) .. "\n")
      f:write("        },\n")
    end
    f:write("    },\n")
    f:write("    members = {\n")
    for _,member in ipairs(members) do
      f:write("        {\n")
      f:write("            id = " .. member.id .. ",\n")
      f:write("            societyId = " .. member.societyId .. ",\n")
      f:write("            roleId = " .. member.roleId .. ",\n")
      f:write("            playerId = " .. member.playerId .. "\n")
      f:write("        },\n")
    end
    f:write("    },\n")
    f:write("    identities = {\n")
    for _,identity in ipairs(identities) do
      f:write("        {\n")
      f:write("            id = " .. identity.id .. ",\n")
      f:write("            firstname = \"" .. identity.firstname .. "\",\n")
      f:write("            lastname = \"" .. identity.lastname .. "\",\n")
      f:write("            dateofbirth = \"" .. identity.dateofbirth .. "\"\n")
      f:write("        },\n")
    end
    f:write("    },\n")
    f:write("    players = {\n")
    for _,player in ipairs(players) do
      f:write("        {\n")
      f:write("            id = " .. player.id .. ",\n")
      f:write("            identityId = " .. player.identityId .. ",\n")
      f:write("            identifier = " .. player.identifier .. ",\n")
      f:write("            money = " .. player.money .. "\n")
      f:write("        },\n")
    end
    f:write("}\n")
    f:close()
    print("Database saved successfully.")
  end
end