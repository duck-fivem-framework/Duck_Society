function __LoadTarget(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.target_type = nil
    object.target_id = nil

    if not object.getTargetType then
        object.getTargetType = function() return object.target_type end
    end

    if not object.setTargetType then
        object.setTargetType = function(target_type) object.target_type = target_type end
    end

    if not object.setTargetId then
        object.setTargetId = function(target_id) object.target_id = tonumber(target_id) end
    end

    if not object.getTargetId then
        object.getTargetId = function() return object.target_id end
    end

    if not object.getTarget then
        object.getTarget = function()
            if not object.target_type or not object.target_id then
                print("Error: Target type or ID is not set")
                return nil, 'Target type or ID is not set'
            end

            if object.getTargetType() == Config.MagicString.KeyStringPlayer then
                local player = Players[object.getTargetId()]
                if player then
                    return player, 'Player retrieved successfully'
                else
                    print("Error: Player not found")
                    return nil, 'Player not found'
                end
            elseif object.getTargetType() == Config.MagicString.KeyStringSociety then
                local society = Societies[object.getTargetId()]
                if society then
                    return society, 'Society retrieved successfully'
                else
                    print("Error: Society not found")
                    return nil, 'Society not found'
                end
            elseif object.getTargetType() == Config.MagicString.KeyStringAccount then
                local account = Accounts[object.getTargetId()]
                if account then
                    return account, 'Account retrieved successfully'
                else
                    print("Error: Account not found")
                    return nil, 'Account not found'
                end
            else
                print("Error: Invalid target type")
                return nil, 'Invalid target type'
            end
        end
    end




    return object
end