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


    return self

end