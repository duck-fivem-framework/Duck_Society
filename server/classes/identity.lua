function DuckIdentity()
    local self = DuckClass(Config.MagicString.KeyStringIdentity)

    self.firstname = nil
    self.lastname = nil
    self.dateofbirth = nil

    self = __LoadId(self)

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

    self.storeInFile = function(f)
      f:write("        {\n")
      f:write("            id = " .. self.getId() .. ",\n")
      f:write("            firstname = \"" .. self.getFirstname() .. "\",\n")
      f:write("            lastname = \"" .. self.getLastname() .. "\",\n")
      f:write("            dateofbirth = \"" .. self.getDateOfBirth() .. "\"\n")
      f:write("        },\n")
    end

    return self
end