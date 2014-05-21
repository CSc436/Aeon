package org.interguild.editor.tilelist {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;

	import org.interguild.Aeon;
	import org.interguild.editor.EditorPage;
	import org.interguild.game.Player;
	import org.interguild.game.tiles.ArrowCrate;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.DynamiteCrate;
	import org.interguild.game.tiles.FinishLine;
	import org.interguild.game.tiles.SteelCrate;
	import org.interguild.game.tiles.Terrain;
	import org.interguild.game.tiles.WoodCrate;

	public class TileList extends Sprite {

		private static const POSITION_X:uint = 655;
		private static const POSITION_Y:uint = 89;

		private static const BORDER_PADDING:uint = 8;
		private static const SCROLLBAR_WIDTH:uint = 15;

		//TileListItem references this:
		internal static const MASK_WIDTH:uint = Aeon.STAGE_WIDTH - POSITION_X - SCROLLBAR_WIDTH;
		private static const MASK_HEIGHT:uint = Aeon.STAGE_HEIGHT - POSITION_Y; // - (2 * PADDING_Y);

		private static const BG_COLOR:uint = 0x115867;
		private static const BG_CORNER_RADIUS:uint = 20;
		private static const BG_WIDTH:uint = MASK_WIDTH + (BG_CORNER_RADIUS * 2);
		private static const BG_HEIGHT:uint = MASK_HEIGHT + (BG_CORNER_RADIUS * 2);

		public static const SELECTION_TOOL_CHAR:String = "SELECTION";
		public static const ERASER_TOOL_CHAR:String = " ";

		private static var map:Object = new Object();

		public static function getIcon(charCode:String):BitmapData {
			return map[charCode];
		}

		private var list:Sprite;
		private var currentSelection:TileListItem;
		private var nextY:uint = 0; //used for adding tiles to the list

		private var editor:EditorPage;

		public function TileList(editor:EditorPage) {
			this.editor = editor;
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
			initList();

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

		private function initList():void {
			map[SELECTION_TOOL_CHAR] = new SelectionToolSprite();
			addItem(new TileListItem("Selection Tool", SELECTION_TOOL_CHAR));

			map[ERASER_TOOL_CHAR] = new SelectionToolSprite();
			addItem(new TileListItem("Eraser Tool", ERASER_TOOL_CHAR));

			map[Terrain.LEVEL_CODE_CHAR] = Terrain.EDITOR_ICON;
			currentSelection = new TileListItem("Terrain", Terrain.LEVEL_CODE_CHAR);
			currentSelection.select();
			EditorPage.currentTile = currentSelection.getCharCode();
			addItem(currentSelection);

			map[Player.LEVEL_CODE_CHAR] = Player.EDITOR_ICON;
			addItem(new TileListItem("Starting Position", Player.LEVEL_CODE_CHAR));

			map[FinishLine.LEVEL_CODE_CHAR] = FinishLine.EDITOR_ICON;
			addItem(new TileListItem("End Portal", FinishLine.LEVEL_CODE_CHAR));

			map[Collectable.LEVEL_CODE_CHAR] = Collectable.EDITOR_ICON;
			addItem(new TileListItem("Treasure", Collectable.LEVEL_CODE_CHAR));

			map[WoodCrate.LEVEL_CODE_CHAR] = WoodCrate.EDITOR_ICON;
			addItem(new TileListItem("Wooden Crate", WoodCrate.LEVEL_CODE_CHAR));

			map[SteelCrate.LEVEL_CODE_CHAR] = SteelCrate.EDITOR_ICON;
			addItem(new TileListItem("Steel Crate", SteelCrate.LEVEL_CODE_CHAR));

			map[ArrowCrate.LEVEL_CODE_CHAR_RIGHT] = ArrowCrate.EDITOR_ICON_RIGHT;
			addItem(new TileListItem("Arrow Crate Right", ArrowCrate.LEVEL_CODE_CHAR_RIGHT));

			map[ArrowCrate.LEVEL_CODE_CHAR_LEFT] = ArrowCrate.EDITOR_ICON_LEFT;
			addItem(new TileListItem("Arrow Crate Left", ArrowCrate.LEVEL_CODE_CHAR_LEFT));

			map[ArrowCrate.LEVEL_CODE_CHAR_UP] = ArrowCrate.EDITOR_ICON_UP;
			addItem(new TileListItem("Arrow Crate Up", ArrowCrate.LEVEL_CODE_CHAR_UP));

			map[ArrowCrate.LEVEL_CODE_CHAR_DOWN] = ArrowCrate.EDITOR_ICON_DOWN;
			addItem(new TileListItem("Arrow Crate Down", ArrowCrate.LEVEL_CODE_CHAR_DOWN));

			map[DynamiteCrate.LEVEL_CODE_CHAR] = DynamiteCrate.EDITOR_ICON;
			addItem(new TileListItem("Wooden Dynamite Crate", DynamiteCrate.LEVEL_CODE_CHAR));
		}

		private function onClick(evt:MouseEvent):void {
			if (evt.target is TileListItem) {
				currentSelection.deselect();
				var lastChar:String = currentSelection.getCharCode();
				currentSelection = TileListItem(evt.target);
				currentSelection.select();
				EditorPage.currentTile = currentSelection.getCharCode();;
				if (lastChar == TileList.SELECTION_TOOL_CHAR) {
					editor.deselect();
				}
			}
		}

		private function addItem(i:TileListItem):void {
			i.y = nextY;
			nextY += i.height;
			list.addChild(i);
		}
	}
}


