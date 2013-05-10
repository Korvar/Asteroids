package ;

import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Polygon;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.nape.FlxPhysSprite;

/**
 * ...
 * @author Mike Cugley
 */
class Asteroid extends FlxPhysSprite
{

	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null, CreateBody:Bool=true) 
	{
		super(X, Y, SimpleGraphic, CreateBody);
		
		// First pass at making my multi-object asteroid.
		
		// body.shapes.clear();
		
		var width:Int = 200;
		var cellWidth:Int = 20;
		var numCells:Int = Std.int(width / cellWidth);
		
		var cells:Array<Array<FlxSprite>> = new Array<Array<FlxSprite>>();
		
		for (i in 0...numCells)
		{
			var tempArray:Array<FlxSprite> = new Array<FlxSprite>();
			cells.push(tempArray);
			for (j in 0...numCells)
			{
				var newSegment:FlxPhysSprite = new FlxPhysSprite(i, j);
				var newShape:Polygon = new Polygon(Polygon.rect(X + (i * cellWidth), Y + (j * cellWidth), cellWidth, cellWidth, true), Material.sand());
				newShape.material = Material.sand();
				newSegment.body.shapes.clear();
				newSegment.body.shapes.add(newShape);
				FlxG.state.add(newSegment);
				cells[i].push(newSegment);
			}
		}
		
	}
	
}