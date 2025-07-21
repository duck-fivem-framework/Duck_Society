function __LoadPayedAt(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.payed_at = nil

    if not object.getPayedAt then
        object.getPayedAt = function() return object.payed_at end
    end

    if not object.setPayedAt then
        object.setPayedAt = function(payed_at) object.payed_at = payed_at end
    end

    return object
end