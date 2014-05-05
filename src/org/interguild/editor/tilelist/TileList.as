package org.interguild.editor.tilelist {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	
	import org.interguild.Aeon;
	import org.interguild.game.Player;
	import org.interguild.game.tiles.ArrowCrate;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.FinishLine;
	import org.interguild.game.tiles.SteelCrate;
	import org.interguild.game.tiles.Terrain;
	import org.interguild.game.tiles.WoodCrate;

	public class TileList extends Sprite {

		private static const POSITION_X:uint = 655;
		private static const POSITION_Y:uint = 89;

		private static const BORDER_PADDING:uint = 8;
		private static const SCROLLBAR_WIDTH:uint = 15;

		//TileListItem references this
		internal static const MASK_WIDTH:uint = Aeon.STAGE_WIDTH - POSITION_X - SCROLLBAR_WIDTH;
		private static const MASK_HEIGHT:uint = Aeon.STAGE_HEIGHT - POSITION_Y;// - (2 * PADDING_Y);

		private static const BG_COLOR:uint = 0x115867;
		private static const BG_CORNER_RADIUS:uint = 20;
		private static const BG_WIDTH:uint = MASK_WIDTH + (BG_CORNER_RADIUS * 2);
		private static const BG_HEIGHT:uint = MASK_HEIGHT + (BG_CORNER_RADIUS * 2);

		private var playerSpawn:Boolean;
		private var selectionBox:Boolean;

		private var list:Sprite;
		private var currentSelection:TileListItem;

		private var nextY:uint = 0; //used for adding tiles to the list

		public function TileList() {
			x = POSITION_X;
			y = POSITION_Y;

			//init bg
			graphics.beginFill(BG_COLOR);
			graphics.drawRoundRect(0, 0, BG_WIDTH, BG_HEIGHT, BG_CORNER_RADIUS, BG_CORNER_RADIUS);
			graphics.endFill();

			//init list item container
			list = new Sprite();
			list.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			nextY += BORDER_PADDING;

			//init items
			currentSelection = new TileListItem(new TerrainSprite(), "Terrain", Terrain.LEVEL_CODE_CHAR);
			currentSelection.select();
			addItem(currentSelection);
			addItem(new TileListItem(new StartingPositionSprite(), "Starting Position", Player.LEVEL_CODE_CHAR));
			addItem(new TileListItem(new FinishLineSprite(), "End Portal", FinishLine.LEVEL_CODE_CHAR));
			addItem(new TileListItem(new CollectibleSprite(), "Treasure", Collectable.LEVEL_CODE_CHAR));
			addItem(new TileListItem(new WoodenCrateSprite(), "Wooden Crate", WoodCrate.LEVEL_CODE_CHAR));
			addItem(new TileListItem(new SteelCrateSprite(), "Steel Crate", SteelCrate.LEVEL_CODE_CHAR));
			addItem(new TileListItem(new LightningBoxRight(), "Arrow Crate Right", ArrowCrate.LEVEL_CODE_CHAR_RIGHT));
			addItem(new TileListItem(new LightningBoxLeft(), "Arrow Crate Left", ArrowCrate.LEVEL_CODE_CHAR_LEFT));
			addItem(new TileListItem(new LightningBoxUp(), "Arrow Crate Up", ArrowCrate.LEVEL_CODE_CHAR_UP));
			addItem(new TileListItem(new LightningBoxDown(), "Arrow Crate Down", ArrowCrate.LEVEL_CODE_CHAR_DOWN));
			addItem(new TileListItem(new WoodenDynamiteSprite(), "Wooden Dynamite Crate", Terrain.LEVEL_CODE_CHAR));
			addItem(new TileListItem(new SteelDynamiteSprite(), "Steel Dynamite Crate", Terrain.LEVEL_CODE_CHAR));
			
			//add some padding
			list.graphics.beginFill(0, 0);
			list.graphics.drawRect(0, 0, 1, BORDER_PADDING);
			list.graphics.drawRect(0, nextY, 1, BORDER_PADDING);
			list.graphics.endFill();

			//init scroll page
			var scrollpane:ScrollPane = new ScrollPane();
			scrollpane.source = list;
			scrollpane.width = MASK_WIDTH + SCROLLBAR_WIDTH;
			scrollpane.height = MASK_HEIGHT;
			scrollpane.horizontalScrollPolicy = ScrollPolicy.OFF;
			scrollpane.verticalScrollBar.pageScrollSize = 100;
			addChild(scrollpane);
		}
		
		private function onClick(evt:MouseEvent):void{
			if(evt.target is TileListItem){
				currentSelection.deselect();
				currentSelection = TileListItem(evt.target);
				currentSelection.select();
			}
		}

		private function addItem(i:TileListItem):void {
			i.y = nextY;
			nextY += i.height;
			list.addChild(i);
		}

		public function getActiveButton():String {
			return currentSelection.getCharCode();
		}

		public function isPlayerSpawn():Boolean {
			return playerSpawn;
		}

		public function setPlayerSpawn(bool:Boolean):void {
			playerSpawn = bool;
		}

		public function isSelectionBox():Boolean {
			return selectionBox;
		}
	}
}
