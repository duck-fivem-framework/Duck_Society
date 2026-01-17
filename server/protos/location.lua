function __LoadLocation(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.location = nil

    if not object.getLocation then
        object.getLocation = function() return object.location end
    end

    if not object.setLocation then
        object.setLocation = function(location) object.location = location end
    end

    return object
end