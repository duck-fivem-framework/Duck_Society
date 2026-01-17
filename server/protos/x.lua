function __LoadX(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.x = nil

    if not object.getX then
        object.getX = function() return object.x end
    end

    if not object.setX then
        object.setX = function(x) object.x = x end
    end

    return object
end