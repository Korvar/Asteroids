package ;

import nape.constraint.PivotJoint;
import nape.geom.Vec2;
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
		
		var cells:Array<Array<FlxPhysSprite>> = new Array<Array<FlxPhysSprite>>();
		
		for (i in 0...numCells)
		{
			var tempArray:Array<FlxPhysSprite> = new Array<FlxPhysSprite>();
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
		
		for (i in 0...(numCells -1))
		{
			for (j in 0...(numCells -1))
			{
				var thisCell:FlxPhysSprite = cells[i][j];
				var rightCell:FlxPhysSprite = cells[i + 1][j];
				var downCell:FlxPhysSprite = cells[i][j + 1];
				var rightDownCell:FlxPhysSprite = cells[i + 1][j + 1];
				
				var rightWeldPoint:Vec2 = new Vec2((i + 1) * cellWidth + X, j * cellWidth + Y);
				var downWeldPoint:Vec2 = new Vec2(i * cellWidth + X, (j + 1) * cellWidth + Y);
				var rightDownWeldPoint:Vec2 = new Vec2((i + 1) * cellWidth + X, (j + 1) * cellWidth + Y);
				
				var rightWeld:PivotJoint = new PivotJoint(thisCell.body, rightCell.body, 
					thisCell.body.worldPointToLocal(rightWeldPoint), 
					rightCell.body.worldPointToLocal(rightWeldPoint));
				rightWeld.space = thisCell.body.space;				
				var downWeld:PivotJoint = new PivotJoint(thisCell.body, downCell.body, 
					thisCell.body.worldPointToLocal(downWeldPoint), 
					downCell.body.worldPointToLocal(downWeldPoint));
				downWeld.space = thisCell.body.space;				
				var rightDownWeld:PivotJoint = new PivotJoint(thisCell.body, rightDownCell.body, 
					thisCell.body.worldPointToLocal(rightDownWeldPoint), 
					rightDownCell.body.worldPointToLocal(rightDownWeldPoint));
				rightDownWeld.space = thisCell.body.space;
				
				rightWeld.ignore = true;
				downWeld.ignore = true;
				rightDownWeld.ignore = true;
				
				
				rightWeldPoint.dispose();
				downWeldPoint.dispose();
				rightDownWeldPoint.dispose();
				
				
			}
		}
		
	}
	
}