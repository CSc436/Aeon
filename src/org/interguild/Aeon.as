package org.interguild {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import org.interguild.menu.LevelPage;
	import org.interguild.game.KeyMan;
	
	[SWF(backgroundColor = "0x000000", width = "480", height = "350")]
	public class Aeon extends Sprite {

		private var levelPage:LevelPage;
		private var keys:KeyMan;

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
