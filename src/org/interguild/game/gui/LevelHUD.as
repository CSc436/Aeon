package org.interguild.game.gui {
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.interguild.Assets;

	public class LevelHUD extends Sprite {
		public static const XCOORD:uint = 10;
		public static const YCOORD:uint = 7;
		public static const XCOORDICON:uint = 5;
		public static const YCOORDICON:uint = 7;
		public static const XCOORDSTRING:uint = 60;
		public static const YCOORDSTRING:uint = 13;

		public var collected:int = 0;
		public var maxCollected:int = 0;

		private var iconBM:Bitmap;
		private var container:Sprite;
		private var rect:Shape;
		private var collectedCount:TextField;

		public function LevelHUD() {

			container = new Sprite();
			rect = new Shape();
			container.addChild(rect);

			iconBM = new Bitmap(Assets.TREASURE_SPRITE);
			iconBM.x = XCOORD + XCOORDICON;
			iconBM.y = YCOORD + YCOORDICON;
			container.addChild(iconBM);

			//format collectedCount text
			var collectedFormat:TextFormat = new TextFormat();
			collectedFormat.bold = true;
			collectedFormat.color = 0xFFDA00;
			collectedFormat.size = 30;

			//title of dialog box
			var collectedString:String = String(collected) + " / " + String(maxCollected);
			collectedCount = new TextField();
			collectedCount.autoSize = TextFieldAutoSize.LEFT;
			collectedCount.text = collectedString;
			collectedCount.defaultTextFormat = collectedFormat;
			collectedCount.x = XCOORDSTRING;
			collectedCount.y = YCOORDSTRING;
			collectedCount.width = 60;
			collectedCount.height = 50;
			collectedCount.wordWrap = false;
			collectedCount.multiline = false;

			container.addChild(collectedCount);

			addChild(container);
			drawContainer();
			this.visible = false;

		}

		public function show():void {
			this.visible = true;
		}

		public function hide():void {
			this.visible = false;
		}

		public function increaseCollected():void {
			collected++;
			collectedCount.text = String(collected) + " / " + String(maxCollected);
			drawContainer();
		}

		public function updateMax(ct:int):void {
			maxCollected = ct;
			collectedCount.text = String(collected) + " / " + String(maxCollected);
			drawContainer();
		}

		private function drawContainer():void {
			rect.graphics.clear();
			rect.graphics.lineStyle(1);
			rect.graphics.beginFill(0X303030, .5);
			rect.graphics.drawRect(XCOORD, YCOORD, collectedCount.x + collectedCount.width, 50);
		}

	}
}
