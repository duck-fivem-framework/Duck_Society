function __LoadIsDefault(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.isDefault = false

    if not object.getIsDefault then
        object.getIsDefault = function() return object.isDefault end
    end

    if not object.setIsDefault then
        object.setIsDefault = function(isDefault) object.isDefault = isDefault end
    end

    return object
end