function DuckLocation()
    local self = DuckClass(Config.MagicString.KeyStringLocation)

    self = __LoadId(self)
    self = __LoadName(self)
    self = __LoadX(self)
    self = __LoadY(self)
    self = __LoadZ(self)
    self = __LoadHeading(self)
    

    return self
end