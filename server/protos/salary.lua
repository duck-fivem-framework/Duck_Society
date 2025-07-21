function __LoadSalary(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.salary = 0.0

    if not object.getSalary then
        object.getSalary = function() return object.salary end
    end

    if not object.setSalary then
        object.setSalary = function(salary) object.salary = tonumber(salary) end
    end

    return object
end