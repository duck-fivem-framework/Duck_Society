function __LoadIdentifier(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.identifier = nil

    if not object.setIdentifier then
        object.setIdentifier = function(identifier) object.identifier = tostring(identifier) end
    end

    if not object.getIdentifier then
        object.getIdentifier = function() return object.identifier end
    end

    return object
end