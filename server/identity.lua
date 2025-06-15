function DuckIdentity()
    local self = {}
    self.__metas = { object = Config.MagicString.KeyStringIdentity }

    self.id = nil
    self.firstname = nil
    self.lastname = nil
    self.dateofbirth = nil

    self.setId = function(id) self.id = tonumber(id) end
    self.getId = function() return self.id end
    self.setFirstname = function(firstname) self.firstname = string.lower(firstname) end
    self.getFirstname = function() return self.firstname end
    self.setLastname = function(lastname) self.lastname = string.lower(lastname) end
    self.getLastname = function() return self.lastname end
    self.setDateOfBirth = function(dateofbirth) self.dateofbirth = dateofbirth end
    self.getDateOfBirth = function() return self.dateofbirth end

    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setFirstname(data.firstname)
            self.setLastname(data.lastname)
            self.setDateOfBirth(data.dateofbirth)
        else
            print("Error: No data provided to load DuckIdentity")
        end
    end

    self.toString = function()
        return string.format("DuckIdentity: { id: %d, firstname: '%s', lastname: '%s', dateofbirth: '%s' }",
            self.getId(), self.getFirstname(), self.getLastname(), self.getDateOfBirth())
    end

    self.getFullName = function()
        return string.format("%s %s", self.getFirstname(), self.getLastname())
    end

    return self
end
