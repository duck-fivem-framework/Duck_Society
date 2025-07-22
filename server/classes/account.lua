function DuckAccount()

    local self = DuckClass(Config.MagicString.KeyStringAccount)

    self = __LoadId(self)
    self = __LoadOwner(self)
    self = __LoadLabel(self)
    self =  __LoadBalance(self)
    self =  __LoadIban(self)
    self =  __LoadUsage(self)
    self =  __LoadTransactions(self)

    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setOwnerType(data.owner_type)
            self.setOwnerId(data.owner_id)
            self.setBalance(data.balance or 0.0) -- Default to 0.0 if balance is not provided
            self.setUsage(data.usage or 'not_defined') -- Default to 'player_bank' if usage is not provided
            self.setLabel(data.label or 'No Label') -- Default to 'No Label' if label is not provided
            self.setIban(data.iban or 'No IBAN') -- Default to 'No IBAN' if iban is not provided
        else
            print("Error: No data provided to load DuckAccount")
        end
    end

    self.addMoney = function(amount)
        if amount and type(amount) == 'number' and amount > 0 then
            self.setBalance(self.getBalance() + amount)
            return true, 'Money added successfully'
        else
            print("Error: Invalid amount to add")
            return false, 'Invalid amount to add'
        end
    end

    self.removeMoney = function(amount)
        if amount and type(amount) == 'number' and amount > 0 then
            if self.getBalance() >= amount then
                self.setBalance(self.getBalance() - amount)
                return true, 'Money removed successfully'
            else
                print("Error: Insufficient balance")
                return false, 'Insufficient balance'
            end
        else
            print("Error: Invalid amount to remove")
            return false, 'Invalid amount to remove'
        end
    end

    self.storeInFile = function(f)
        f:write("        {\n")
        f:write("            id = " .. self.getId() .. ",\n")
        f:write("            label = \"" .. self.getLabel() .. "\",\n")
        f:write("            owner_type = \"" .. tostring(self.getOwnerType()) .. "\",\n")
        f:write("            owner_id = " .. self.getOwnerId() .. ",\n")
        f:write("            balance = " .. self.getBalance() .. ",\n")
        f:write("            usage = \"" .. tostring(self.getUsage()) .. "\",\n")
        f:write("            iban = \"" .. tostring(self.getIban()) .. "\"\n")
        f:write("        },\n")
    end

    self.toString = function()
        return string.format("DuckAccount: { id: %d, owner_type: '%s', owner_id: %d, balance: %.2f, usage: '%s', iban: '%s', label: '%s' }",
            self.getId(), self.getOwnerType(), self.getOwnerId(), self.getBalance(), self.getUsage(), self.getIban(), self.getLabel())
    end

    return self
end