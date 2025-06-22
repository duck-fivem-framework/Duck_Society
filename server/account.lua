Accounts = {}

function DuckAccouunt()

    local self = DuckClass(Config.MagicString.KeyStringAccount)


    self.balance = 0.0 -- Balance of the account
    self.usage = nil -- 'player' or 'society_bank' or 'player_bank' or 
    self.iban = nil -- International Bank Account Number (IBAN) for the account

    self = __LoadId(self)
    self = __LoadOwner(self)
    self = __LoadLabel(self)

    self.setBalance = function(balance) self.balance = tonumber(balance) end
    self.getBalance = function() return self.balance end
    self.setUsage = function(usage) self.usage = usage end
    self.getUsage = function() return self.usage end
    self.setIban = function(iban) self.iban = iban end
    self.getIban = function() return self.iban end

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