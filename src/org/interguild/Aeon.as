package org.interguild {
	import flash.display.Sprite;

	[SWF(backgroundColor="0x000000" , width="480" , height="350")]
	public class Aeon extends Sprite {
		
		private var levelPage:LevelPage;
		
		public function Aeon() {
			//init bg
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			//init level page:
			 levelPage = new LevelPage();
			 addChild(levelPage);
		}
	}
}
