function __LoadZ(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.z = nil

    if not object.getZ then
        object.getZ = function() return object.z end
    end

    if not object.setZ then
        object.setZ = function(z) object.z = z end
    end

    return object
end