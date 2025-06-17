Accounts = {}

function DuckAccouunt()

    local self = {}

    self.__metas = { object = Config.MagicString.KeyStringAccount }

    self.id = nil
    self.owner_type = nil -- 'Config.MagicString.KeyString'
    self.owner_id = nil -- ID of the entity that owns this account
    self.balance = 0.0 -- Balance of the account
    self.usage = nil -- 'player' or 'society_bank' or 'player_bank' or 
    self.label = nil -- Label for the account
    self.iban = nil -- International Bank Account Number (IBAN) for the account

    self.setId = function(id) self.id = tonumber(id) end
    self.getId = function() return self.id end
    self.setOwnerType = function(owner_type) self.owner_type = owner_type end
    self.getOwnerType = function() return self.owner_type end
    self.setOwnerId = function(owner_id) self.owner_id = tonumber(owner_id) end
    self.getOwnerId = function() return self.owner_id end
    self.setBalance = function(balance) self.balance = tonumber(balance) end
    self.getBalance = function() return self.balance end
    self.setUsage = function(usage) self.usage = usage end
    self.getUsage = function() return self.usage end
    self.setLabel = function(label) self.label = label end
    self.getLabel = function() return self.label end
    self.setIban = function(iban) self.iban = iban end
    self.getIban = function() return self.iban end

    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setOwnerType(data.owner_type)
            self.setOwnerId(data.owner_id)
            self.setBalance(data.balance or 0.0) -- Default to 0.0 if balance is not provided
        else
            print("Error: No data provided to load DuckAccount")
        end
    end

    self.getOwner = function()
        if not self.owner_type or not self.owner_id then
            print("Error: Owner type or ID is not set")
            return nil, 'Owner type or ID is not set'
        end

        if self.owner_type == Config.MagicString.KeyStringPlayer then
            local player = Players[self.owner_id]
            if player then
                return player, 'Player retrieved successfully'
            else
                print("Error: Player not found")
                return nil, 'Player not found'
            end
        elseif self.owner_type == Config.MagicString.KeyStringSociety then
            local society = Societies[self.owner_id]
            if society then
                return society, 'Society retrieved successfully'
            else
                print("Error: Society not found")
                return nil, 'Society not found'
            end
        else
            print("Error: Invalid owner type")
            return nil, 'Invalid owner type'
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

    self.toString = function()
        return string.format("DuckAccount: { id: %d, owner_type: '%s', owner_id: %d, balance: %.2f }",
            self.getId(), self.getOwnerType(), self.getOwnerId(), self.getBalance())
    end

    return self
end

function LoadAccountsFromDatabase()
    for k,v in pairs(Database.accounts) do
        local account = DuckAccouunt()
        account.loadFromDatabase(v)
        Accounts[account.getId()] = account
    end
end