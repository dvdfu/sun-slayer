Vector = require 'lib.vector'

Fireball = Class('Fireball')

Fireball.static.size = 60

function Fireball:initialize(x, y, radius)
	self.sprite = love.graphics.newImage('img/fireball.png')
	self.x, self.y = x, y
	self.vx, self.vy = 0, 0
	self.r = 120
	self.speed = self.r/8
	self.hp = 3
	self.hit = false
	self.dead = false
	self.angle = 0
end

function Fireball:update(dt)
	self.hit = false

	if self.speed > 3 then
		self.speed = self.speed - 0.3
	end

	if not hydrant.dead then
		local delta = Vector(hydrant.x - self.x, hydrant.y - self.y)
		self.angle = math.atan2(delta.y, delta.x)
		if delta:len() < self.r/2 + 16 then
			hydrant:explode()
			self.dead = true

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
		delta = delta:normalized() * self.speed
		self.vx, self.vy = delta:unpack()
	end

	local delta = Vector(moon.x - self.x, moon.y - self.y)
	if delta:len() < moon.r/2 + self.r/2 then
		self.dead = true
	end

	if self.y + self.r/2 > 0 then
		self.dead = true
	end

	self.x, self.y = self.x + self.vx, self.y + self.vy
end

function Fireball:draw()
	if not self.hit then
		love.graphics.draw(self.sprite, self.x, self.y, 0,
			self.r/Fireball.static.size, self.r/Fireball.static.size, Fireball.static.size/2, Fireball.static.size/2)
	end
end

return Fireball
