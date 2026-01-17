function __LoadBankNotification(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.bankNotification = false

    if not object.getBankNotification then
        object.getBankNotification = function() return object.bankNotification end
    end

    if not object.setBankNotification then
        object.setBankNotification = function(bankNotification) object.bankNotification = bankNotification end
    end

    return object
end