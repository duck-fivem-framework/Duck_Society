function __LoadPlayer(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.playerId = nil

    if not object.getPlayerId then
        object.getPlayerId = function() return object.playerId end
    end

    if not object.setPlayerId then
        object.setPlayerId = function(playerId) object.playerId = tonumber(playerId) end
    end

    if not object.getPlayer then
        object.getPlayer = function()
            if not object.playerId then
                print("Error: player ID is not set")
                return nil, 'player ID is not set'
            end
            local player = Players[object.playerId]
            if player then
                return player, 'player retrieved successfully'
            end
            print("Error: player not found")
            return nil, 'player not found'
        end
    end

    if not object.setPlayer then
        object.setPlayer = function(player)
            if type(player) ~= 'table' or not player.__metas or player.__metas.object ~= Config.MagicString.KeyStringPlayers then
                print("Error: Invalid player object")
                return false, 'Invalid player object'
            end

            object.setPlayerId(player.getId())
            return true, 'player set successfully'
        end
    end


    return object
end