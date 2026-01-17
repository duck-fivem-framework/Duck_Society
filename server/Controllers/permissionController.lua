Permissions = {}

function LoadPermissionsFromDatabase()
    for k,v in pairs(Database.permissions) do
        local permission = DuckPermission()
        permission.loadFromDatabase(v)
        Permissions[permission.getId()] = permission
    end
end