function __LoadName(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.name = nil

    if not object.setName then
        object.setName = function(name) object.name = tostring(name) end
    end

    if not object.getName then
        object.getName = function() return object.name end
    end

    return object
end