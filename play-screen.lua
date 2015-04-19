Bump = require 'lib.bump'
Camera = require 'lib.camera'
Flux = require 'lib.flux'

PlayScreen = Class('PlayScreen')
Hydrant = require 'hydrant'
Sun = require 'sun'

sw, sh = love.graphics.getWidth(), love.graphics.getHeight()

function PlayScreen:initialize()
	cam = Camera:new()
	hydrant = Hydrant:new()
	cam:lookAt(hydrant.x, hydrant.y)
	sun = Sun:new()

	warningSpr = love.graphics.newImage('img/warning.png')
	indicatorSpr = love.graphics.newImage('img/indicator.png')
end

function PlayScreen:update(dt)
	local cx, cy = cam:pos()
    local dx, dy = hydrant.x - cx, hydrant.y - cy
    dx, dy = dx/10, dy/10
    cam:move(dx, dy)

    local height = -(hydrant.y + hydrant.h)
    local ds = 1/(1 + height/600) - cam.scale
    cam.scale = cam.scale + ds/10
    if height < 1000 then
		love.graphics.setBackgroundColor(45 - 45*height/1000, 70 - 70*height/1000, 100 - 100*height/1000)
	else
		love.graphics.setBackgroundColor(0, 0, 0)
	end

	hydrant:update(dt)
	sun:update(dt)
end

function PlayScreen:draw()
	cam:draw(camDraw)

	love.graphics.setColor(128, 255, 255)
	love.graphics.rectangle('fill', 16, 16, 100*hydrant.water/hydrant.waterMax, 8)
	love.graphics.rectangle('line', 16, 16, 100, 8)
	love.graphics.setColor(255, 255, 255)

	local dx, dy = hydrant.x - sun.x, hydrant.y - sun.y
	local dist = math.sqrt(dx*dx + dy*dy) - sun.r
	if dist > 300 then
		local angle = math.atan2(dy, dx)
		love.graphics.draw(indicatorSpr, sw/2 - 160*math.cos(angle), sh/2 - 160*math.sin(angle), angle - math.pi/2, 1, 1, 8, 8)
	end
end

function camDraw()
	hydrant:draw()
	sun:draw()

	love.graphics.rectangle('fill', -1000, 0, 2000, 800)
	for i = 0, 16 do
		love.graphics.draw(warningSpr, (i - 8)*8 - 4, 0)
	end
end

function PlayScreen:onClose()
end

return PlayScreen
