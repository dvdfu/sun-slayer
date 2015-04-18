Bump = require 'lib.bump'
Camera = require 'lib.camera'
Flux = require 'lib.flux'

PlayScreen = Class('PlayScreen')
Hydrant = require 'hydrant'

groundLevel = 400

function PlayScreen:initialize()
	hydrant = Hydrant:new()
	cam = Camera:new()
	cam:lookAt(hydrant.x, hydrant.y)
end

function PlayScreen:update(dt)
	local cx, cy = cam:pos()
    local dx, dy = hydrant.x - cx, hydrant.y - cy
    dx, dy = dx/2, dy/2
    cam:move(dx, dy)
    -- cam:rotateTo(-hydrant.angle)

	hydrant:update(dt)
end

function PlayScreen:draw()
	cam:draw(camDraw)
end

function camDraw()
	hydrant:draw()
end

function PlayScreen:onClose()
end

return PlayScreen
