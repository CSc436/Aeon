package org.interguild.game.tiles {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;

	public class TerrainView extends Sprite {

		private static const BORDER_COLOR:uint = 0x333333;
		private static const SECRET_AREA_ALPHA:uint = 0x70000000; //50% alpha

		private static var myself:TerrainView;

		public static function getMe():TerrainView {
			if (myself == null) {
				throw new Error("You somehow called TerrainView.getMe() before Level called TerrainView.init()");
			}
			return myself;
		}

		public static function init(w:int, h:int):TerrainView {
			myself = new TerrainView(w, h);
			return myself;
		}

		private var terrainBG:Sprite;
		private var terrains:Array;
		private var secrets:Array;
		private var topBorders:Array;
		private var bottomBorders:Array;
		private var rightBorders:Array;
		private var leftBorders:Array;

		private var w:int;
		private var h:int;

		private var terrainImage:BitmapData
		private var secretImage:BitmapData

		public function TerrainView(w:int, h:int) {
			this.w = w;
			this.h = h;
			this.terrainImage = Assets.getTerrainImage(0);

			terrainBG = new Sprite();
			addChild(terrainBG);
			terrains = [[]];
			secrets = [[]];
			topBorders = [[]];
			rightBorders = [[]];
			leftBorders = [[]];
			bottomBorders = [[]];
		}

		public function set terrainType(id:uint):void {
			terrainImage = Assets.getTerrainImage(id);
			var w:Number = terrainImage.width;
			var h:Number = terrainImage.height;
			var p:Point = new Point();
			
			secretImage = new BitmapData(w, h, true);
			var alpha:BitmapData = new BitmapData(w, h, true, SECRET_AREA_ALPHA);
			secretImage.copyPixels(terrainImage, new Rectangle(0, 0, w, h), p, alpha, p);
		}

		public function drawTerrainAt(x:Number, y:Number, secretArea:Boolean = false):void {
			var j:int = y / Aeon.TILE_HEIGHT;
			var i:int = x / Aeon.TILE_WIDTH;
			if (terrains[j] == null)
				terrains[j] = [];
			terrains[j][i] = true;
			if (secretArea) {
				if (secrets[j] == null)
					secrets[j] = [];
				secrets[j][i] = true;
			}

			if (bottomBorders[j] == null)
				bottomBorders[j] = [];
			bottomBorders[j][i] = true;

			if (rightBorders[j] == null)
				rightBorders[j] = [];
			rightBorders[j][i] = true;

			var above:int = j - 1;
			if (above >= 0) {
				if (terrains[above] == null || terrains[above][i] != true) {
					if (topBorders[j] == null)
						topBorders[j] = [];
					topBorders[j][i] = true;
				} else {
					bottomBorders[above][i] = false;
				}
			}
			var behind:int = i - 1;
			if (behind >= 0) {
				if (terrains[j] == null || terrains[j][behind] != true) {
					if (leftBorders[j] == null)
						leftBorders[j] = [];
					leftBorders[j][i] = true;
				} else {
					rightBorders[j][behind] = false;
				}
			}
		}

		private function drawHoles(i:uint, j:uint):void {
			drawHole(i, j, 3, 6);
			drawHole(i, j, 18, 6);
			drawHole(i, j, 25, 11);
			drawHole(i, j, 15, 15);
			drawHole(i, j, 5, 19);
			drawHole(i, j, 11, 25);
			drawHole(i, j, 25, 26);
		}

		private function drawHole(x:uint, y:uint, offx:uint, offy:uint):void {
			terrainBG.graphics.drawRect(x * Aeon.TILE_WIDTH + offx, y * Aeon.TILE_HEIGHT + offy, 1, 1);
		}

		public function finishTerrain():void {
			//draw main pattern
			terrainBG.graphics.beginBitmapFill(terrainImage);
			for (var j:uint = 0; j < terrains.length; j++) {
				if (terrains[j]) {
					for (var i:uint = 0; i < terrains[j].length; i++) {
						if (terrains[j][i])
							terrainBG.graphics.drawRect(i * Aeon.TILE_WIDTH, j * Aeon.TILE_HEIGHT, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
						if (secrets[j] && secrets[j][i])
							drawHoles(i, j);
					}
				}
			}
			terrainBG.graphics.endFill();

			//fill in secret area holes
			terrainBG.graphics.beginBitmapFill(secretImage);
			for (j = 0; j < secrets.length; j++) {
				if (secrets[j]) {
					for (i = 0; i < secrets[j].length; i++) {
						if (secrets[j][i]) {
							drawHoles(i, j);
						}
					}
				}
			}
			terrainBG.graphics.endFill();

			//get ready to draw borders
			terrainBG.graphics.beginFill(BORDER_COLOR);

			//draw top borders
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

			//draw bottom borders
			for (j = 0; j < bottomBorders.length; j++) {
				if (bottomBorders[j]) {
					for (i = 0; i < bottomBorders[j].length; i++) {
						if (bottomBorders[j][i]) {
							terrainBG.graphics.drawRect(i * Aeon.TILE_WIDTH, (j + 1) * Aeon.TILE_HEIGHT - 1, Aeon.TILE_WIDTH, 1);
						}
					}
				}
			}

			//draw right borders
			for (j = 0; j < rightBorders.length; j++) {
				if (rightBorders[j]) {
					for (i = 0; i < rightBorders[j].length; i++) {
						if (rightBorders[j][i]) {
							terrainBG.graphics.drawRect((i + 1) * Aeon.TILE_WIDTH - 1, j * Aeon.TILE_HEIGHT, 1, Aeon.TILE_HEIGHT);
						}
					}
				}
			}

			//draw left borders
			for (j = 0; j < leftBorders.length; j++) {
				if (leftBorders[j]) {
					for (i = 0; i < leftBorders[j].length; i++) {
						if (leftBorders[j][i]) {
							terrainBG.graphics.drawRect(i * Aeon.TILE_WIDTH, j * Aeon.TILE_HEIGHT, 1, Aeon.TILE_HEIGHT);
						}
					}
				}
			}
		}
	}
}
