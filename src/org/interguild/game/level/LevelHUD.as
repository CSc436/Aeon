package org.interguild.game.level
{
	import flash.display.Shape;
	import flash.display.Sprite;

	public class LevelHUD extends Sprite
		
	{
		public static const XCOORD:uint = 10;
		public static const YCOORD:uint = 7;
		public function LevelHUD()
		{
			var rect:Shape = new Shape();
			rect.graphics.lineStyle(1);
			rect.graphics.beginFill(0X303030,1);
			rect.graphics.drawRect(XCOORD,YCOORD,100,50);
			addChild(rect);

		}
	}
}