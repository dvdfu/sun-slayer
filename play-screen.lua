Camera = require 'lib.camera'
Timer = require 'lib.timer'

PlayScreen = Class('PlayScreen')
Hydrant = require 'hydrant'
Sun = require 'sun'
Moon = require 'moon'

sw, sh = love.graphics.getWidth(), love.graphics.getHeight()

function PlayScreen:initialize()
	part = love.graphics.newImage('img/part.png')
	font = love.graphics.newFont('data/red-alert.ttf', 26)
	bigFont = love.graphics.newFont('data/upheaval.ttf', 40)
	love.graphics.setFont(font)
	text = 'Hold UP to liftoff'
	textKey = 'lift'
	textTimer = Timer.new()
	textComplete = false
	showSun = false
	showMenu = true
	won = 0

	showText = true

	cam = Camera:new()
	hydrant = Hydrant:new()
	sun = Sun:new()
	moon = Moon:new()
	cam:lookAt(sun.x, sun.y)

	warningSpr = love.graphics.newImage('img/warning.png')
	indicatorSpr = love.graphics.newImage('img/indicator.png')
	starSpr = love.graphics.newImage('img/stars.png')
	soilSpr = love.graphics.newImage('img/soil.png')
	cloudSpr = love.graphics.newImage('img/cloud.png')
end

function PlayScreen:update(dt)
	textTimer.update(dt)

	if showMenu then
		function love.keypressed(key)
			if key == 'return' then
				if showMenu then
					showMenu = false
				else
					screens:changeScreen(PlayScreen:new())
				end
			end
		end
	else
		local cx, cy = cam:pos()
	    local dx, dy = hydrant.x - cx, hydrant.y - cy
	    dx, dy = dx/10, dy/10
	    cam:move(dx, dy)
	    cam.y = math.min(cam.y, -96)
	end

    local height = -96 - cam.y
    local ds = 1/(1 + height/1200) - cam.scale
    cam.scale = cam.scale + ds/10
    if height < 1200 then
		love.graphics.setBackgroundColor(45 - 35*height/1200, 80 - 80*height/1200, 120 - 100*height/1200)
	else
		love.graphics.setBackgroundColor(10, 0, 20)
	end

	if not showMenu then
		hydrant:update(dt)
	end
	sun:update(dt)
	moon:update(dt)

	if not textComplete and textKey == 'lift' and love.keyboard.isDown('up') and not showMenu then
		textComplete = true
		textTimer.add(2, function()
			textComplete = false
			text = 'Hold LEFT and RIGHT to steer'
			textKey = 'steer'
		end)
	end
	if not textComplete and textKey == 'steer' and (love.keyboard.isDown('left') or love.keyboard.isDown('right')) then
		textComplete = true
		textTimer.add(3, function()
			textComplete = false
			text = 'Hold A to blast water'
			textKey = 'shoot'
		end)
	end
	if not textComplete and textKey == 'shoot' and love.keyboard.isDown('a') then
		textComplete = true
		textTimer.add(3, function()
			text = 'Remember to refill your water tank\nby landing on Earth (gently).'
			textKey = 'water'
			textTimer.add(4, function()
				text = 'Use your water to\nEXTINGUISH THE SUN!!'
				showSun = true
				textTimer.add(4, function()
					showText = false
				end)
			end)
		end)
	end
end

function PlayScreen:draw()
	local height = -96 - cam.y
	if height < 1500 then
		love.graphics.setColor(255, 255, 255, height*255/1500)
	end
	love.graphics.draw(starSpr, -cam.x/50, -cam.y/50, 0, 2, 2)
	love.graphics.setColor(255, 255, 255, 255)

	cam:draw(camDraw)

	if not showMenu then
		love.graphics.print(hydrant.water, 16, 8)
		love.graphics.print('gal', 70, 8)

		love.graphics.setColor(128, 255, 255)
		love.graphics.rectangle('fill', 108, 18, 100*hydrant.water/hydrant.waterMax, 10)
		love.graphics.rectangle('line', 108, 18, 100, 10)
		love.graphics.setColor(255, 255, 255)
	else
		local title = 'SUN SLAYER'
		local subtitle = 'Press ENTER to start'
		love.graphics.setColor(10, 0, 20)
		love.graphics.setFont(bigFont)
		love.graphics.print(title, sw/2 - bigFont:getWidth(title)/2, sh/2 - bigFont:getHeight()/2 - 12)
		love.graphics.setFont(font)
		love.graphics.print(subtitle, sw/2 - font:getWidth(subtitle)/2, sh/2 - font:getHeight()/2 + 12)
		love.graphics.setColor(255, 255, 255)
	end

	if won == 0 then
		if textKey == 'moon' then
			local dx, dy = hydrant.x - moon.x, hydrant.y - moon.y
			local dist = math.sqrt(dx*dx + dy*dy) - moon.r
			if dist > 200 then
				local angle = math.atan2(dy, dx)
				love.graphics.setColor(0, 255, 255)
				love.graphics.draw(indicatorSpr, sw/2 - 160*math.cos(angle), sh/2 - 160*math.sin(angle), angle - math.pi/2, 1, 1, 8, 8)
			end
		end
		local dx, dy = hydrant.x - sun.x, hydrant.y - sun.y
		local dist = math.sqrt(dx*dx + dy*dy) - sun.r
		if showSun and dist > 200 then
			local angle = math.atan2(dy, dx)
			love.graphics.setColor(255, 255, 0)
			love.graphics.draw(indicatorSpr, sw/2 - 160*math.cos(angle), sh/2 - 160*math.sin(angle), angle - math.pi/2, 1, 1, 8, 8)
		end
		love.graphics.setColor(255, 255, 255)
	end

	if showText and not showMenu then
		love.graphics.setColor(0, 0, 0, 192)
		local textw, texth = 384, 64
		love.graphics.rectangle('fill', (sw - textw)/2, sh - texth - 16, textw, texth)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(text, sw/2 - font:getWidth(text)/2, sh - texth - font:getHeight()/2)
	end

	if won > 0 then
		local alpha = 255*math.min(1, won/2)
		love.graphics.setColor(10, 0, 20, alpha)
		love.graphics.rectangle('fill', 0, 0, sw, sh)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function camDraw()
	local left = cam.x - sw/2/cam.scale
	love.graphics.draw(cloudSpr, math.floor(left/1200)*1200 + 900, -220, 0, 2, 2)

	hydrant:draw()
	moon:draw()
	sun:draw()

	left = math.floor(cam.x/32)*32 - sw/2 - 256
	for i = left, left + sw + 512, 32 do
		love.graphics.draw(soilSpr, i, 0, 0, 2, 2)
	end

	for i = -96, 96, 16 do
		love.graphics.draw(warningSpr,i - 8, 0, 0, 2, 2)
	end
end

return PlayScreen
