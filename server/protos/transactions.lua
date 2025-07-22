function __LoadTransactions(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.transactions = {}

    if not object.setTransactions then
        object.setTransactions = function(transactions)
            if type(transactions) ~= 'table' then
                print("Error: Transactions must be a table")
                return false, 'Transactions must be a table'
            end

            object.transactions = transactions
            return true, 'Transactions set successfully'
        end
    end

    if not object.getTransactions then
        object.getTransactions = function()
            return object.transactions
        end
    end

    if not object.addTransaction then
        object.addTransaction = function(transaction)
            if not transaction.__metas.isModel(transaction, Config.MagicString.KeyStringTransaction) then
                print("Error: Invalid transaction object")
                return false, 'Invalid transaction object'
            end

            if object.transactions[transaction.getId()] then
                print("Error: Transaction already exists")
                return false, 'Transaction already exists'
            end

            object.transactions[transaction.getId()] = transaction
            return true, 'Transaction added successfully'
        end
    end

    if not object.removeTransaction then
        object.removeTransaction = function(transaction)
            if not transaction.metas.isModel(transaction, Config.MagicString.KeyStringTransaction) then
                print("Error: Invalid transaction object")
                return false, 'Invalid transaction object'
            end

            if not object.transactions[transaction.getId()] then
                print("Error: Transaction does not exist")
                return false, 'Transaction does not exist'
            end

            object.transactions[transaction.getId()] = nil
            return true, 'Transaction removed successfully'
        end
    end

    return object
end
