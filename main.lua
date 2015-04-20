Class = require 'lib.middleclass'
PlayScreen = require 'play-screen'
WinScreen = require 'win-screen'

screens = {}

function screens:enterScreen(screen)
	screenNum = screenNum + 1
	screens[screenNum] = screen
end

function screens:exitScreen()
	if screenNum > 1 then
		-- screens[screenNum]:onClose()
		screens[screenNum] = nil
		screenNum = screenNum - 1
	end
end

function screens:changeScreen(screen)
	screens:exitScreen()
	screens:enterScreen(screen)
end

function screens:setDefaultFont()
	love.graphics.setColor(255, 255, 255, 255)
end

function love.load()
	math.randomseed(os.time())
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(45, 45, 45)

	screenNum = 0
	screens:enterScreen(PlayScreen:new())
end

function love.update(dt)
	screens[screenNum]:update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
end

function love.draw()
	screens[screenNum]:draw()
end
