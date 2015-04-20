WinScreen = Class('WinScreen')

function WinScreen:initialize()
	love.graphics.setBackgroundColor(10, 0, 20)
	love.graphics.setColor(255, 255, 255, 255)

	font = love.graphics.newFont('data/red-alert.ttf', 26)
	bigFont = love.graphics.newFont('data/upheaval.ttf', 40)
	victory = love.graphics.newImage('img/victory.png')
end

function WinScreen:update(dt)
	function love.keypressed(key)
		if key == 'return' then
			screens:changeScreen(PlayScreen:new())
		end
	end
end

function WinScreen:draw()
	love.graphics.draw(victory, sw/2 - 24, sh/2 - 116)

	local title = 'CONGRATULATIONS'
	local subtitle = 'You discovered lunar water\nand stopped global warming\nand saved the world\nand destroyed the solar system'
	love.graphics.setFont(bigFont)
	love.graphics.print(title, sw/2 - bigFont:getWidth(title)/2, sh/2 - bigFont:getHeight()/2 - 12)
	love.graphics.setFont(font)
	love.graphics.print(subtitle, sw/2 - font:getWidth(subtitle)/2, sh/2 - font:getHeight()/2 + 18)
end

return WinScreen
