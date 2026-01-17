function __LoadIban(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.iban = "No IBAN"

    if not object.getIban then
        object.getIban = function() return object.iban end
    end

    if not object.setIban then
        object.setIban = function(iban) object.iban = iban end
    end

    return object
end