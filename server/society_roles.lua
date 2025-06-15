function DuckSocietyRoles()
    local self = {}
    self.__metas = { object = Config.MagicString.KeyStringRoles }

    self.id = nil
    self.societyId = nil
    self.name = nil
    self.label = nil
    self.salary = 0
    self.isDefault = false

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

    return self
end