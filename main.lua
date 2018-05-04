-- quick port of the Bunnymark test from https://github.com/pixijs/bunny-mark/tree/master/src
-- Click or touch to add bunnies.

local random = math.random
local _bunnyTex = Texture.new("bunny.png") -- bunny texture
local bunnies = {}                         -- table holding bunnies
local nBunnies = 0                         -- number of bunnies
local isAdding = false                     -- flag, indicates if bunnies should be added
WIN_WIDTH @ 1440
WIN_HEIGHT @ 2560
ADD_PER_FRAME @ 500                        -- number of bunnies to be added per frame               


application:setLogicalDimensions(WIN_WIDTH,WIN_HEIGHT)

local function mouseDown() isAdding = true end
local function mouseUp() isAdding = false end

stage:addEventListener(Event.MOUSE_DOWN, mouseDown)
stage:addEventListener(Event.MOUSE_UP, mouseUp)


local bunny_text = TextField.new(nil, "Bunnies: 0")
bunny_text:setScale(2)
bunny_text:setTextColor(0xFF00FF)
bunny_text:setPosition(20,30)
local fps_text = TextField.new(nil, "0")
fps_text:setScale(2)
fps_text:setTextColor(0xFF00FF)
fps_text:setPosition(20,55)
local bg_area = Pixel.new(0xFFFFFF, 0.8, 260, 70)


bunny_particles=Particles.new()
bunny_particles:setTexture(_bunnyTex)
 
 stage:addChild(bunny_particles)
 
local function update(ev)
	local dt = ev.deltaTime
	
	if isAdding then
		for i = 1,ADD_PER_FRAME do
		 local index=bunny_particles:addParticles(1,1,30,0,0)
		 bunny_particles:setParticleSpeed(index,random() * 10,random() * 10-5)
		end
		nBunnies = nBunnies + ADD_PER_FRAME
		bunny_text:setText("Bunnies: "..nBunnies)
	end
	-- update all bunny positions
	for i=1,nBunnies do
		local x,y=bunny_particles:getParticlePosition(i)
		local sx,sy= bunny_particles:getParticleSpeed(i)
		if (x > WIN_WIDTH) then
			bunny_particles:setParticleSpeed(i,-sx,sy)
			bunny_particles:setParticlePosition(i,WIN_WIDTH,y)		
		elseif (x < 0) then
			bunny_particles:setParticleSpeed(i,-sx,sy)
			bunny_particles:setParticlePosition(i,0,y)		
		end
		
		if (y > WIN_HEIGHT) then
			sy = sy* -0.85
			if (random() > 0.05) then
				sy = sy - random() * 6
			end
			bunny_particles:setParticleSpeed(i,sx,sy)
			bunny_particles:setParticlePosition(i,x,WIN_HEIGHT)					
		elseif (y < 0) then
			bunny_particles:setParticleSpeed(i,sx,-sy)
			bunny_particles:setParticlePosition(i,x,0)					
		end

	end
	
	local fps = 1/dt
	fps_text:setText("FPS: "..fps)
	stage:addChild(bg_area)
	stage:addChild(fps_text)
	stage:addChild(bunny_text)

end
stage:addEventListener(Event.ENTER_FRAME, update)


