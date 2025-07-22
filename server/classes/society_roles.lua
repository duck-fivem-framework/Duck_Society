function DuckSocietyRoles()
    local self = DuckClass(Config.MagicString.KeyStringRoles)

    self.isDefault = false

    self = __LoadId(self)
    self = __LoadName(self)
    self = __LoadLabel(self)
    self = __LoadSociety(self)
    self = __LoadSalary(self)
    self = __LoadPromotableRoles(self)
    self = __LoadDemotableRoles(self)
    self = __LoadIsDefault(self)

    self.bankNotification = false
    self.setBankNotification = function(value)
        self.bankNotification = value
    end
    self.getBankNotification = function()
        return self.bankNotification
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

    self.loadPermissionFromDatabase = function(data)
        if data then
            if data.canPromote then
                for _, roleId in pairs(data.canPromote) do
                    local role = Societies[self.getSocietyId()].getRoleById(roleId)
                    if role then
                        local success, error = self.addPromotableRole(role)
                        if not success then
                            print("Error: " .. error)
                        else
                            print("Promotable role added successfully: " .. role.toString())
                        end
                    else
                        print("Error: Promotable role with ID " .. roleId .. " not found")
                    end
                end
            end

            if data.canDemote then
                for _, roleId in pairs(data.canDemote) do
                    local role = Societies[self.getSocietyId()].getRoleById(roleId)
                    if role then
                        local success, error = self.addDemotableRole(role)
                        if not success then
                            print("Error: " .. error)
                        else
                            print("Demotable role added successfully: " .. role.toString())
                        end
                    else
                        print("Error: Demotable role with ID " .. roleId .. " not found")
                    end
                end
            end
        else
            print("Error: No data provided to load permissions for DuckSocietyRoles")
        end
    end

    self.toString = function()
        return string.format("DuckSocietyRoles: { id: %d, societyId: %d, name: '%s', label: '%s', salary: %d, isDefault: %s }",
            self.getId(), self.getSocietyId(), self.getName(), self.getLabel(), self.getSalary(), tostring(self.getIsDefault()))
    end

    self.storeInFile = function(f)
        f:write("        {\n")
        f:write("            id = " .. self.getId() .. ",\n")
        f:write("            societyId = " .. self.getSocietyId() .. ",\n")
        f:write("            name = \"" .. self.getName() .. "\",\n")
        f:write("            label = \"" .. self.getLabel() .. "\",\n")
        f:write("            salary = " .. self.getSalary() .. ",\n")
        f:write("            isDefault = " .. tostring(self.getIsDefault()) .. ",\n")
        f:write("            canPromote = {\n")
        for _,promotableRole in pairs(self.getPromotableRoles()) do
            f:write("                " .. promotableRole.getId() .. ",\n")
        end
        f:write("            },\n")
        f:write("            canDemote = {\n")
        for _,demotableRole in pairs(self.getDemotableRoles()) do
            f:write("                " .. demotableRole.getId() .. ",\n")
        end
        f:write("            }\n")
        f:write("        },\n")
    end

    self.lazyLoading = function()
        for k,roleDatas in pairs(Database.roles) do
            if roleDatas.societyId == self.getSocietyId() and roleDatas.id == self.getId() then
                self.loadPermissionFromDatabase(roleDatas)
            end
        end
    end

    return self
end