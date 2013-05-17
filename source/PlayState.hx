package ;
import org.flixel.FlxButton;
import org.flixel.FlxCamera;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxU;
import org.flixel.nape.FlxPhysState;

/**
 * ...
 * @author Mike Cugley
 */
class PlayState extends FlxPhysState
{
	
	var hud:FlxGroup;
	var buttonLeft:FlxButton;
	var buttonRight:FlxButton;
	var buttonUp:FlxButton;
	var buttonDown:FlxButton;
	var buttonA:FlxButton;	
	
	#if debug
	var debugHud:FlxGroup;
	var thrustMaxText:FlxText;
	var thrustDeltaText:FlxText;
	var maneuverJetThrustText:FlxText;
	var weldStrengthText:FlxText;
	var gravityText:FlxText;
	#end

	public function new() 
	{
		super();
	}
	
	override public function create():Void
	{
		super.create();
		#if mobile
		FlxG.mouse.hide();
		#end
		
		createStars();
		
		// Sets gravity.
		FlxPhysState.space.gravity.setxy(0,0);  // No Gravity
		
		// FlxPhysState shortcut to create bondaries around game area. 
		createWalls(Registry.worldMinX, Registry.worldMinY, Registry.worldMaxX, Registry.worldMaxY);
		
		var ship:Ship = new Ship((Registry.worldMaxX - Registry.worldMinX) / 2, (Registry.worldMaxY - Registry.worldMinY) / 2);
		add(ship);
		
		FlxG.camera.follow(ship);
		FlxG.camera.setBounds(Registry.worldMinX, Registry.worldMinY, Registry.worldMaxX, Registry.worldMaxY, true);
		
		var asteroid:Asteroid = new Asteroid(ship.x + 300, ship.y);
		add(asteroid);
		
		var testParticle:FlxPhysParticle = new FlxPhysParticle(ship.x, ship.y +200);
		add(testParticle);
		
		var testEmitter:FlxEmitter = new FlxEmitter(ship.x -200, ship.y + 200);
		add(testEmitter);
		
		setupHUD();
				
		#if debug
		setupDebugHUD();
		#end
		
		
		// disablePhysDebug();
	}
	
	override public function update():Void
	{
		super.update();
		if (FlxG.keys.justPressed("R")) FlxG.resetState();
	}
	
function setupDebugHUD()
	{
		debugHud = new FlxGroup();
		
		var debugString:FlxText = new FlxText(FlxG.width - 300, 300, FlxG.width, "test");
		debugString.size = 8;
		debugString.color = 0xFFFFFF;
		Registry.debugString = debugString;

		var thrustMaxButtonUp:FlxButton = new FlxButton(FlxG.width - 300, 100, null);
		var thrustMaxButtonDown:FlxButton = new FlxButton(FlxG.width - 64, 100, null);
		thrustMaxText = new FlxText(FlxG.width - 236, 100, 174, "ThrustMax: " + Std.string(Registry.thrustMax));
		thrustMaxText.alignment = "center";
		thrustMaxButtonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		thrustMaxButtonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		thrustMaxButtonDown.onDown = thrustMaxButtonDownHandler;
		thrustMaxButtonUp.onDown = thrustMaxButtonUpHandler;
		
		var thrustDeltaButtonUp:FlxButton = new FlxButton(FlxG.width - 300, 150, null);
		var thrustDeltaButtonDown:FlxButton = new FlxButton(FlxG.width - 64, 150, null);
		thrustDeltaText = new FlxText(FlxG.width - 236, 150, 174, "thrustDelta: " + Std.string(Registry.thrustDelta));
		thrustDeltaText.alignment = "center";
		thrustDeltaButtonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		thrustDeltaButtonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		thrustDeltaButtonDown.onDown = thrustDeltaButtonDownHandler;
		thrustDeltaButtonUp.onDown = thrustDeltaButtonUpHandler;
		
		var maneuverJetThrustButtonUp:FlxButton = new FlxButton(FlxG.width - 300, 200, null);
		var maneuverJetThrustButtonDown:FlxButton = new FlxButton(FlxG.width - 64, 200, null);
		maneuverJetThrustText = new FlxText(FlxG.width - 236, 200, 174, "maneuverJetThrust: " + Std.string(Registry.maneuverJetThrust));
		maneuverJetThrustText.alignment = "center";
		maneuverJetThrustButtonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		maneuverJetThrustButtonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		maneuverJetThrustButtonDown.onDown = maneuverJetThrustButtonDownHandler;
		maneuverJetThrustButtonUp.onDown = maneuverJetThrustButtonUpHandler;		
		
		
		var weldStrengthButtonUp:FlxButton = new FlxButton(FlxG.width - 300, 250, null);
		var weldStrengthButtonDown:FlxButton = new FlxButton(FlxG.width - 64, 250, null);
		weldStrengthText = new FlxText(FlxG.width - 236, 250, 174, "weldStrength: " + Std.string(Registry.weldStrength));
		weldStrengthText.alignment = "center";
		weldStrengthButtonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		weldStrengthButtonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		weldStrengthButtonDown.onDown = weldStrengthButtonDownHandler;
		weldStrengthButtonUp.onDown = weldStrengthButtonUpHandler;		
		
		for (item in [thrustMaxButtonDown, thrustMaxButtonUp, thrustMaxText, 
						thrustDeltaButtonUp, thrustDeltaButtonDown, thrustDeltaText,
						weldStrengthButtonUp, weldStrengthButtonDown, weldStrengthText,
						maneuverJetThrustButtonUp, maneuverJetThrustButtonDown, maneuverJetThrustText,
						debugString])
		{
			debugHud.add(item);
		}
		
		add(debugHud);
		
		var debugHUDCamera:FlxCamera = new FlxCamera(FlxG.width - 300, 0, 300, 300, 1);
		debugHUDCamera.setBounds(FlxG.width -300, 80, 300, 300);
		debugHUDCamera.bgColor = 0xFF000000;
		FlxG.addCamera(debugHUDCamera);
		debugHud.cameras = [debugHUDCamera];
		
		for (item in debugHud.members)
		{
			item.cameras = [debugHUDCamera];
			// cast(item, FlxObject).scrollFactor = new FlxPoint(0, 0);
		}
		debugHUDCamera.focusOn(new FlxPoint(FlxG.width - 150, 300));
		
	}
		
		function thrustMaxButtonDownHandler():Void
	{
		Registry.thrustMax -= 100;
		thrustMaxText.text = "ThrustMax: " + Std.string(Registry.thrustMax);
	}	
	function thrustMaxButtonUpHandler():Void
	{
		Registry.thrustMax += 100;
		thrustMaxText.text = "ThrustMax: " + Std.string(Registry.thrustMax);
	}
	
	function thrustDeltaButtonDownHandler():Void
	{
		Registry.thrustDelta -= 10;
		thrustDeltaText.text = "thrustDelta: " + Std.string(Registry.thrustDelta);
	}	
	function thrustDeltaButtonUpHandler():Void
	{
		Registry.thrustDelta += 10;
		thrustDeltaText.text = "thrustDelta: " + Std.string(Registry.thrustDelta);
	}	
	
	function maneuverJetThrustButtonDownHandler():Void
	{
		Registry.maneuverJetThrust -= 10;
		maneuverJetThrustText.text = "maneuverJetThrust: " + Std.string(Registry.maneuverJetThrust);
	}	
	function maneuverJetThrustButtonUpHandler():Void
	{
		Registry.maneuverJetThrust += 10;
		maneuverJetThrustText.text = "maneuverJetThrust: " + Std.string(Registry.maneuverJetThrust);
	}
		
	function weldStrengthButtonDownHandler():Void
	{
		Registry.weldStrength -= 1;
		weldStrengthText.text = "weldStrength: " + Std.string(Registry.weldStrength);
	}	
	function weldStrengthButtonUpHandler():Void
	{
		Registry.weldStrength += 1;
		weldStrengthText.text = "weldStrength: " + Std.string(Registry.weldStrength);
	}
	
	private function createStars():Void 
	{
		// Creates 500 "stars" randomly positioned.
		for (i in 0...500) 
		{
			var startX:Float = 0;
			var startY:Float = 0;
			var minX:Int = Std.int(Registry.worldMinX);
			var worldWidth:Int = Std.int(Registry.worldMaxX - Registry.worldMinX);
			startX = minX + 30 + Std.random((worldWidth - 60)); 
			var minY:Int = Std.int(Registry.worldMinY);
			var worldHeight:Int = Std.int(Registry.worldMaxY - Registry.worldMinY);
			startY = minY + 30 + Std.random((worldHeight - 60)); 
	
			
			var newSprite:FlxSprite = new FlxSprite(Std.int(startX), Std.int(startY) );
			newSprite.makeGraphic(2, 2, 0xFFFFFFFF);
			add (newSprite);
		}
	}
	
		private function setupHUD():Void 
	{
		hud = new FlxGroup();
		buttonLeft = new FlxButton(10, 50, null);
		buttonRight = new FlxButton(110, 50, null);
		buttonUp = new FlxButton(60, 0, null);
		buttonDown = new FlxButton(60, 100, null);
		buttonA = new FlxButton(FlxG.width - 60, 50, null);
		buttonLeft.loadGraphic("assets/data/button_left.png", true, false, 44, 45);
		buttonRight.loadGraphic("assets/data/button_right.png", true, false, 44, 45);
		buttonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		buttonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		buttonA.loadGraphic("assets/data/button_a.png", true, false, 44, 45);
		buttonLeft.scrollFactor = buttonRight.scrollFactor = buttonUp.scrollFactor = buttonDown.scrollFactor = buttonA.scrollFactor = new FlxPoint(0, 0);
		Registry.buttonUp = buttonUp;
		Registry.buttonDown = buttonDown;
		Registry.buttonLeft = buttonLeft;
		Registry.buttonRight = buttonRight;
		
		hud.add(buttonLeft);
		hud.add(buttonRight);
		hud.add(buttonUp);
		hud.add(buttonDown);
		hud.add(buttonA);
	
		var maxX:Float=-2000;
		var minX:Float = 2000;
		var minY:Float = 2000;
		var maxY:Float = -2000;
		var numPoints:Int = 0;
	
		var hudCamera:FlxCamera = new FlxCamera(0, FlxU.floor((FlxG.height * 4 / 5) - 50), FlxU.floor(FlxG.width), FlxU.floor((FlxG.height / 5) + 100));
	
		for (i in hud.members)
		{
			var thisButton:FlxButton = cast(i, FlxButton);
			#if android
			//thisButton.x -= 500;
			//thisButton.y -= 75;
			#end
			
			thisButton.cameras = [hudCamera];
			
			if (thisButton.x > maxX)
			{
				maxX = thisButton.x;
			}
			if (thisButton.x < minX)
			{
				minX = thisButton.x;
			}
			if (thisButton.y > maxY)
			{
				maxY = thisButton.y;
			}
			if (thisButton.y < minY)
			{
				minY = thisButton.y;
			}
			
			numPoints ++;
		}
		
		var meanX:Float = (minX + maxX) / numPoints;
		var meanY:Float = (minY + maxY) / numPoints;
	
		//hudCamera.follow(buttonA);
		hudCamera.y = FlxG.height - (maxY - minY) - Std.int(buttonDown.height);
		#if android
		hudCamera.y -= 75;
		#end
		hudCamera.height = Std.int((maxY - minY) + buttonDown.height);
		hudCamera.focusOn(new FlxPoint(meanX, meanY - 50));
		hudCamera.setBounds(minX, minY - 100, maxX, maxY);
		hudCamera.bgColor = 0x00000000;
	
		#if mobile
		FlxG.addCamera(hudCamera);
		add(hud);
		#end
	}
}