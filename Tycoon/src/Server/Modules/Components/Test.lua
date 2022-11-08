-- Test
-- Max <3#9999 https://sites.google.com/view/spys-portfolio
-- August 23, 2022



local Test = {}
Test.__index = Test

function Test.new(tycoon, instance)
    local self = setmetatable({}, Test)
    self.Tycoon = tycoon
    self.Instance = instance
    return self
end

function Test:Initt()
    self.Tycoon.CashPerSec+=1
end

return Test