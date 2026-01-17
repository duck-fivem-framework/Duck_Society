function __LoadDemotableRoles(object)

    if not object or type(object) ~= 'table' then
        return object
    end

    object.demotableRoles = {}

    if not object.setDemotableRoles then
        object.setDemotableRoles = function(roles)
            if type(roles) ~= 'table' then
                print("Error: Roles must be a table")
                return false, 'Roles must be a table'
            end

            for _, role in pairs(roles) do
                if not object.metas.isModel(role, Config.MagicString.KeyStringRole) then
                    print("Error: Invalid role object inside roles table")
                    return false, 'Invalid role object inside roles table'
                end

                if role.getSocietyId() ~= object.getSocietyId() then
                    print("Error: Role does not belong to the same society")
                    return false, 'Role does not belong to the same society'
                end
            end

            object.demotableRoles = roles
            return true, 'Demotable roles set successfully'
        end
    end

    if not object.getDemotableRoles then
        object.getDemotableRoles = function()
            return object.demotableRoles
        end
    end

    if not object.addDemotableRole then
        object.addDemotableRole = function(role)
            if not object.metas.isModel(role, Config.MagicString.KeyStringRole) then
                print("Error: Invalid role object")
                return false, 'Invalid role object'
            end

            if role.getSocietyId() ~= object.getSocietyId() then
                print("Error: Role does not belong to the same society")
                return false, 'Role does not belong to the same society'
            end

            if object.demotableRoles[role.getId()] then
                print("Error: Role already exists in demotable roles")
                return false, 'Role already exists in demotable roles'
            end

            object.demotableRoles[role.getId()] = role
            return true, 'Demotable role added successfully'
        end
    end

    if not object.removeDemotableRole then
        object.removeDemotableRole = function(role)
            if not object.metas.isModel(role, Config.MagicString.KeyStringRole) then
                print("Error: Invalid role object")
                return false, 'Invalid role object'
            end

            if role.getSocietyId() ~= object.getSocietyId() then
                print("Error: Role does not belong to the same society")
                return false, 'Role does not belong to the same society'
            end

            if not object.demotableRoles[role.getId()] then
                print("Error: Role not found in demotable roles")
                return false, 'Role not found in demotable roles'
            end

            object.demotableRoles[role.getId()] = nil
            return true, 'Demotable role removed successfully'
        end
    end

    if not object.getDemotableRole then
        object.getDemotableRole = function(role)
            if not object.metas.isModel(role, Config.MagicString.KeyStringRole) then
                print("Error: Invalid role object")
                return nil, 'Invalid role object'
            end

            local roleId = role.getId()
            if not object.demotableRoles[roleId] then
                print("Error: Role not found in demotable roles")
                return nil, 'Role not found in demotable roles'
            end

            if role.getSocietyId() ~= object.getSocietyId() then
                print("Error: Role does not belong to the same society")
                return nil, 'Role does not belong to the same society'
            end

            return role, 'Demotable role retrieved successfully'
        end
    end

    if not object.canDemotePlayer then
        object.canDemotePlayer = function(role, player, member)
            local isValid = object.getDemotableRole(role)
            if not isValid then
                print("Error: Role is not demotable")
                return false, 'Role is not demotable'
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

            local canDemote = object.getDemotableRole(member.getRole())
            if not canDemote then
                print("Error: Player cannot be demoted to this role")
                return false, 'Player cannot be demoted to this role'
            end

            return true
        end
    end

    if not object.demotePlayerRole then
        object.demotePlayerRole = function(role, player)
            local member = nil
            for _, v in pairs(object.getSociet().getMembers()) do
                if v.getPlayerId() == player.getId() then
                    member = v
                    break
                end
            end

            if not member then
                print("Error: Player is not a member of the society")
                return false, 'Player is not a member of the society'
            end

            local isValid, message = object.canDemotePlayer(role, player, member)
            if not isValid then
                return false, message
            end

            member.setRole(role)
            return true, 'Player demoted successfully'
        end
    end

    return object
end
