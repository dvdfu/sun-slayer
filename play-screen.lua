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
	starSpr = love.graphics.newImage('img/stars.png')
	soilSpr = love.graphics.newImage('img/soil.png')
end

function PlayScreen:update(dt)
	local cx, cy = cam:pos()
    local dx, dy = hydrant.x - cx, hydrant.y - cy
    dx, dy = dx/10, dy/10
    cam:move(dx, dy)

    local height = -cam.y
    local ds = 1/(1 + height/1500) - cam.scale
    cam.scale = cam.scale + ds/10
    if height < 1500 then
		love.graphics.setBackgroundColor(45 - 45*height/1500, 80 - 80*height/1500, 120 - 120*height/1500)
	else
		love.graphics.setBackgroundColor(0, 0, 0)
	end

	hydrant:update(dt)
	sun:update(dt)
	moon:update(dt)
end

function PlayScreen:draw()
	local height = -cam.y
	if height < 1500 then
		love.graphics.setColor(255, 255, 255, height*255/1500)
	end
	love.graphics.draw(starSpr, -cam.x/100, -cam.y/100, 0, 2, 2)
	love.graphics.setColor(255, 255, 255, 255)

	cam:draw(camDraw)

	love.graphics.print(hydrant.water, 16, 8)
	love.graphics.print('gal', 70, 8)

	love.graphics.setColor(128, 255, 255)
	love.graphics.rectangle('fill', 108, 18, 100*hydrant.water/hydrant.waterMax, 10)
	love.graphics.rectangle('line', 108, 18, 100, 10)
	love.graphics.setColor(255, 255, 255)

	local dx, dy = hydrant.x - sun.x, hydrant.y - sun.y
	local dist = math.sqrt(dx*dx + dy*dy) - sun.r
	if dist > 200 then
		local angle = math.atan2(dy, dx)
		love.graphics.draw(indicatorSpr, sw/2 - 160*math.cos(angle), sh/2 - 160*math.sin(angle), angle - math.pi/2, 1, 1, 8, 8)
	end

	local text = 'ayy lmao'
	love.graphics.print(text, sw/2 - font:getWidth(text)/2, sh - 100)
end

function camDraw()
	hydrant:draw()
	moon:draw()
	sun:draw()

	-- love.graphics.rectangle('fill', -1000, 0, 2000, 800)
	for i = -2000, 2000, 32 do
		love.graphics.draw(soilSpr, i, 0, 0, 2, 2)
	end
	for i = -96, 96, 16 do
		love.graphics.draw(warningSpr,i - 8, 0, 0, 2, 2)
	end
end

function PlayScreen:onClose()
end

return PlayScreen
