SocietyRoles = {}


function LoadSocietyRoles()
  for k,v in pairs(Database.roles) do
    local role = DuckSocietyRoles()
    role.loadFromDatabase(v)
    SocietyRoles[role.getId()] = role
  end
end

RegisterCommand("editRoleSalary", function(source, args, rawCommand)
    if source == 0 then
        if #args < 3 then
            print("Usage: editRoleSalary <roleId> <newSalary>")
            return
        end

        local roleId = tonumber(args[1])
        local newSalary = tonumber(args[2])
        if not roleId or not newSalary then
            print("Invalid role ID or salary.")
            return
        end
        
        local role = nil

        for k,v in pairs(Societies) do
            for kk,vv in pairs(v.getRoles()) do
                if vv.getId() == roleId then
                    role = vv
                    break
                end
            end
        end

        if not role then
            print("Role with ID " .. roleId .. " not found.")
            return
        end

        if newSalary < 0 then
            print("Salary cannot be negative.")
            return
        end

        role.setSalary(newSalary)
        print("Role salary updated successfully: " .. role.toString())
    else
        print("This command can only be used from the server console.")
    end
end, false)

RegisterCommand("editRoleLabel", function(source, args, rawCommand)
    if source == 0 then
        if #args < 2 then
            print("Usage: editRoleLabel <roleId> <newLabel>")
            return
        end

        local roleId = tonumber(args[1])
        local newLabel = args[2]
        if not roleId or not newLabel then
            print("Invalid role ID or label.")
            return
        end
        
        local role = nil

        for k,v in pairs(Societies) do
            for kk,vv in pairs(v.getRoles()) do
                if vv.getId() == roleId then
                    role = vv
                    break
                end
            end
        end

        if not role then
            print("Role with ID " .. roleId .. " not found.")
            return
        end

        local exist = false
        for k,v in pairs(Societies) do
            for kk,vv in pairs(v.getRoles()) do
                if vv.getLabel() == newLabel and vv.getId() ~= roleId then
                    exist = true
                    break
                end
            end
        end

        if exist then
            print("A role with the label '" .. newLabel .. "' already exists.")
            return
        end
        if newLabel == "" then
            print("Label cannot be empty.")
            return
        end

        role.setLabel(newLabel)
        print("Role label updated successfully: " .. role.toString())
    else
        print("This command can only be used from the server console.")
    end
end, false)

RegisterCommand("addNewPromotableRole", function(source, args, rawCommand)
    if source == 0 then
        if #args < 2 then
            print("Usage: addNewPromotableRole <roleId> <newRoleId>")
            return
        end

        local roleId = tonumber(args[1])
        local newRoleId = tonumber(args[2])

        if not roleId or not newRoleId then
            print("Invalid role ID or new role ID.")
            return
        end
        
        local role = nil
        for k,v in pairs(Societies) do
            local roleCheck = v.getRoleById(roleId)
            if roleCheck then
                role = roleCheck
                break
            end
        end

        if not role then
            print("Role with ID " .. roleId .. " not found.")
            return
        end

        local newRole = role.getSociety().getRoleById(newRoleId)

        if not newRole then
            print("New role with ID " .. newRoleId .. " not found.")
            return
        end

        if newRole.getSociety().getId() ~= role.getSociety().getId() then
            print("New role does not belong to the same society as the original role.")
            return
        end

        local success, message = role.addPromotableRole(newRole)
        if success then
            print("New promotable role added successfully: " .. newRole.toString())
        else
            print("Error adding promotable role: " .. message)
        end
    else
        print("This command can only be used from the server console.")
    end
end, false)

RegisterCommand("removePromotableRole", function(source, args, rawCommand)
    if source == 0 then
        if #args < 2 then
            print("Usage: removePromotableRole <roleId> <roleToRemoveId>")
            return
        end

        local roleId = tonumber(args[1])
        local roleToRemoveId = tonumber(args[2])

        if not roleId or not roleToRemoveId then
            print("Invalid role ID or role to remove ID.")
            return
        end
        
        local role = nil
        for k,v in pairs(Societies) do
            local roleCheck = v.getRoleById(roleId)
            if roleCheck then
                role = roleCheck
                break
            end
        end

        if not role then
            print("Role with ID " .. roleId .. " not found.")
            return
        end

        local oldRole = role.getSociety().getRoleById(roleToRemoveId)

        if not oldRole then
            print("Old role with ID " .. oldRole .. " not found.")
            return
        end

        if oldRole.getSociety().getId() ~= role.getSociety().getId() then
            print("New role does not belong to the same society as the original role.")
            return
        end

        local success, message = role.removePromotableRole(oldRole)
        if success then
            print("Promotable role removed successfully.")
        else
            print("Error removing promotable role: " .. message)
        end
    else
        print("This command can only be used from the server console.")
    end
end, false)