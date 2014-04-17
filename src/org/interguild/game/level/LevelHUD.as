package org.interguild.game.level
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class LevelHUD extends Sprite
		
	{
		public static const XCOORD:uint = 10;
		public static const YCOORD:uint = 7;
		public static const XCOORDICON:uint = 5;
		public static const YCOORDICON:uint = 7;
		public static const XCOORDSTRING:uint = 60;
		public static const YCOORDSTRING:uint = 13;
		
		private var collected:int;
		private var maxCollected:int;
		
		private var iconBM:Bitmap;
		private var container:Sprite;
		private var rect:Shape;
		private var collectedCount:TextField;
		private var collectedFormat:TextFormat;
		
		public function LevelHUD(maxCollected:int)
		{
			this.maxCollected = maxCollected;
			
			container = new Sprite();
			drawContainer();
			container.addChild(rect);

			var icon:CollectibleSprite = new CollectibleSprite();
			iconBM = new Bitmap(icon);
			iconBM.x = XCOORD + XCOORDICON;
			iconBM.y = YCOORD + YCOORDICON;
			container.addChild(iconBM);
			
			//format collectedCount text
			collectedFormat = new TextFormat();
			collectedFormat.bold = true;
			collectedFormat.color = 0xFFDA00;
			collectedFormat.size = 30;
			
			//title of dialog box
			var collectedString:String = String(collected) + " / " + String(maxCollected);
			collectedCount = new TextField();
			collectedCount.autoSize = TextFieldAutoSize.LEFT;
			collectedCount.text = collectedString;
			collectedCount.setTextFormat(collectedFormat);
			collectedCount.x = XCOORDSTRING;
			collectedCount.y = YCOORDSTRING;
			collectedCount.width = 60;
			collectedCount.height = 50;
			collectedCount.wordWrap = false;
			collectedCount.multiline = false;
			
			container.addChild(collectedCount);
			
			addChild(container);
			this.visible = false;

		}
		
		public function show():void{
			this.visible = true;
		}
		public function hide():void{
			this.visible = false;
		}
		
		public function increaseCollected():void{
			collected++;
			collectedCount.text = String(collected) + " / " + String(maxCollected);
		}
		
		public function updateMax(ct:int):void{
			maxCollected = ct;
			collectedCount.text = String(collected) + " / " + String(maxCollected);
			collectedCount.setTextFormat(collectedFormat);
		}
		
		private function drawContainer():void{
			rect = new Shape();
			rect.graphics.lineStyle(1);
			rect.graphics.beginFill(0X303030,.5);
			rect.graphics.drawRect(XCOORD,YCOORD,120,50);
		}
		
	}
}