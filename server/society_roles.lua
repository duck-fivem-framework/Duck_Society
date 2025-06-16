function DuckSocietyRoles()
    local self = {}
    self.__metas = { object = Config.MagicString.KeyStringRoles }

    self.id = nil
    self.societyId = nil
    self.name = nil
    self.label = nil
    self.salary = 0
    self.isDefault = false
    self.promotableRoles = {}
    self.demotableRoles = {}

    self.setId = function(id) self.id = tonumber(id) end
    self.getId = function() return self.id end
    self.setSocietyId = function(societyId) self.societyId = tonumber(societyId) end
    self.getSocietyId = function() return self.societyId end
    self.setName = function(name) self.name = string.lower(name) end
    self.getName = function() return self.name end
    self.setLabel = function(label) self.label = label end
    self.getLabel = function() return self.label end
    self.setSalary = function(salary) self.salary = tonumber(salary) end
    self.getSalary = function() return self.salary end
    self.setIsDefault = function(isDefault) self.isDefault = isDefault end
    self.getIsDefault = function() return self.isDefault end
    self.getPromotableRoles = function() return self.promotableRoles end
    self.getDemotableRoles = function() return self.demotableRoles end

    self.addPromotableRole = function(role)
        if not role or type(role) ~= 'table' or not role.__metas or role.__metas.object ~= Config.MagicString.KeyStringRoles then
            print("Error: Invalid role provided for promotable roles")
            return false, 'Invalid role provided'
        end

        if role.getId() == self.getId() then
            print("Error: Cannot add the same role to promotable roles")
            return false, 'Cannot add the same role to promotable roles'
        end

        if role.getSocietyId() ~= self.getSocietyId() then
            print("Error: Role does not belong to the same society")
            return false, 'Role does not belong to the same society'
        end

        self.promotableRoles[role.getId()] = role

        return true, 'Role added to promotable roles'
    end

    self.removePromotableRole = function(roleId)
        if not roleId or type(roleId) ~= 'number' then
            print("Error: Invalid role ID provided for removal from promotable roles")
            return false, 'Invalid role ID provided'
        end

        if not self.promotableRoles[roleId] then
            print("Error: Role ID not found in promotable roles")
            return false, 'Role ID not found in promotable roles'
        end

        self.promotableRoles[roleId] = nil
        return true, 'Role removed from promotable roles'
    end

    self.addDemotableRole = function(role)
        if not role or type(role) ~= 'table' or not role.__metas or role.__metas.object ~= Config.MagicString.KeyStringRoles then
            print("Error: Invalid role provided for demotable roles")
            return false, 'Invalid role provided'
        end

        if role.getId() == self.getId() then
            print("Error: Cannot add the same role to demotable roles")
            return false, 'Cannot add the same role to demotable roles'
        end

        if role.getSocietyId() ~= self.getSocietyId() then
            print("Error: Role does not belong to the same society")
            return false, 'Role does not belong to the same society'
        end

        self.demotableRoles[role.getId()] = role

        return true, 'Role added to demotable roles'
    end

    self.removeDemotableRole = function(roleId)
        if not roleId or type(roleId) ~= 'number' then
            print("Error: Invalid role ID provided for removal from demotable roles")
            return false, 'Invalid role ID provided'
        end

        if not self.demotableRoles[roleId] then
            print("Error: Role ID not found in demotable roles")
            return false, 'Role ID not found in demotable roles'
        end

        self.demotableRoles[roleId] = nil
        return true, 'Role removed from demotable roles'
    end

    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setSocietyId(data.societyId)
            self.setName(data.name)
            self.setLabel(data.label)
            self.setSalary(data.salary)
            self.setIsDefault(data.isDefault)
        else
            print("Error: No data provided to load DuckSocietyRoles")
        end
    end

    self.setSociety = function(society)
        if not society or type(society) ~= 'table' then
            print("Error: Invalid society provided")
            return false, 'Invalid society provided'
        end

        if not society.__metas or society.__metas.object ~= Config.MagicString.KeyStringSociety then
            return false, 'Invalid society object'
        end

        self.setSocietyId(society.getId())
        return true, 'Society set successfully'
    end

    self.toString = function()
        return string.format("DuckSocietyRoles: { id: %d, societyId: %d, name: '%s', label: '%s', salary: %d, isDefault: %s }",
            self.getId(), self.getSocietyId(), self.getName(), self.getLabel(), self.getSalary(), tostring(self.getIsDefault()))
    end

    return self
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