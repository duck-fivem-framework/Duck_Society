function __LoadPermissions(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.permissions = {}

    if not object.getPermissions then
        object.getPermissions = function() return object.permissions end
    end

    if not object.setPermissions then
        object.setPermissions = function(permissions)
            if type(permissions) == 'table' then
                object.permissions = permissions
            else
                print("Error: Permissions must be a table")
            end
        end
    end

    if not object.addPermission then
        object.addPermission = function(permission)
            if not permission.__metas.isModel(permission, Config.MagicString.KeyStringPermission) then
                print("Error: Invalid permission object")
                return false, 'Invalid permission object'
            end
            if not object.permissions[permission.getId()] then
                object.permissions[permission.getId()] = permission
                return true, 'Permission added successfully'
            else
                print("Error: Permission already exists")
                return false, 'Permission already exists'
            end
        end
    end

    if not object.removePermission then
        object.removePermission = function(permission)
            if not permission.__metas.isModel(permission, Config.MagicString.KeyStringPermission) then
                print("Error: Invalid permission object")
                return false, 'Invalid permission object'
            end
            if object.permissions[permission.getId()] then
                object.permissions[permission.getId()] = nil
                return true, 'Permission removed successfully'
            else
                print("Error: Permission does not exist")
                return false, 'Permission does not exist'
            end
        end
    end

    if not object.hasPermission then
        object.hasPermission = function(permission)
            if type(permission) == 'string' then
                for _, perm in pairs(object.permissions) do
                    if perm.getName() == permission then
                        return true
                    end
                    if perm.getLabel() == permission then
                        return true
                    end
                end
            end
            if type(permission) == 'table' then
                if not permission.__metas.isModel(permission, Config.MagicString.KeyStringPermission) then
                    print("Error: Invalid permission object")
                    return false, 'Invalid permission object'
                end

                return object.permissions[permission.getId()] ~= nil
            end
            if type(permission) == 'number' then
                return object.permissions[permission] ~= nil
            end
        end
    end

    return object
end