function __LoadIdentity(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.identityId = nil

    if not object.getIdentityId then
        object.getIdentityId = function() return object.identityId end
    end

    if not object.setIdentityId then
        object.setIdentityId = function(identityId) object.identityId = tonumber(identityId) end
    end

    if not object.getIdentity then
        object.getIdentity = function()
            if not object.identityId then
                print("Error: Identity ID is not set")
                return nil, 'Identity ID is not set'
            end
            local identity = Identities[object.identityId]
            if identity then
                return identity, 'Identity retrieved successfully'
            end
            print("Error: Identity not found")
            return nil, 'Identity not found'
        end
    end

    if not object.setIdentity then
        object.setIdentity = function(identity)
            if type(identity) ~= 'table' or not identity.__metas or identity.__metas.object ~= Config.MagicString.KeyStringIdentity then
                print("Error: Invalid identity object")
                return false, 'Invalid identity object'
            end

            object.setIdentityId(identity.getId())
            return true, 'Identity set successfully'
        end
    end
    
    return object
end