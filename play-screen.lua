Bump = require 'lib.bump'
Flux = require 'lib.flux'
Hydrant = require 'hydrant'

PlayScreen = Class('PlayScreen')

groundLevel = 400

function PlayScreen:initialize()
	hydrant = Hydrant:new()
end

function PlayScreen:update(dt)
	hydrant:update(dt)
end

function PlayScreen:draw()
	hydrant:draw()
end

function PlayScreen:onClose()
end

return PlayScreen
