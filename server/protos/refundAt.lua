function __LoadRefundedAt(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.refunded_at = nil

    if not object.getRefundedAt then
        object.getRefundedAt = function() return object.refunded_at end
    end

    if not object.setRefundedAt then
        object.setRefundedAt = function(refunded_at) object.refunded_at = refunded_at end
    end

    return object
end