package org.interguild.editor.tilelist {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.editor.EditorPage;
	import org.interguild.editor.levelpane.EditorLevel;
	import org.interguild.game.Player;
	import org.interguild.game.tiles.*;

	public class TileList extends Sprite {

		private static const POSITION_X:uint = 655;
		private static const POSITION_Y:uint = 89;

		private static const BORDER_PADDING:uint = 0;
		private static const SCROLLBAR_WIDTH:uint = 15;

		//TileListItem references this:
		internal static const MASK_WIDTH:uint = Aeon.STAGE_WIDTH - POSITION_X - SCROLLBAR_WIDTH;
		private static const MASK_HEIGHT:uint = Aeon.STAGE_HEIGHT - POSITION_Y; // - (2 * PADDING_Y);

//		private static const BG_COLOR:uint = 0x115867;
		private static const BG_CORNER_RADIUS:uint = 10;
//		private static const BG_WIDTH:uint = MASK_WIDTH + (BG_CORNER_RADIUS * 2);
//		private static const BG_HEIGHT:uint = MASK_HEIGHT + (BG_CORNER_RADIUS * 2);

		public static const SELECTION_TOOL_CHAR:String = "SELECTION";
		public static const ERASER_TOOL_CHAR:String = " ";

		private static var map:Object = new Object();
		private static var terrainItem:TileListItem;

		public static function getIcon(charCode:String):BitmapData {
			return map[charCode];
		}

		public static function setTerrainType(id:uint):void {
			var img:BitmapData = new BitmapData(32, 32);
			img.copyPixels(Assets.getTerrainImage(id), new Rectangle(0, 0, 32, 32), new Point(0, 0));

			map[Terrain.LEVEL_CODE_CHAR] = img;
			EditorLevel.forceChange = true;
			if (terrainItem) {
				terrainItem.changeIcon(img);
			}
		}

		private var editor:EditorPage;

		private var list:Sprite;
		private var currentSelection:TileListItem;

		//used for adding tiles to the list
		private var nextY:uint = 0;
		private var lastItem:TileListItem;

		private var scrollpane:ScrollPane
		private var handToolRegion:Sprite;
		private var lastClickY:Number;

		public function TileList(editor:EditorPage) {
			this.editor = editor;
			x = POSITION_X;
			y = POSITION_Y;

			//init bg
//			graphics.beginFill(BG_COLOR);
//			graphics.drawRect(0, 0, BG_WIDTH, BG_HEIGHT);
//			graphics.endFill();

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
			scrollpane = new ScrollPane();
			scrollpane.source = list;
			scrollpane.width = MASK_WIDTH + SCROLLBAR_WIDTH;
			scrollpane.height = MASK_HEIGHT;
			scrollpane.horizontalScrollPolicy = ScrollPolicy.OFF;
			scrollpane.verticalScrollBar.pageScrollSize = 100;
			addChild(scrollpane);

			//setup rounded corner overlay
			var corner:Sprite = new Sprite();
			var bmd:BitmapData = new BitmapData(BG_CORNER_RADIUS, BG_CORNER_RADIUS);
			bmd.copyPixels(editor.getBG(), new Rectangle(x, y, BG_CORNER_RADIUS, BG_CORNER_RADIUS), new Point(0, 0));
			corner.graphics.beginBitmapFill(bmd);
			corner.graphics.moveTo(0, 0);
			corner.graphics.lineTo(BG_CORNER_RADIUS, 0);
			corner.graphics.curveTo(0, 0, 0, BG_CORNER_RADIUS);
			corner.graphics.lineTo(0, 0);
			corner.graphics.endFill();
			addChild(corner);

			//setup click-and-drag region
			handToolRegion = new Sprite();
			handToolRegion.graphics.beginFill(0, 0);
			handToolRegion.graphics.drawRect(0, 0, list.width, list.height);
			handToolRegion.graphics.endFill();
			handToolRegion.visible = false;
			handToolRegion.addEventListener(MouseEvent.MOUSE_DOWN, onDragMouseDown, false, 0, true);
			list.addChild(handToolRegion);
		}

		private function initList():void {
			map[SELECTION_TOOL_CHAR] = Assets.SELECTION_TOOL_SPRITE;
			addItem(new TileListItem("Selection Tool", SELECTION_TOOL_CHAR));

			map[ERASER_TOOL_CHAR] = Assets.ERASER_TOOL_SPRITE;
			addItem(new TileListItem("Eraser Tool", ERASER_TOOL_CHAR));

			setTerrainType(0);
			currentSelection = new TileListItem("Terrain", Terrain.LEVEL_CODE_CHAR);
			currentSelection.select();
			EditorPage.currentTile = currentSelection.getCharCode();
			terrainItem = currentSelection;
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

			map[ArrowWoodCrate.LEVEL_CODE_CHAR_RIGHT] = ArrowWoodCrate.EDITOR_ICON_RIGHT;
			addItem(new TileListItem("Arrow Crate Right", ArrowWoodCrate.LEVEL_CODE_CHAR_RIGHT));

			map[ArrowWoodCrate.LEVEL_CODE_CHAR_LEFT] = ArrowWoodCrate.EDITOR_ICON_LEFT;
			addItem(new TileListItem("Arrow Crate Left", ArrowWoodCrate.LEVEL_CODE_CHAR_LEFT));

			map[ArrowWoodCrate.LEVEL_CODE_CHAR_UP] = ArrowWoodCrate.EDITOR_ICON_UP;
			addItem(new TileListItem("Arrow Crate Up", ArrowWoodCrate.LEVEL_CODE_CHAR_UP));

			map[ArrowWoodCrate.LEVEL_CODE_CHAR_DOWN] = ArrowWoodCrate.EDITOR_ICON_DOWN;
			addItem(new TileListItem("Arrow Crate Down", ArrowWoodCrate.LEVEL_CODE_CHAR_DOWN));

			map[DynamiteWoodCrate.LEVEL_CODE_CHAR] = DynamiteWoodCrate.EDITOR_ICON;
			addItem(new TileListItem("Wooden Dynamite Crate", DynamiteWoodCrate.LEVEL_CODE_CHAR));
			
			map[DynamiteSteelCrate.LEVEL_CODE_CHAR] = DynamiteSteelCrate.EDITOR_ICON;
			addItem(new TileListItem("Steel Dynamite Crate", DynamiteSteelCrate.LEVEL_CODE_CHAR));
		}

		private function onClick(evt:MouseEvent):void {
			editor.deselect();
			if (evt.target is TileListItem) {
				currentSelection.deselect();
				var lastChar:String = currentSelection.getCharCode();
				currentSelection = TileListItem(evt.target);
				currentSelection.select();
				var curChar:String = currentSelection.getCharCode();
				EditorPage.currentTile = curChar;
			}
		}

		private function addItem(i:TileListItem):void {
			if (lastItem != null)
				lastItem.drawBottomBorder();
			lastItem = i;

			i.y = nextY;
			nextY += i.height;
			list.addChild(i);
		}

		/**
		 * When spacebar is pressed, allow user to click-and-drag to scroll
		 * through the level.
		 */
		public function set handToolEnabled(b:Boolean):void {
			handToolRegion.visible = b;
		}

		private function onDragMouseDown(evt:MouseEvent):void {
			lastClickY = evt.stageY;
			stage.addEventListener(Event.ENTER_FRAME, onDrag, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDragMouseUp, false, 0, true);
		}

		private function onDragMouseUp(evt:MouseEvent):void {
			stage.removeEventListener(Event.ENTER_FRAME, onDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
		}

		private function onDrag(evt:Event):void {
			var curClickY:Number = stage.mouseY;
			var delta:Number = curClickY - lastClickY;

			scrollpane.verticalScrollPosition -= delta;

			lastClickY = curClickY;
		}
	}
}


