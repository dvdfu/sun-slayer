Timer = require 'lib.timer'
Fireball = require 'fireball'

Sun = Class('Sun')

function Sun:initialize()
	self.sprite = love.graphics.newImage('img/sun.png')
	self.x, self.y = 2500, -3000
	self.size = 160
	self.r = 1024
	self.hits = 0
	self.dead = false
	self.deadTimer = Timer.new()

	self.fireballs = {}
	self.fireballTimer = Timer.new()
	self.fireballReady = true

	self.fire = love.graphics.newParticleSystem(self.sprite, 500)
	self.fire:setParticleLifetime(0.1, 0.3)
	self.fire:setSpeed(10, 200)
	self.fire:setSpread(math.pi*2)
	self.fire:setColors(255, 255, 0, 255, 255, 128, 0, 255, 255, 0, 0, 0)
	self.fire:setEmissionRate(20)
	self.fire:setPosition(self.x, self.y)

	self.explosion = love.graphics.newParticleSystem(part, 5000)
	self.explosion:setParticleLifetime(0.1, 0.6)
	self.explosion:setSpeed(100, 700)
	self.explosion:setLinearAcceleration(0, 500, 0, 500)
	self.explosion:setSpread(math.pi*2)
	self.explosion:setColors(255, 255, 0, 255, 255, 128, 0, 255, 255, 0, 0, 255, 40, 40, 40, 255)
	self.explosion:setSizes(8, 0)

	self.trail = love.graphics.newParticleSystem(part, 5000)
	self.trail:setParticleLifetime(0.1, 0.6)
	self.trail:setSpeed(200, 400)
	self.trail:setSpread(math.pi/12)
	self.trail:setColors(255, 255, 0, 255, 255, 128, 0, 255, 255, 0, 0, 255, 40, 40, 40, 255)
	self.trail:setSizes(14, 2)

	local waterSpr = love.graphics.newImage('img/moon-trail.png')
	self.water = love.graphics.newParticleSystem(part, 5000)
	self.water:setParticleLifetime(0.5, 2)
	self.water:setSpeed(100, 700)
	self.water:setLinearAcceleration(0, 500, 0, 500)
	self.water:setSpread(math.pi*2)
	self.water:setColors(128, 255, 255, 255, 0, 128, 255, 255)
	self.water:setSizes(10, 1)

	self.explodeSound = love.audio.newSource("aud/explode2.wav")
end

function Sun:update(dt)
	self.fireballTimer.update(dt)
	self.deadTimer.update(dt)
	self.explosion:update(dt)
	self.trail:update(dt)
	self.fire:update(dt)
	self.water:update(dt)

	for i, fireball in pairs(self.fireballs) do
		fireball:update(dt)
		self.trail:setPosition(fireball.x, fireball.y)
		self.trail:setDirection(fireball.angle + math.pi)
		self.trail:emit(1)

		if fireball.dead then
			self.explodeSound:stop()
			self.explodeSound:play()
			table.remove(self.fireballs, i)
			self.explosion:setPosition(fireball.x, fireball.y)
			self.explosion:emit(300)
		end
	end

	local delta = Vector(self.x - moon.x, self.y - moon.y)
	if not self.dead and delta:len() < self.r/2 + moon.r/2 then
		self.dead = true
		moon.dead = true
		showSun = false
		self.water:setPosition(moon.x, moon.y)
		self.water:emit(500)
		self.explodeSound:stop()
		self.explodeSound:play()
	end
	if self.dead then
		if self.r > 6 then
			self.r = self.r * 0.96
		else
			self.r = 0
			if won == 0 then
				self.deadTimer.add(2, function()
					screens:changeScreen(WinScreen:new())
				end)
			end
			won = won + dt
		end
	end
	self.fire:setSizes(self.r/160, self.r/160*1.1)

	local dx, dy = self.x - hydrant.x, self.y - hydrant.y
	local dist = math.sqrt(dx*dx + dy*dy)

	if dist < self.r/2 + 16 and not hydrant.dead then
		hydrant:explode()

		if textKey == 'moon' then
			showText = true
			textComplete = true
			text = 'This isn\'t going to work...\nyou need MUCH more water!'
			textTimer.add(6, function()
				textComplete = false
				showText = false
			end)
		end
	end
	if dist < 1000 then
		if self.fireballReady and not self.dead then
			local fireball = Fireball:new(self.x, self.y, self.r/8)
			table.insert(self.fireballs, fireball)
			self.fireballReady = false
			self.fireballTimer.add(3, function()
				self.fireballReady = true
			end)
		end
	end

	if self.hits > 80 and textKey == 'water' then
		showText = true
		textComplete = true
		text = 'Keep shooting, it\'s working!\n...I think!?'
		textTimer.add(4, function()
			textKey = 'confused'
			textComplete = false
			showText = false
		end)
	end

	if self.hits > 120 and textKey == 'confused' then
		showText = true
		textComplete = true
		text = 'This isn\'t going to work...\nyou need MUCH more water!'
		textKey = 'moon'
		textTimer.add(6, function()
			textComplete = false
			showText = false
		end)
	end
end

function Sun:draw()
	love.graphics.setBlendMode('additive')
	love.graphics.draw(self.trail)
	love.graphics.setBlendMode('alpha')

	love.graphics.draw(self.water)
	
	for _, fireball in pairs(self.fireballs) do
		fireball:draw()
	end

	love.graphics.draw(self.sprite, self.x, self.y, 0, self.r/self.size, self.r/self.size, self.size/2, self.size/2)
	love.graphics.setBlendMode('additive')
	love.graphics.draw(self.fire)
	love.graphics.draw(self.explosion)
	love.graphics.setBlendMode('alpha')
end

return Sun
