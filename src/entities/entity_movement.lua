-- Movement vector class
-- This class is used to calculate the movement vector of the entities
-- It is used to calculate the speed and the direction of the entities
-- It is used by the ball and the player entities
--
-- local entityMovement = EntityMovement:new(coordinates)
--
local EntityMovement = { coordinates = { x = 0, y = 0 }, speed = 0, angle = 0 }


-- Constructor
function EntityMovement:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Set EntityMovement
function EntityMovement:setEntityMovement(coordinates)
    self.coordinates = coordinates
    self.speed = self:calculateSpeed()

    local dx = self.coordinates.x
    local dy = self.coordinates.y
    self.angle = math.atan2(dy, dx)
end

-- Calculate speed
function EntityMovement:calculateSpeed()
    local dx = self.coordinates.x
    local dy = self.coordinates.y
    return math.sqrt(dx * dx + dy * dy)
end

-- Calculate the movement of an entity:
-- This method returns the new position of the entity (its x and y coordinates)
-- once the entity has moved using the EntityMovement definition
-- The current location coordinate of the entity are the x and y in the entity object
-- The new location coordinate of the entity are the x and y returned by this method
-- The new location is calculated using the speed and the angle of the entityMovement

function EntityMovement:moveEntity(entity)
    local x = entity.x + self.speed * math.cos(self.angle)
    local y = entity.y + self.speed * math.sin(self.angle)
    -- Check if the entity has reached the bounderies of the screen (left & right)
    if (x > love.graphics.getWidth() or x < 0) then
        -- Reverse the x direction
        self.angle = -self.angle

        -- Calculate the new x and y coordinates
        x = entity.x + self.speed * math.cos(self.angle)

        -- Reverse the speed
        self.speed = -self.speed

        -- Calculate the new x and y coordinates
        y = entity.y + self.speed * math.sin(self.angle)
    end
    return x, y
end

function EntityMovement:bounceX()
    self.angle = -self.angle

end

return EntityMovement
