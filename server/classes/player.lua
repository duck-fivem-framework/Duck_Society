function DuckPlayer()
    local self = DuckClass(Config.MagicString.KeyStringPlayers)

    self = __LoadId(self)
    self = __LoadAccounts(self)
    self = __LoadIdentity(self)
    self = __LoadIdentifier(self)
    self = __LoadSource(self)
    self = __LoadOnline(self)
    self = __LoadLocation(self)
    self.location = DuckLocation()

    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setIdentifier(data.identifier)
            self.setIdentityId(data.identityId)
            if data.location then
                self.getLocation().setX(data.location.x)
                self.getLocation().setY(data.location.y)
                self.getLocation().setZ(data.location.z)
                self.getLocation().setHeading(data.location.heading)
            end
        else
            print("Error: No data provided to load DuckPlayers")
        end
    end

    self.lazyLoading = function()
        for _, account in pairs(Accounts) do
            if account.getOwnerType() == self.__metas.object and account.getOwnerId() == self.getId() then
                local compatibility, errorMessage = self.addAccount(account)
                if not compatibility then
                    print("Error: " .. errorMessage)
                else
                    print("Account added successfully for player ID " .. self.getId())
                end
            end
        end
        
        if self.getIdentityId() then
            local identity, errorMessage = self.getIdentity()
            if not identity then
                print("Error: " .. errorMessage)
            else
                print("Identity loaded successfully for player ID " .. self.getId())
            end
        end

    end

    self.toString = function()
        return string.format("DuckPlayer: { id: %d, identifier: '%s', money: %d, identity: %s}",
            self.getId(), self.getIdentifier(), self.getMoney(),
            self.identityId and self.getIdentity().getFullName() or 'nil')
    end

    self.storeInFile = function(f)
      f:write("        {\n")
      f:write("            id = " .. self.getId() .. ",\n")
      f:write("            identityId = " .. self.getIdentityId() .. ",\n")
      f:write("            identifier = \"" .. self.getIdentifier() .. "\",\n")
      if self.getLocation().getX() ~= nil then
        f:write("            location = {\n")
        f:write("                x = " .. self.getLocation().getX() .. ",\n")
        f:write("                y = " .. self.getLocation().getY() .. ",\n")
        f:write("                z = " .. self.getLocation().getZ() .. ",\n")
        f:write("                heading = " .. self.getLocation().getHeading() .. "\n")
        f:write("            },\n")
      end
      f:write("        },\n")
    end

    return self
end