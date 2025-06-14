function DuckSociety()
  local self = {}

  self.id = nil
  self.setId = function(id) self.id = tonumber(id) end
  self.getId = function() return self.id end
  
  self.name = ""
  self.setName = function(name) self.name = string.lower(name) end
  self.getName = function() return self.name end
  
  self.label = ""
  self.setLabel = function(label) self.label = label end
  self.getLabel = function() return self.label end

  self.generateEventHandler = function()
    RegisterNetEvent('duck:society:' .. self.getName() .. ':test')
    AddEventHandler('duck:society:' .. self.getName() .. ':test', function()
      print('duck:society:' .. self.getName() .. ':test')
    end)
  end
  
  return self
end
