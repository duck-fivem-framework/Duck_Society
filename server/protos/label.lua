function __LoadLabel(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.label = nil

    if not object.setLabel then
        object.setLabel = function(name) object.label = tostring(name) end
    end

    if not object.getLabel then
        object.getLabel = function() return object.label end
    end

    return object
end