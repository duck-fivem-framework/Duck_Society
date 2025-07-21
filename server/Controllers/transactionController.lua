Transactions = {}

function LoadTransactionsFromDatabase()
    for k,v in pairs(Database.transactions) do
        local transaction = DuckTransaction()
        transaction.loadFromDatabase(v)
        Transactions[transaction.getId()] = transaction
    end
end