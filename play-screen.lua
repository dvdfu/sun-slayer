Bump = require 'lib.bump'
Camera = require 'lib.camera'
Flux = require 'lib.flux'

PlayScreen = Class('PlayScreen')
Hydrant = require 'hydrant'
Sun = require 'sun'

function PlayScreen:initialize()
	cam = Camera:new()
	hydrant = Hydrant:new()
	cam:lookAt(hydrant.x, hydrant.y)
	sun1 = Sun:new()
end

function PlayScreen:update(dt)
	local cx, cy = cam:pos()
    local dx, dy = hydrant.x - cx, hydrant.y - cy
    dx, dy = dx/20, dy/20
    cam:move(dx, dy)

	hydrant:update(dt)
	sun1:update(dt)
end

function PlayScreen:draw()
	cam:draw(camDraw)
end

function camDraw()
	sun1:draw()
	hydrant:draw()
end

function PlayScreen:onClose()
end

return PlayScreen
