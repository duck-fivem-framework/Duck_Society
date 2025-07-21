function __LoadUsage(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.usage = nil

    if not object.getUsage then
        object.getUsage = function() return object.usage end
    end

    if not object.setUsage then
        object.setUsage = function(usage) object.usage = usage end
    end

    return object
end