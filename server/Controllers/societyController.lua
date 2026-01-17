Societies = {}

function LoadSocieties()
  for k,v in pairs(Database.societies) do
    local society = DuckSociety()
    society.loadFromDatabase(v)
    Societies[society.getId()] = society
  end
end

RegisterCommand("getSocietyStatus", function(source, args, rawCommand)
    local societyId = tonumber(args[1])
    if not societyId then
        print("Usage: /getSocietyStatus <societyId>")
        return
    end

    local society = Societies[societyId]
    if not society then
        print("Society with ID " .. societyId .. " not found.")
        return
    end

    print(society.toString())
    print('----- Roles -----')
    for _, role in pairs(society.getRoles()) do
        print(role.toString())
    end
    print('----- Members -----')
    for _, member in pairs(society.getMembers()) do
        print(member.toString())
    end
end, false)

RegisterCommand("editSocietyLabel", function(source, args, rawCommand)
    if source == 0 then
        if #args < 2 then
            print("Usage: editSocietyLabel <societyId> <newLabel>")
            return
        end

        local societyId = tonumber(args[1])
        local newLabel = args[2]
        if not societyId or not newLabel then
            print("Invalid society ID or label.")
            return
        end
        
        local society = Societies[societyId]
        if not society then
            print("Society with ID " .. societyId .. " not found.")
            return
        end

        local exist = false
        for _, s in pairs(Societies) do
            if s.getLabel() == newLabel and s.getId() ~= societyId then
                exist = true
                break
            end
        end

        if exist then
            print("A society with the label '" .. newLabel .. "' already exists.")
            return
        end
        if newLabel == "" then
            print("Label cannot be empty.")
            return
        end

        society.setLabel(newLabel)
        print("Society label updated successfully: " .. society.toString())
    else
        print("This command can only be used from the server console.")
    end
end, false)