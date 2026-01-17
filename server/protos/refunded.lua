function __LoadRefunded(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.refunded = false
    if not object.setRefunded then
        object.setRefunded = function(refunded) object.refunded = refunded end
    end

    if not object.getRefunded then
        object.getRefunded = function() return object.refunded end
    end

    return object
end