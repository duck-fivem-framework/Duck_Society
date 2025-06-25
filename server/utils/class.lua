function DuckClass(name)
    local self  = {}

    if type(name) ~= 'string' or name == '' then
        print("Error: Class name must be a non-empty string")
        return nil, 'Class name must be a non-empty string'
    end

    for k,v in pairs(Config.MagicString) do
        if v == name then
            self.__metas = { object = v }
            break
        end
    end

    if not self.__metas then
        print("Error: Invalid class name provided")
        return nil, 'Invalid class name provided'
    end

    if not self.__metas.object then
        print("Error: Class name does not match any known object type")
        return nil, 'Class name does not match any known object type'
    end

    if not self.__metas.object or type(self.__metas.object) ~= 'string' then
        print("Error: Invalid class metadata")
        return nil, 'Invalid class metadata'
    end

    self.__metas.isModel = __IsModel

    return self

end

function __IsModel(object, model)
    if type(object) ~= 'table' or not object.__metas or not object.__metas.object then
        return false, 'Invalid object provided for model verification'
    end

    local result = object.__metas.object == model
    if not result then
        print("Error: Object is not a valid model")
        return false, 'Object is not a valid model of type ' .. model
    end

    return true, 'Object is a valid model of type ' .. model
end