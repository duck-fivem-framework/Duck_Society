function __LoadBalance(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.balance = 0.0

    if not object.getBalance then
        object.getBalance = function() return object.balance end
    end

    if not object.setBalance then
        object.setBalance = function(balance) object.balance = tonumber(balance) end
    end

    return object
end