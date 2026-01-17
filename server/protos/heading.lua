function __LoadHeading(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.heading = nil
    if not object.getHeading then
        object.getHeading = function() return object.heading end
    end

    if not object.setHeading then
        object.setHeading = function(heading) object.heading = heading end
    end

    return object
end