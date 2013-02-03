widget = require "widget"

physics = require "physics"
physics:start()
physics.setDrawMode("regular")

display.setStatusBar(display.HiddenStatusBar)

local screen
local playbtn
local helpbtn
local backbtn
local title
local texting
local boxxy
local countFrame = 0
local countSec = 0
local totalScore = 0

--Vedaad's variables
local platforms = {}
local iEnd = 5
local enemies = {}
local eEnd = 0
local txt1 = display.newText( "", 70, 50 )
local txt2 = display.newText( "", 70, 65 )
local txt3 = display.newText( "", 70, 80 )
local txt4 = display.newText( "", 70, 95 )
txt1:setReferencePoint(display.CenterLeftReferencePoint)
txt2:setReferencePoint(display.CenterLeftReferencePoint)
txt3:setReferencePoint(display.CenterLeftReferencePoint)
txt4:setReferencePoint(display.CenterLeftReferencePoint)
local hearts = {}
local lenHearts
local damage = true
local explosions = {}
local exBeg = 0
local modee

--Tierno's Variables
local screenObjects = display.newGroup()

--Misha's Variables
local galaxies = {}
local r
local everything = display.newGroup()


function main()
  screen = display.newImage("backgroundMenu.png", 0, 0, true)
	playbtn = display.newImage("buttonMenu.png",display.contentWidth/2 - 130, 70)
	playbtn:scale( .7, .7 )
	playbtn:setReferencePoint(display.CenterReferencePoint)
	helpbtn = display.newImage("buttonMenu.png",display.contentWidth/2 - 130, display.contentHeight/2+20)
	helpbtn:scale( .7, .7 )
	helpbtn:setReferencePoint(display.CenterReferencePoint)
	title = display.newImage("title.png", 100, 1)
	transition.to(backbtn,{alpha=0,time=0})
	playbtn:addEventListener("tap", modes)
	helpbtn:addEventListener("tap", helpscrn)
end

function helpscrn(event)
	transition.to(helpbtn, {time=0, alpha=0})
	helpbtn:removeEventListener("tap",helpscrn)
	transition.to(playbtn, {time=0, alpha=0})
	playbtn:removeEventListener("tap",play)
	transition.to(title, {time=0, alpha=0})
	scrollView = widget.newScrollView {
		scrollWidth = 100,
		scrollHeight = 400,
		hideScrollBar = false
	}
	texting = display.newText("Welcome to Alien Escape! \n\nThis game is straightforward. \n\nYou will jump from platform to platform using a tap on the screen to jump. \n\nIf you go beyond the borders, or fail a jump, you die and restart. \nIn addition there are also enemies. \nIf you jump on them, you kill them, if you touch then without jumping on top of them, you die. \n\nThe point is to get a far as possible. \n\nGood Luck!",10,0, 300, 0)
	texting:setTextColor(0,0,0)
	scrollView:insert( texting )
	backbtn=display.newImage("buttonMenu.png",display.contentWidth/2+20, display.contentHeight/2)
	backbtn:scale( .7, .7 )
	backbtn:addEventListener("tap",back)
end

function back()
	backbtn:removeSelf()
	backbtn = nil
	texting:removeSelf()
	texting = nil
	scrollView:removeSelf()
	scrollView = nil
	main()
end
function modes(event)
	playbtn:removeSelf()
	helpbtn:removeSelf()

	easy = display.newImage("buttonMenu.png",30, 50)
	hard = display.newImage("buttonMenu.png",30, 50)
	easy:scale(.7, .7)
	hard:scale(.7, .7)

	easy:setReferencePoint( display.CenterReferencePoint )
	hard:setReferencePoint( display.CenterReferencePoint )	

	easy.y = display.contentHeight / 2
	hard.y = display.contentHeight / 2

	easy.x = display.contentWidth / 2 - 120
	hard.x = display.contentWidth / 2 + 120

	easy:addEventListener("tap", modeEasy)
	hard:addEventListener("tap", modeHard)
	
end

function modeEasy(event)
	for i=1, 5 do
		hearts[i] = display.newImage("heart.png", -87 + ((i-1)*45), -80)
		hearts[i]:scale(.2, .2)
	end
	lenHearts = 5
	modee = "easy"
	play()
end

function modeHard(event)
	for i=1, 1 do
		hearts[i] = display.newImage("heart.png", -87 + ((i-1)*30), -80)
		hearts[i]:scale(.2, .2)
	end
	lenHearts = 1
	modee = "hard"
	play()
end


function play()

	easy:removeSelf()
	easy = nil
	hard:removeSelf()
	hard = nil	
	title:removeSelf()
	title = nil

	r = math.random(1, 5)
	galaxies[1] = display.newImage("gal" .. r .. ".png", 24, 24)
	galaxies[1]:setReferencePoint(display.TopLeftReferencePoint)
	galaxies[1].x = math.random(20, 280)
	galaxies[1].y = math.random(20, 120)

	sheet = graphics.newImageSheet( "greenMan.png", { width=60, height=90, numFrames=15 } )
	sheet1 = graphics.newImageSheet( "enemy.png", {width = 50, height = 67, numFrames = 2} ) 
	sheet2 = graphics.newImageSheet( "explosion.png", {width = 64, height = 64, numFrames = 25})

	greenMan = display.newSprite( sheet, { name="man", start=1, count=15, time=500 } )
	greenMan.x = 140
	greenMan.y = 200
	greenMan.xScale = .5
	greenMan.yScale = .5 
	greenMan:play()
	physics.addBody(greenMan, {friction = 32459872435, density = 5.0, bounce=0, shape = {-5,-20, 10,-20, 10,20, -5,20}})
	greenMan.isFixedRotation = true
	greenMan.isSleepingAllowed = false
	greenMan.bodyType = "dynamic"
	
	platforms[1] = display.newRect(0, 200, 120, 10)
	body = physics.addBody(platforms[1], "static", {bounce=0})
	platforms[1].ID = "platform"	

	for i = 2, 5 do
		if i < 4 then
			rand = 120
		end
		if i > 3 then
			rand = math.random(40, 50)
		end
		platforms[i] = display.newRect((platforms[i-1].x)+(platforms[i-1].width/2)+(60-platforms[i-1].width), 200, rand, 10)
		body = physics.addBody(platforms[i], "static", {bounce=0})
		platforms[i].ID = "platform"
	end

	boxxy=display.newImage("Scorebox.png", display.contentWidth-87, 0)
	totalScore=display.newText("0",display.contentWidth-37,-2)
	screen:addEventListener("tap", jump)
	--background_1:addEventListener("tap", jump)
	--background_2:addEventListener("tap", jump)
	Runtime:addEventListener("enterFrame", movePlatforms)
	Runtime:addEventListener("enterFrame", updateScore)
	greenMan:addEventListener("collision", collision)


end


local clock = os.clock
function sleep(n)  -- seconds
        local t0 = clock()
        while clock() - t0 <= n do end
end

function collision(event)	
	if greenMan.y < event.other.y then
		jump = true
	end
	
	if event.other.ID == "enemy" then
		enemy = event.other
		if (greenMan.y + greenMan.contentHeight / 2 - 15) < (enemy.y - enemy.contentHeight / 2) then
			explode(enemy)
		else
			
				damage = false
				-- hearts[lenHearts]:removeSelf()
				transition.to(hearts[lenHearts], {time = 200, alpha = .3})
				lenHearts = lenHearts - 1
				explode(enemy)
			if lenHearts == 0 then 
				lose()
			end
		end

	end
end
function jump (event)
	txt1.text = "Inside Jump"
	if jump == true then
		jump = false
		greenMan:setLinearVelocity(0,-150)
	end
	txt1.text = "Leaving Jump"

end

function restart()
	button:removeEventListener("tap", restart)
	endScreen1.alpha = 0
	endScreen2.alpha = 0
	button.alpha = 0
	if modee == "hard" then
		lenHearts = 1
	else
		lenHearts = 5
	end

	for i = 1, #hearts do
		transition.to(hearts[i], {time = 0, alpha = 1})
	end	platforms = {}
	iEnd = 5

	transition.to(totalScore, {time = 0, alpha = 0})

	platforms[1] = display.newRect(0, 200, 120, 10)
	body = physics.addBody(platforms[1], "static", {bounce=0})
	platforms[1].ID="platform"

	r = math.random(1, 5)
	galaxies[1] = display.newImage("gal" .. r .. ".png", 24, 24)
	galaxies[1]:setReferencePoint(display.TopLeftReferencePoint)
	galaxies[1].x = math.random(20, 280)
	galaxies[1].y = math.random(20, 120)

	for i = 2, 5 do
		if i < 4 then
			rand = 120
		end
		if i > 3 then
			rand = math.random(40, 50)
		end
		platforms[i] = display.newRect((platforms[i-1].x)+(platforms[i-1].width/2)+(120-platforms[i-1].width), 200, rand, 10)
		body = physics.addBody(platforms[i], "static", {bounce=0})
		platforms[i].ID = "platform"
	end

	greenMan.x = 140
	greenMan.y = 200
	greenMan.bodyType = "dynamic"

	boxxy=display.newImage("Scorebox.png", display.contentWidth-87, 0)
	totalScore=display.newText("0",display.contentWidth-37,-2)
	
	Runtime:addEventListener("enterFrame", movePlatforms)
	Runtime:addEventListener("enterFrame", updateScore )
	backgroundGame:addEventListener("tap", jump)		
end

function explode(enemy)
	xx = enemy.x
	yy = enemy.y
	enemies[enemy.idx] = nil
	enemy:removeSelf()
	explosions[#explosions + 1] = display.newSprite( sheet2, { name="explosion", start=1, count=25, time=300 } )
	explosions[#explosions]:play()
	explosions[#explosions].x = xx - 5
	explosions[#explosions].y = yy
	exBeg = exBeg + 1
end


function lose()
	Runtime:removeEventListener("enterFrame", movePlatforms)
	Runtime:removeEventListener("enterFrame", updateScore)
	countFrame = 0
	countSec = 0
	
	for k, v in pairs (explosions) do
			v:removeSelf()
			explosions[k] = nil
	end
	for k,v in pairs(platforms) do
		v:removeSelf()
		platforms[k] = nil
	end

	for k,v in pairs(enemies) do
		v:removeSelf()
		enemies[k] = nil
	end
	for k, v in pairs(galaxies) do
		v:removeSelf()
		galaxies[k] = nil
	end


	endScreen1 = display.newText("Final Score:" .. totalScore.text, display.contentWidth / 2 - 150, 30, native.systemFont, 24)
	endScreen2 = display.newText("Play again?", display.contentWidth / 2 - 150, 60, native.systemFont, 24)
	
	button = display.newImage("button.png", display.contentWidth / 2 - 150, 100, true)
	button:addEventListener("tap", restart)
	
end



function movePlatforms( event )
	for k, v in pairs (explosions) do
		if v.frame == 25 then
			v:removeSelf()
			explosions[k] = nil
		end
	end
	vx, vy = greenMan:getLinearVelocity()
	greenMan:setLinearVelocity(0, vy)

	for k,v in pairs(platforms) do
		v.x = v.x - 3	
	end

	for k, v in pairs(galaxies) do
		v.x = v.x - 1
		if v.x < -200 then
			v:removeSelf()
			galaxies[k] = nil
		end
	end

	if galaxies[#galaxies].x < math.random(-100, 100) then
		r = math.random(1, 5)
		galaxies[#galaxies + 1] = display.newImage("gal" .. r .. ".png", 				24, 24)
		galaxies[#galaxies]:setReferencePoint(display.TopLeftReferencePoint)
		galaxies[#galaxies].x = 480
		galaxies[#galaxies].y = math.random(20, 120)
	end
	
	for k,v in pairs(enemies) do
		if v.orientation == true then
			v.x = v.x - 5
			p = platforms[v.platNum]
			if v.x < p.x - p.contentWidth / 2 + 10 then
				v.orientation = false	
			end
		end

		if v.orientation == false then
			v.x = v.x - 1	
		end

		p = platforms[v.platNum]
		if v.x > p.x + p.contentWidth / 2 - 2 then
			v.orientation = true
		end
	end
	for k,v in pairs(enemies) do
		if v.x + v.contentWidth < 0 then
			v:removeSelf()
			enemies[k] = nil
		end
	end


	for k,v in pairs(platforms) do
		if v.x + v.contentWidth < 0 then
			v:removeSelf()
			platforms[k] = nil
		end
	end

	if platforms[iEnd].x < 480 then
		-- distance between the two platforms
		rand1 = math.random(60, 100)
		-- width of the platforms
		rand2 = math.random(40, 90)
		-- height difference of the platforms
		if (platforms[iEnd].y > 279) then
			rand3 = -40
		elseif (platforms[iEnd].y < 41) then
			rand3 = 40
		else
			rand3 = math.random(-40, 40)
		end

		platforms[iEnd + 1] = display.newRect(platforms[iEnd].x + rand1, platforms[iEnd].y + rand3, rand2, 10)
		body = physics.addBody(platforms[iEnd + 1], "static", {bounce=0})
		platforms[iEnd + 1].ID="platform"

		iEnd = iEnd + 1
		spawnEnemy(iEnd)
	end

	if greenMan.y>320 or greenMan.x < 0 then
		lose()
	end
end

function updateScore()
	countFrame = countFrame + 1
	transition.to(totalScore, {time=0, alpha=0})
	if countFrame == 30 then
		countFrame=0
		countSec = countSec + 1
	end
	totalScore=display.newText(countSec, display.contentWidth-37, -2)
end

function spawnEnemy(platNum)
	enemy = display.newSprite( sheet1, { name="enemy", start=1, count=2, time=500 } )
	physics.addBody(enemy, {friction = 32459872435, density = 5.0, bounce=0, shape = {-10,-10, 5,-10, 5,5, -10,5}})
	enemy.x = platforms[platNum].x
	enemy.y = platforms[platNum].y - 100
	enemy.xScale = .5
	enemy.yScale = .5
	enemy:play()
	enemy.bodyType = "dynamic"
	enemy.isSleepingAllowed = false
	enemy.isFixedRotation = true
	enemy.orientation = true
	enemy.platNum = platNum
	enemy.ID = "enemy"
	enemy.idx = eEnd + 1
	enemies[eEnd + 1] = enemy
	eEnd = eEnd + 1
end

main()







