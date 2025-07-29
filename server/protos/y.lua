function __LoadY(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.y = nil

    if not object.getY then
        object.getY = function() return object.y end
    end

    if not object.setY then
        object.setY = function(y) object.y = y end
    end

    return object
end