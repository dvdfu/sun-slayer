Bump = require 'lib.bump'
Camera = require 'lib.camera'
Flux = require 'lib.flux'

PlayScreen = Class('PlayScreen')
Hydrant = require 'hydrant'
Sun = require 'sun'
Moon = require 'moon'

sw, sh = love.graphics.getWidth(), love.graphics.getHeight()

function PlayScreen:initialize()
	part = love.graphics.newImage('img/part.png')
	font = love.graphics.newFont('data/red-alert.ttf', 26)
	love.graphics.setFont(font)

	cam = Camera:new()
	hydrant = Hydrant:new()
	cam:lookAt(hydrant.x, hydrant.y)
	sun = Sun:new()
	moon = Moon:new()

	warningSpr = love.graphics.newImage('img/warning.png')
	indicatorSpr = love.graphics.newImage('img/indicator.png')
end

function PlayScreen:update(dt)
	local cx, cy = cam:pos()
    local dx, dy = hydrant.x - cx, hydrant.y - cy
    dx, dy = dx/10, dy/10
    cam:move(dx, dy)

    local height = -(hydrant.y + hydrant.h)
    local ds = 1/(1 + height/1000) - cam.scale
    cam.scale = cam.scale + ds/10
    if height < 1000 then
		love.graphics.setBackgroundColor(45 - 45*height/1000, 70 - 70*height/1000, 100 - 100*height/1000)
	else
		love.graphics.setBackgroundColor(0, 0, 0)
	end

	hydrant:update(dt)
	sun:update(dt)
	moon:update(dt)
end

function PlayScreen:draw()
	cam:draw(camDraw)

	love.graphics.print(hydrant.water, 16, 8)
	love.graphics.print('gal', 70, 8)

	love.graphics.setColor(128, 255, 255)
	love.graphics.rectangle('fill', 108, 18, 100*hydrant.water/hydrant.waterMax, 10)
	love.graphics.rectangle('line', 108, 18, 100, 10)
	love.graphics.setColor(255, 255, 255)

	local dx, dy = hydrant.x - sun.x, hydrant.y - sun.y
	local dist = math.sqrt(dx*dx + dy*dy) - sun.r
	if dist > 300 then
		local angle = math.atan2(dy, dx)
		love.graphics.draw(indicatorSpr, sw/2 - 160*math.cos(angle), sh/2 - 160*math.sin(angle), angle - math.pi/2, 1, 1, 8, 8)
	end

	-- local height = -(hydrant.y + hydrant.h/2)
	-- height = height*height*height/92
	-- if height < 1000 then
	-- 	love.graphics.print(string.format('Altitude %i km', height), 16, 32)
	-- elseif height < 1000000 then
	-- 	love.graphics.print(string.format('Altitude %i thousand km', height/1000), 16, 32)
	-- else
	-- 	love.graphics.print(string.format('Altitude %i million km', height/1000000), 16, 32)
	-- end
end

function camDraw()
	hydrant:draw()
	moon:draw()
	sun:draw()

	love.graphics.rectangle('fill', -1000, 0, 2000, 800)
	for i = 0, 16 do
		love.graphics.draw(warningSpr, (i - 8)*8 - 4, 0)
	end
end

function PlayScreen:onClose()
end

return PlayScreen
