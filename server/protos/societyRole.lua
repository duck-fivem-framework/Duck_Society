function __LoadSocietyRole(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.societyRoleId = nil

                  
    if not object.getSocietyRoleId then
        object.getSocietyRoleId = function() return object.societyRoleId end
    end

    if not object.setSocietyRoleId then
        object.setSocietyRoleId = function(societyRoleId) object.societyRoleId = tonumber(societyRoleId) end
    end

    if not object.getSocietyRole then
        object.getSocietyRole = function()
            if not object.societyRoleId then
                print("Error: Society ID is not set")
                return nil, 'Society ID is not set'
            end
            local societyRole = SocietyRoles[object.societyRoleId]
            if societyRole then
                return societyRole, 'Society role retrieved successfully'
            end
            print("Error: Society role not found")
            return nil, 'Society role not found'
        end
    end

    if not object.setSocietyRole then
        object.setSocietyRole = function(societyRole)
            if type(societyRole) ~= 'table' or not societyRole.__metas or societyRole.__metas.object ~= Config.MagicString.KeyStringSocietyRoles then
                print("Error: Invalid society role object")
                return false, 'Invalid society role object'
            end

            object.setSocietyRoleId(societyRole.getId())
            return true, 'Society role set successfully'
        end
    end


    return object
end