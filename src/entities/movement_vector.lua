-- Movement vector class
-- This class is used to calculate the movement vector of the entities
-- It is used to calculate the speed and the direction of the entities
-- It is used by the ball and the player entities
--
-- This class assumes that the initial and endpoint are x,y coordinates
-- local initialPoint = {x = 0, y = 0}
-- local endPoint = { x = 10, y = 10 }
-- local entityMovement = EntityMovement:new(initialPoint, endPoint)
--
EntityMovement = {}
EntityMovement.__index = EntityMovement

-- Constructor
function EntityMovement:new(initial_point, end_point)
    local self = setmetatable({}, EntityMovement)
    self.setEntityMovement(initial_point, end_point)
    return self
end

-- Set EntityMovement
function EntityMovement:setEntityMovement(initial_point, end_point)
    self.initial_point = initial_point
    self.end_point = end_point
    self.speed = self:calculateSpeed()

    local dx = self.end_point.x - self.initial_point.x
    local dy = self.end_point.y - self.initial_point.y
    self.angle = math.atan2(dy, dx)
end

-- Calculate speed
function EntityMovement:calculateSpeed()
    local dx = self.endPoint.x - self.initialPoint.x
    local dy = self.endPoint.y - self.initialPoint.y
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
    -- Check if the entity has reached the bounderies of the screen
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
    if (y > love.graphics.getHeight() or y < 0) then
        -- Reverse the y direction
        self.angle = -self.angle

        -- Calculate the new x and y coordinates
        y = entity.y + self.speed * math.sin(self.angle)

        -- Reverse the speed
        self.speed = -self.speed

        -- Calculate the new x and y coordinates
        x = entity.x + self.speed * math.cos(self.angle)
    end
    return x, y
end
