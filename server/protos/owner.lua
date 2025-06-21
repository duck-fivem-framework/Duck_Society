function __LoadOwner(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.owner_type = nil 
    object.owner_id = nil

    if not object.getOwnerType then
        object.getOwnerType = function() return object.owner_type end
    end

    if not object.setOwnerType then
        object.setOwnerType = function(owner_type) object.owner_type = owner_type end
    end

    if not object.setOwnerId then
        object.setOwnerId = function(owner_id) object.owner_id = tonumber(owner_id) end
    end

    if not object.getOwnerId then
        object.getOwnerId = function() return object.owner_id end
    end

    if not object.getOwner then
        object.getOwner = function()
            if not object.owner_type or not object.owner_id then
                print("Error: Owner type or ID is not set")
                return nil, 'Owner type or ID is not set'
            end

            if object.getOwnerType() == Config.MagicString.KeyStringPlayer then
                local player = Players[object.getOwnerId()]
                if player then
                    return player, 'Player retrieved successfully'
                else
                    print("Error: Player not found")
                    return nil, 'Player not found'
                end
            elseif object.getOwnerType() == Config.MagicString.KeyStringSociety then
                local society = Societies[object.getOwnerId()]
                if society then
                    return society, 'Society retrieved successfully'
                else
                    print("Error: Society not found")
                    return nil, 'Society not found'
                end
            else
                print("Error: Invalid owner type")
                return nil, 'Invalid owner type'
            end
        end
    end




    return object
end