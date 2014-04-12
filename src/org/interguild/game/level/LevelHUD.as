package org.interguild.game.level
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class LevelHUD extends Sprite
		
	{
		public static const XCOORD:uint = 10;
		public static const YCOORD:uint = 7;
		public static const XCOORDICON:uint = 5;
		public static const YCOORDICON:uint = 7;
		private var iconBM:Bitmap;
		private var container:Sprite;
		private var rect:Shape;
		
		public function LevelHUD()
		{
			container = new Sprite();
			drawContainer();
			container.addChild(rect);

			var icon:CollectableSprite = new CollectableSprite();
			iconBM = new Bitmap(icon);
			iconBM.x = XCOORD + XCOORDICON;
			iconBM.y = YCOORD + YCOORDICON;
			container.addChild(iconBM);
			
			addChild(container);
			this.visible = false;

		}
		
		public function show():void{
			this.visible = true;
		}
		public function hide():void{
			this.visible = false;
		}
		
		private function drawContainer():void{
			rect = new Shape();
			rect.graphics.lineStyle(1);
			rect.graphics.beginFill(0X303030,.5);
			rect.graphics.drawRect(XCOORD,YCOORD,100,50);
		}
	}
}