local resource = GetCurrentResourceName()
local path = GetResourcePath(resource)
local databaseFile = path.."/shared/database.lua"

societies = {}

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
end

for k,v in pairs(societies) do
  v.generateEventHandler()
  Wait(1000)

end

for k,v in pairs(societies) do
	TriggerEvent('duck:society:' .. v.getName() .. ':test')
 	Wait(1000)
end


function storeDatabase()
  if not Config.useDb then
    local f,m = io.open(databaseFile,"w")
    if not f then
      print("FAILED TO SAVE DATABASE: "..tostring(m).."!")
      return
    end
    f:write("database = {\n")
    f:write("    maxSocityId = " .. database.maxSocityId .. ",\n")
    f:write("    maxMemberId = " .. database.maxMemberId .. ",\n")
    f:write("    maxRoleId = " .. database.maxRoleId .. ",\n")
    f:write("    societies = {\n")
    for _,society in ipairs(database.societies) do
      f:write("        {\n")
      f:write("            id = " .. society.id .. ",\n")
      f:write("            name = \"" .. society.name .. "\",\n")
      f:write("            label = \"" .. society.label .. "\",\n")
      f:write("        },\n")
    end
    f:write("    },\n")
    f:write("    roles = {\n")
    for _,role in ipairs(database.roles) do
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
    for _,member in ipairs(database.members) do
      f:write("        {\n")
      f:write("            id = " .. member.id .. ",\n")
      f:write("            societyId = " .. member.societyId .. ",\n")
      f:write("            roleId = " .. member.roleId .. ",\n")
      f:write("            playerId = " .. member.playerId .. "\n")
      f:write("        },\n")
    end
    f:write("    },\n")
    f:write("}\n")
    f:close()
    print("Database saved successfully.")
  end
end