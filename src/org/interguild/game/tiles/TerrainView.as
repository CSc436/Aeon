package org.interguild.game.tiles {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import org.interguild.Aeon;

	public class TerrainView extends Sprite {

		private static var myself:TerrainView;

		public static function getMe():TerrainView {
			if (myself == null) {
				throw new Error("You somehow called TerrainView.getMe() before Level called TerrainView.init()");
			}
			return myself;
		}

		public static function init(w:Number, h:Number):TerrainView {
			myself = new TerrainView(w, h);
			return myself;
		}

		private var terrainBG:Sprite;
		private var terrains:Array;
		private var topBorders:Array;

		public function TerrainView(w, h) {
			/*
				TODO: DO NOT USE MASKS
				Also merge in Henry's assets file
			*/
			terrainBG = new Sprite();
			addChild(terrainBG);
			terrains = [[]];
			topBorders = [[]];
		}

		public function drawTerrainAt(x:Number, y:Number):void {
			var j:int = y / Aeon.TILE_HEIGHT;
			var i:int = x / Aeon.TILE_WIDTH;
			if (terrains[j] == null)
				terrains[j] = [];
			terrains[j][i] = true;

			var above:int = j - 1;
			if (above >= 0) {
				if (terrains[above] == null || terrains[above][i] != true) {
					if (topBorders[j] == null)
						topBorders[j] = [];
					topBorders[j][i] = true;
				}
			}
		}

		public function finishTerrain():void {
			terrainBG.graphics.beginBitmapFill(new TerrainSteelSprite());
			for (var j:uint = 0; j < terrains.length; j++) {
				if (terrains[j]) {
					for (var i:uint = 0; i < terrains[j].length; i++) {
						if (terrains[j][i]) {
							terrainBG.graphics.drawRect(i * Aeon.TILE_WIDTH, j * Aeon.TILE_HEIGHT, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
						}
					}
				}
			}
			terrainBG.graphics.endFill();

			for (j = 0; j < topBorders.length; j++) {
				if (topBorders[j]) {
					for (i = 0; i < topBorders[j].length; i++) {
						if (topBorders[j][i]) {
							var b:Bitmap = new Bitmap(new TerrainTopLayerThin());
							b.x = i * Aeon.TILE_WIDTH;
							b.y = j * Aeon.TILE_HEIGHT;
							addChild(b);
						}
					}
				}
			}
		}
	}
}
