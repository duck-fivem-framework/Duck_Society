function DuckPermission()

    local self = DuckClass(Config.MagicString.KeyStringPermission)

    self = __LoadId(self)
    self = __LoadLabel(self)
    self = __LoadName(self)
    self = __LoadDescription(self)

    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setName(data.name or 'No Name') -- Default to 'No Name' if name is not provided
            self.setLabel(data.label or 'No Label') -- Default to 'No Label' if label is not provided
            self.setDescription(data.description or 'No Description') -- Default to 'No Description' if description is not provided
        else
            print("Error: No data provided to load DuckPermission")
        end
    end

    self.toString = function()
        return string.format("DuckPermission: { id: %d, name: '%s', label: '%s', description: '%s' }",
            self.getId(), self.getName(), self.getLabel(), self.getDescription())
    end

    self.storeInFile = function(f)
        f:write("        {\n")
        f:write("            id = " .. self.getId() .. ",\n")
        f:write("            name = \"" .. self.getName() .. "\",\n")
        f:write("            label = \"" .. self.getLabel() .. "\",\n")
        f:write("            description = \"" .. self.getDescription() .. "\"\n")
        f:write("        },\n")
    end

    return self

end