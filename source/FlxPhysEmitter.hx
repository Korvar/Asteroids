package ;

import org.flixel.FlxEmitter;

/**
 * ...
 * @author Mike Cugley
 */
class FlxPhysEmitter extends FlxTypedEmitter<FlxPhysParticle>
{
	public function new(X:Float = 0, Y:Float = 0, Size:Int = 0)
	{
		super(X, Y, Size);
	}

}