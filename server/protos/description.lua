function __LoadDescription(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.description = nil

    if not object.setDescription then
        object.setDescription = function(description) object.description = tostring(description) end
    end

    if not object.getDescription then
        object.getDescription = function() return object.description end
    end

    return object
end