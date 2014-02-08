package org.interguild {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import feathers.controls.Button;
	
	import starling.core.Starling;

	[SWF(backgroundColor = "0x000000", width = "480", height = "350")]
	public class Aeon extends Sprite {

		private var levelPage:LevelPage;
		private var keys:KeyMan;

		private var game:Starling;

		public function Aeon() {
			//stop stage from scaling and stuff
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			//init bg
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();

			//init key man
			keys = new KeyMan(stage);

			//init level page:
			levelPage = new LevelPage();
			addChild(levelPage);
		}
	}
}
