Accounts = {}

function LoadAccountsFromDatabase()
    for k,v in pairs(Database.accounts) do
        local account = DuckAccount()
        account.loadFromDatabase(v)
        Accounts[account.getId()] = account
    end
end