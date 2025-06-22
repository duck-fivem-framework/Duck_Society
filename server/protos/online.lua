function __LoadOnline(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.online = false

    if not object.setOnline then
        object.setOnline = function(online) object.online = online end
    end

    if not object.getOnline then
        object.getOnline = function() return object.online end
    end

    if not object.isOnline then
        object.isOnline = function() return object.online end
    end

    return object
end