package ;

import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Polygon;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.nape.FlxPhysSprite;

/**
 * ...
 * @author Mike Cugley
 */
class Asteroid extends FlxGroup
{

	public function new(X:Float, Y:Float) 
	{
		super();
		
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
				add(newSegment);
				cells[i].push(newSegment);
			}
		}
		
		for (i in 0...(numCells -1))		{
			for (j in 0...(numCells -1))
			{
				var thisCell = cells[i][j];
				var rightCell = cells[i + 1][j];
				var downCell = cells[i][j + 1];
				var rightDownCell = cells[i + 1][j + 1];
			}
		}
		
	}
	
}