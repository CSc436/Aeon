package org.interguild.game.tiles {
	import flash.display.Sprite;
	
	import org.interguild.Aeon;

	public class TerrainView extends Sprite {
		
		private static var myself:TerrainView;
		
		public static function getMe():TerrainView{
			if(myself==null){
				throw new Error("You somehow called TerrainView.getMe() before Level called TerrainView.init()");
			}
			return myself;
		}
		
		public static function init(w:Number, h:Number):TerrainView{
			myself = new TerrainView(w, h);
			return myself;
		}
		
		private var terrainBG:Sprite;
		
		public function TerrainView(w, h) {
			terrainBG = new Sprite();
			terrainBG.graphics.beginFill(0xFFFF00);
			terrainBG.graphics.drawRect(0, 0, w, h);
			terrainBG.graphics.endFill();
		}
		
		public function drawTerrainAt(x:Number, y:Number):void{
			graphics.beginFill(0xFF0000);
			graphics.drawRect(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			graphics.endFill();
		}
	}
}
