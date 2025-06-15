local resource = GetCurrentResourceName()
local path = GetResourcePath(resource)
local databaseFile = path.."/shared/database.lua"

societies = {}
identities = {}
players = {}

for k,v in pairs(database.identities) do
  local identity = DuckIdentity()
  identity.loadFromDatabase(v)
  identities[identity.getId()] = identity
end
for k,v in pairs(database.players) do
  local player = DuckPlayer()
  player.loadFromDatabase(v)
  players[player.getId()] = player
end

for k,v in pairs(database.societies) do
  local society = DuckSociety()
  v.roles = {}
  v.members = {}
  if database.roles then
    for _, role in pairs(database.roles) do
      if role.societyId == v.id then
        table.insert(v.roles, role)
      end
    end
  end
  if database.members then
    for _, member in pairs(database.members) do
      if member.societyId == v.id then
        table.insert(v.members, member)
      end
    end
  end
  society.loadFromDatabase(v)
  societies[society.getId()] = society
  for _, member in pairs(society.getMembers()) do
    local player = players[member.getPlayerId()]
    if player then
      player.setSociety(society)
      player.setRole(member.getRole())
    else
      print("Error: Player with ID " .. member.getPlayerId() .. " not found for society " .. society.getName())
    end
  end
end

for k,v in pairs(societies) do
  v.generateEventHandler()
  Wait(1000)
end

for k,v in pairs(societies) do
	TriggerEvent('duck:society:' .. v.getName() .. ':test')
 	Wait(1000)
end

for k,v in pairs(players) do
  print(v.toString())
  Wait(1000)
end

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