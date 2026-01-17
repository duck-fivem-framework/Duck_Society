function __LoadSource(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.source = nil

    if not object.setSource then
        object.setSource = function(source) object.source = tonumber(source) end
    end

    if not object.getSource then
        object.getSource = function() return object.source end
    end

    return object
end