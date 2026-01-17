function __LoadId(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.id = nil

    if not object.setId then
        object.setId = function(id) object.id = tonumber(id) end
    end

    if not object.getId then
        object.getId = function() return object.id end
    end

    return object
end