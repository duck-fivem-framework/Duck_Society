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