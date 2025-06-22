function __LoadAccounts(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.accounts = {}

    object.isAccount = function(targetObject)
        if not targetObject or type(targetObject) ~= 'table' then
            return false, 'Invalid object provided'
        end

        if not targetObject.__metas or targetObject.__metas.object ~= Config.MagicString.KeyStringAccount then
            return false, 'Object is not a valid account'
        end

        return true, 'Object is a valid account'
    end

    if not object.getAccounts then
        object.getAccounts = function() return object.accounts end
    end

    if not object.addAccount then
        object.addAccount = function(account)
            local isValid, message = object.isAccount(account)
            if not isValid then
                print("Error: " .. message)
                return false, message
            end
            object.accounts[account.getId()] = account
            return true, 'Account added successfully'
        end
    end

    if not object.removeAccount then
        object.removeAccount = function(account)
            local isValid, message = object.isAccount(account)
            if not isValid then
                print("Error: " .. message)
                return false, message
            end
            local accountId = account.getId()
            if not object.accounts[accountId] then
                print("Error: Account not found")
                return false, 'Account not found'
            end

            object.accounts[accountId] = nil
            return true, 'Account removed successfully'
        end
    end

    if not object.getAccount then
        object.getAccount = function(accountUsage)
            if not accountUsage or type(accountUsage) ~= 'string' then
                print("Error: Invalid account usage provided")
                return nil, 'Invalid account usage provided'
            end

            for _, account in pairs(object.accounts) do
                if account.getUsage() == accountUsage then
                    return account, 'Account found successfully'
                end
            end

            print("Error: No account found with the specified usage")
            return nil, 'No account found with the specified usage'
        end
    end


    return object
end