function __LoadSociety(object)
    if not object or type(object) ~= 'table' then
        return object
    end

    object.societyId = nil

    if not object.getSocietyId then
        object.getSocietyId = function() return object.societyId end
    end

    if not object.setSocietyId then
        object.setSocietyId = function(societyId) object.societyId = tonumber(societyId) end
    end

    if not object.getSociety then
        object.getSociety = function()
            if not object.societyId then
                print("Error: Society ID is not set")
                return nil, 'Society ID is not set'
            end
            local society = Societies[object.societyId]
            if society then
                return society, 'Society retrieved successfully'
            end
            print("Error: Society not found")
            return nil, 'Society not found'
        end
    end

    if not object.setSociety then
        object.setSociety = function(society)
            if type(society) ~= 'table' or not society.__metas or society.__metas.object ~= Config.MagicString.KeyStringSociety then
                print("Error: Invalid society object")
                return false, 'Invalid society object'
            end

            object.setSocietyId(society.getId())
            return true, 'Society set successfully'
        end
    end


    return object
end