package ;

import org.flixel.FlxParticle;
import org.flixel.nape.FlxPhysSprite;

/**
 * ...
 * @author Mike Cugley
 */
class FlxPhysParticle extends FlxPhysSprite, implements FlxParticle
{

	/**
	 * How long this particle lives before it disappears.
	 * NOTE: this is a maximum, not a minimum; the object
	 * could get recycled before its lifespan is up.
	 */
	public var lifespan:Float;
	
	/**
	 * Determines how quickly the particles come to rest on the ground.
	 * Only used if the particle has gravity-like acceleration applied.
	 * @default 500
	 */
	public var friction:Float;
	
	/**
	 * Instantiate a new particle.  Like <code>FlxSprite</code>, all meaningful creation
	 * happens during <code>loadGraphic()</code> or <code>makeGraphic()</code> or whatever.
	 */
	public function new()
	{
		super();
		lifespan = 0;
		friction = 500;
	}
	
	/**
	 * The particle's main update logic.  Basically it checks to see if it should
	 * be dead yet, and then has some special bounce behavior if there is some gravity on it.
	 */
	
	
	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null, CreateBody:Bool=true) 
	{
		super(X, Y, SimpleGraphic, CreateBody);
		
	}
	
	public function onEmit():Void { }
		
		/**
	 * The particle's main update logic.  Basically it checks to see if it should
	 * be dead yet, and then has some special bounce behavior if there is some gravity on it.
	 */
	override public function update():Void
	{
		//lifespan behavior
		if (lifespan <= 0)
		{
			return;
		}
		lifespan -= FlxG.elapsed;
		if (lifespan <= 0)
		{
			kill();
		}
		
		//simpler bounce/spin behavior for now
		if (touching != 0)
		{
			if (angularVelocity != 0)
			{
				angularVelocity = -angularVelocity;
			}
		}
		if(acceleration.y > 0) //special behavior for particles with gravity
		{
			//if (touching & FlxObject.FLOOR)
			if ((touching & FlxObject.FLOOR) != 0)
			{
				drag.x = friction;
				
				//if(!(wasTouching & FlxObject.FLOOR))
				if((wasTouching & FlxObject.FLOOR) == 0)
				{
					if (velocity.y < -elasticity * 10)
					{
						if (angularVelocity != 0)
						{
							angularVelocity *= -elasticity;
						}
					}
					else
					{
						velocity.y = 0;
						angularVelocity = 0;
					}
				}
			}
			else
			{
				drag.x = 0;
			}
		}
	}
	
}