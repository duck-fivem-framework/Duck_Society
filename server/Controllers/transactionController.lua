Transactions = {}

function LoadTransactionsFromDatabase()
    for k,v in pairs(Database.transactions) do
        local transaction = DuckTransaction()
        transaction.loadFromDatabase(v)
        Transactions[transaction.getId()] = transaction
        print("Loaded transaction: " .. transaction.toString())
    end
end

local function Notificate(transaction)
    if not transaction then
        print("Error: Transaction is nil")
        return
    end
    if not transaction.__metas.isModel(transaction, Config.MagicString.KeyStringTransaction) then
        print("Error: Invalid transaction object")
        return
    end

    local owner = transaction.getOwner()
    if not owner then
        print("Error: Owner is not set or invalid")
        return
    end

    local target = transaction.getTarget()
    if not target then
        print("Error: Target is not set or invalid")
        return
    end

    if owner.getOwnerType() ==  Config.MagicString.KeyStringPlayers then
        local player = owner.getOwner()
        if player.isOnline() then
            print(string.format("Transaction from %s to %s: %s", owner.getIban(), target.getIban(), transaction.getBalance()))
        end
    end
    if target.getOwnerType() ==  Config.MagicString.KeyStringPlayers then
        local player = target.getOwner()
        if player.isOnline() then
            print(string.format("Transaction from %s to %s: %s", owner.getIban(), target.getIban(), transaction.getBalance()))
        end
    end
    if owner.getOwnerType() ==  Config.MagicString.KeyStringSociety then
        owner.getOwner().notificateBank(owner, target, transaction)
    end
    if target.getOwnerType() ==  Config.MagicString.KeyStringSociety then
        target.getOwner().notificateBank(owner, target, transaction)
    end
end

RegisterCommand('createNewTransaction', function(source, args, rawCommand)
    if source ~= 0 then
        print("This command can only be used from the server console.")
        return
    end

    if #args < 4 then
        print("Usage: createNewTransaction <amount> <fromAccountId> <toAccountId> <label>")
        return
    end

    local amount = tonumber(args[1])
    local fromAccountId = tonumber(args[2])
    local toAccountId = tonumber(args[3])
    local label = args[4] or "Transaction"
    if not amount or not fromAccountId or not toAccountId then
        print("Invalid arguments. Please provide a valid amount and account IDs.")
        return
    end

    local fromAccount = Accounts[fromAccountId]
    local toAccount = Accounts[toAccountId]

    if not fromAccount or not toAccount then
        print("Invalid account IDs provided.")
        return
    end

    if fromAccount.getBalance() < amount then
        print("Insufficient balance in the from account.")
        return
    end

    local transaction = DuckTransaction()
    transaction.setOwnerType(Config.MagicString.KeyStringAccount)
    transaction.setTargetType(Config.MagicString.KeyStringAccount)
    transaction.setOwnerId(fromAccountId)
    transaction.setTargetId(toAccountId)
    transaction.setBalance(amount)
    transaction.setLabel(label)
    transaction.setId(Database.maxTransactionId + 1)
    Transactions[transaction.getId()] = transaction

    print("Transaction created successfully: " .. transaction.toString())
    Notificate(transaction)
end, false)