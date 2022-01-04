local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

local clickjournal = GGData:new("clickjournal.txt")
clickjournal.status = 'yes'
clickjournal:save()

--- Generating random values for your infomorph health & enemy infomorph health.
local your_health_randomizer = math.random(100, 500)
local enemy_health_randomizer = math.random(100, 500)

local your_hp_value = your_health_randomizer
local enemy_hp_value = enemy_health_randomizer
---------------------------------------------

--- Pre-declaring health point values.
local your_hp = display.newText( your_hp_value, 50, 50, "zcool.ttf", 16 )
local enemy_hp = display.newText( enemy_hp_value, 50, 50, "zcool.ttf", 16 )
local blood1 = display.newImage( "assets/blood.png" )
local blood2 = display.newImage( "assets/blood.png" )

local fight_button = display.newImage("assets/fight.png")
local dead_img = display.newImage( "assets/dead.png" )
local reset_button = display.newImage("assets/reset.png")

-- Defeated image left
local defeated_img_left = display.newImage( "assets/defeated.png" )
-- Defeated image right
local defeated_img_right = display.newImage( "assets/defeated.png" )


function defeated(event)
	composer.gotoScene( "menu", {effect = "slideLeft", time = "1500"});
end

function reset(event)
	local your_health_randomizer = math.random(100, 500)
	local enemy_health_randomizer = math.random(100, 500)

	local your_hp_value = your_health_randomizer
	local enemy_hp_value = enemy_health_randomizer

	your_hp.text = your_hp_value
	enemy_hp.text = enemy_hp_value

	defeated_img_right.alpha = 0
	defeated_img_left.alpha = 0
	dead_img.alpha = 0
	reset_button.alpha = 0

	fight_button.alpha = 1
end


function battle_start(event)

	function blood_reset(event)
		transition.to( blood1, { time=100, alpha=0, x=blood1.x + 3, y=blood1.y - 3 } )
		transition.to( blood2, { time=100, alpha=0, x=blood2.x + 3, y=blood2.y - 3 } )
	end

	function enemy_get_hit(event)

		if enemy_hp_value >= 0 then

			enemy_hp_value = (enemy_hp_value - 50)
			enemy_hp.text = enemy_hp_value
			transition.to( blood2, { time=100, alpha=1, x=blood2.x - 3, y=blood2.y + 3, onComplete=blood_reset} )

			if enemy_hp_value <= 0 then
				defeated_img_right.alpha = 1
				defeated_img_left.alpha = 0
				fight_button.alpha = 0
				dead_img.alpha = 0
				reset_button.alpha = 1
				timer.pause("red")
				timer.pause("blue")
			else
			end

		else
		end

	end

	function you_get_hit(event)

		if your_hp_value >= 0 then

			your_hp_value = (your_hp_value - 50)
			audio.play(hit)
			your_hp.text = your_hp_value
			transition.to( blood1, { time=100, alpha=1, x=blood1.x - 3, y=blood1.y + 3, onComplete=blood_reset} )
				
				if your_hp_value <= 0 then
					defeated_img_left.alpha = 1
					fight_button.alpha = 0
					dead_img.alpha = 1
					timer.pause("red")
					timer.pause("blue")
				else
				end

		else
		end

	end

	local t1 = timer.performWithDelay( 250, you_get_hit, 10, "red" )
	local t2 = timer.performWithDelay( 250, enemy_get_hit, 10, "blue" )
end





function battle(event)
	audio.play(click)
	fight_button.fill.effect = "filter.brightness"
	fight_button.fill.effect.intensity = 0.5
	transition.to( fight_button, { time=100, alpha=1, x=fight_button.x + 3, y=fight_button.y - 3} )

		function flash_off(event)
			fight_button.fill.effect = "filter.brightness"
			fight_button.fill.effect.intensity = 0.0
			transition.to( fight_button, { time=100, alpha=1, x=fight_button.x - 3, y=fight_button.y + 3} )
			transition.to( fight_button, { time=500, alpha=0, x=fight_button.x - 3, y=fight_button.y + 3} )
		end

	timer.performWithDelay( 200, flash_off )

	battle_start()
end

--------------------------------------------
-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX


function scene:create( event )

	local sceneGroup = self.view

	physics.start()
	physics.setGravity( 0.1, 0.1 )

	-- local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	local background = display.newImage( "assets/bgpro.jpg" )
	background.x = 150
	background.y = 200
	background.alpha = 0.1
	background:scale(0.1, 0.1)
	sceneGroup:insert( background )

		----------- Title of your Infomorph ----------
		local morp_title = display.newText( "Your Infomorph", 50, 50, "zcool.ttf", 18 )
		morp_title:setFillColor( 250, 250, 250 )
		morp_title.x = 115
		morp_title.y = 40
		morp_title.alpha = 1
		sceneGroup:insert( morp_title )

				----------- Title of enemy Infomorph ----------
				local morp_title = display.newText( "Enemy Infomorph", 50, 50, "zcool.ttf", 18 )
				morp_title:setFillColor( 250, 250, 250 )
				morp_title.x = 375
				morp_title.y = 40
				morp_title.alpha = 1
				sceneGroup:insert( morp_title )

		--- Your generated infomorph
		local infomorph1 = display.newImage("entireGroup.png", system.DocumentsDirectory)
		infomorph1.x = 75
		infomorph1.y = 145
		infomorph1.alpha = 1
		infomorph1:scale(0.1, 0.1)
		sceneGroup:insert( infomorph1 )

				--- Enemy infomorph fetch (For now, using a sample infomorph)
				local infomorph2 = display.newImage("entireGroup.png", system.DocumentsDirectory)
				infomorph2.x = 375
				infomorph2.y = 145
				infomorph2.alpha = 1
				infomorph2:scale(0.1, 0.1)
				sceneGroup:insert( infomorph2 )
				
				--- Blood splat
				--local blood1 = display.newImage( "assets/blood.png" )
				blood1.x = 115
				blood1.y = 155
				blood1.alpha = 0
				blood1:scale(0.7, 0.7)
				sceneGroup:insert( blood1 )

								--- Blood splat 2
								--local blood2 = display.newImage( "assets/blood.png" )
								blood2.x = 385
								blood2.y = 155
								blood2.alpha = 0
								blood2:scale(0.7, 0.7)
								sceneGroup:insert( blood2 )

		--- Fight button
		--local fight_button = display.newImage("assets/fight.png")
		fight_button.x = 235
		fight_button.y = 285
		fight_button.alpha = 1
		fight_button:scale(0.1, 0.1)
		fight_button:addEventListener("tap", battle);
		sceneGroup:insert( fight_button )

			--- Reset button
			--local reset_button = display.newImage("assets/reset.png")
			reset_button.x = 235
			reset_button.y = 285
			reset_button.alpha = 0
			reset_button:scale(0.5, 0.5)
			reset_button:addEventListener("tap", reset);
			sceneGroup:insert( reset_button )


				----------- HP of your Infomorph ----------
				--local your_hp = display.newText( "HP:  500", 50, 50, "zcool.ttf", 16 )
				your_hp:setFillColor( 250, 250, 250 )
				your_hp.x = 75
				your_hp.y = 240
				your_hp.alpha = 1
				sceneGroup:insert( your_hp )

						----------- HP of enemy Infomorph ----------
						--local enemy_hp = display.newText( "HP:  500", 50, 50, "zcool.ttf", 16 )
						enemy_hp:setFillColor( 250, 250, 250 )
						enemy_hp.x = 375
						enemy_hp.y = 240
						enemy_hp.alpha = 1
						sceneGroup:insert( enemy_hp )

	-- Defeated image left
	--local defeated_img_left = display.newImage( "assets/defeated.png" )
	defeated_img_left.x = 115
	defeated_img_left.y = 150
	defeated_img_left.alpha = 0
	defeated_img_left:scale(0.7, 0.7)
	sceneGroup:insert( defeated_img_left )

		-- Defeated image right
		--local defeated_img_right = display.newImage( "assets/defeated.png" )
		defeated_img_right.x = 375
		defeated_img_right.y = 150
		defeated_img_right.alpha = 0
		defeated_img_right:scale(0.7, 0.7)
		sceneGroup:insert( defeated_img_right )

		-- You're Dead image
		--local dead_img = display.newImage( "assets/dead.png" )
		dead_img.x = 235
		dead_img.y = 285
		dead_img.alpha = 0
		dead_img:scale(0.48, 0.48)
		dead_img:addEventListener("tap", defeated);
		sceneGroup:insert( dead_img )
	

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then


	local letterboxWidth = math.abs(display.screenOriginX)
	local letterboxHeight = math.abs(display.screenOriginY)

	local mainGroup = display.newGroup()
	math.randomseed( os.time() )


	-- Create "walls" around screen
	local wallL = display.newRect( mainGroup, 0-letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
	wallL.myName = "Left Wall"
	wallL.anchorX = 1
	physics.addBody( wallL, "static", { bounce=0.1, friction=0.1 } ) --- Bounce was originally 1, for all four walls.

	local wallR = display.newRect( mainGroup, 485+letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
	wallR.myName = "Right Wall"
	wallR.anchorX = 0
	physics.addBody( wallR, "static", { bounce=0.1, friction=0.1 } )

	--- Gotta test this top wall, is it in the right place? other walls are OK.
	local wallT = display.newRect( mainGroup, display.contentCenterX, 0-letterboxHeight, display.actualContentWidth, 20 )
	wallT.myName = "Top Wall"
	wallT.anchorY = 1
	physics.addBody( wallT, "static", { bounce=0.1, friction=0.1 } )

	local wallB = display.newRect( mainGroup, display.contentCenterX, 340+letterboxHeight, display.actualContentWidth, 20 )
	wallB.myName = "Bottom Wall"
	wallB.anchorY = 0
	physics.addBody( wallB, "static", { bounce=0.1, friction=0.1 } )



		------------------------------------------- MOUSE FUNCTION PURE ---------------------------------------------
			-- Called when a mouse event has been received.
			local function onMouseEvent( event )

				local clickjournal = GGData:new("clickjournal.txt")

				if event.type == "down" --[[and clickjournal.status == 'yes'--]] then
					if event.isPrimaryButtonDown then
	
					elseif event.isSecondaryButtonDown then
						print( "Right mouse button clicked." )        
					end

				end
			end

			-- Add the mouse event listener.
			Runtime:addEventListener( "mouse", onMouseEvent )
		------------------------------------------- MOUSE FUNCTION PURE ---------------------------------------------

		end

end



function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		physics.stop()
	elseif phase == "did" then
	end	
	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene