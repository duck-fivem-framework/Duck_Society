function __LoadPromotableRoles(object)

    if not object or type(object) ~= 'table' then
        return object
    end

    object.promotableRoles = {}

    if not object.setPromotableRoles then
        object.setPromotableRoles = function(roles)
            if type(roles) ~= 'table' then
                print("Error: Roles must be a table")
                return false, 'Roles must be a table'
            end


            for _, role in pairs(roles) do
                if object.metas.isModel(role, Config.MagicString.KeyStringRole) then
                    -- skip row
                else
                    print("Error: Invalid role object inside roles table")
                    return false, 'Invalid role object inside roles table'
                end

                if role.getSocietyId() ~= object.getSocietyId() then
                    print("Error: Role does not belong to the same society")
                    return false, 'Role does not belong to the same society'
                end
            end

            object.promotableRoles = roles
            return true, 'Promotable roles set successfully'
        end
    end

    if not object.getPromotableRoles then
        object.getPromotableRoles = function()
            return object.promotableRoles
        end
    end
    if not object.addPromotableRole then
        object.addPromotableRole = function(role)
            if not object.metas.isModel(role, Config.MagicString.KeyStringRole) then
                print("Error: Invalid role object")
                return false, 'Invalid role object'
            end

            if role.getSocietyId() ~= object.getSocietyId() then
                print("Error: Role does not belong to the same society")
                return false, 'Role does not belong to the same society'
            end

            if object.promotableRoles[role.getId()] then
                print("Error: Role already exists in promotable roles")
                return false, 'Role already exists in promotable roles'
            end
            object.promotableRoles[role.getId()] = role
            return true, 'Promotable role added successfully'
        end
    end
    if not object.removePromotableRole then
        object.removePromotableRole = function(role)
            if not object.metas.isModel(role, Config.MagicString.KeyStringRole) then
                print("Error: Invalid role object")
                return false, 'Invalid role object'
            end

            if role.getSocietyId() ~= object.getSocietyId() then
                print("Error: Role does not belong to the same society")
                return false, 'Role does not belong to the same society'
            end

            if not object.promotableRoles[role.getId()] then
                print("Error: Role not found in promotable roles")
                return false, 'Role not found in promotable roles'
            end

            object.promotableRoles[role.getId()] = nil
            return true, 'Promotable role removed successfully'
        end
    end
    if not object.getPromotableRole then
        object.getPromotableRole = function(role)
            if not object.metas.isModel(role, Config.MagicString.KeyStringRole) then
                print("Error: Invalid role object")
                return nil, 'Invalid role object'
            end

            local roleId = role.getId()
            if not object.promotableRoles[roleId] then
                print("Error: Role not found in promotable roles")
                return nil, 'Role not found in promotable roles'
            end

            if role.getSocietyId() ~= object.getSocietyId() then
                print("Error: Role does not belong to the same society")
                return nil, 'Role does not belong to the same society'
            end

            return role, 'Promotable role retrieved successfully'
        end
    end

    if not object.canPromotePlayer then
        object.canPromotePlayer = function(role, player, member)
            local isValid = object.getPromotableRole(role)
            if not isValid then
                print("Error: Role is not promotable")
                return false, 'Role is not promotable'
            end
            local isPlayer = object.metas.isModel(player, Config.MagicString.KeyStringPlayer)
            if not isPlayer then
                print("Error: Invalid player object")
                return false, 'Invalid player object'
            end
            local isMember = object.metas.isModel(member, Config.MagicString.KeyStringMember)
            if not isMember then
                print("Error: Invalid member object")
                return false, 'Invalid member object'
            end



            if not member then
                print("Error: Player is not a member of the society")
                return false, 'Player is not a member of the society'
            end

            local canPromotePlayer = object.getPromotableRole(member.getRole())
            if not canPromotePlayer then
                print("Error: Player cannot be promoted to this role")
                return false, 'Player cannot be promoted to this role'
            end

            return true
        end
    end

    if not object.promotePlayerRole then
        object.promotePlayerRole = function(role, player)
            local member = nil
            for k,v in pairs(object.getSociet().getMembers()) do
                if v.getPlayerId() == player.getId() then
                    member = v
                    break
                end
            end

            if not member then
                print("Error: Player is not a member of the society")
                return false, 'Player is not a member of the society'
            end
            local isValid, message = object.canPromotePlayer(role, player, member)
            if not isValid then
                return false, message
            end
            member.setRole(role)
            return true, 'Player promoted successfully'
        end
    end


    return object
end