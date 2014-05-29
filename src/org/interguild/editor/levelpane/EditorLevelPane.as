package org.interguild.editor.levelpane {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;

	import fl.containers.ScrollPane;

	import org.interguild.Aeon;
	import org.interguild.editor.EditorPage;
	import org.interguild.editor.tilelist.TileList;
	import org.interguild.game.level.LevelBackground;

	public class EditorLevelPane extends Sprite {

		private static const POSITION_X:uint = 0;
		private static const POSITION_Y:uint = 89;

		private static const BORDER_COLOR:uint = 0x222222;
		private static const BORDER_WIDTH:uint = 1;
		private static const BG_COLOR:uint = 0x115867;

		private static const HINTS_TEXT_HEIGHT:uint = 20;
		private static const WIDTH:uint = 636;
		private static const HEIGHT:uint = Aeon.STAGE_HEIGHT - POSITION_Y - BORDER_WIDTH;

		private static const ZOOM_DEFAULT:uint = 100;
		private static const ZOOM_MIN:uint = 10;
		private static const ZOOM_SUPER_MIN:uint = 1;
		private static const ZOOM_MAX:uint = 100;
		private static const ZOOM_DELTA:uint = 10;
		private static const ZOOM_SUPER_DELTA:uint = 1;

		private var zoomLevel:uint = 100;

		private var editor:EditorPage;
		private var tabMan:EditorTabManager;
		private var currentLevel:EditorLevel;

		private var scroll:ScrollPane;
		private var levelBG:Sprite;
		private var levelBGID:int = -1;
		private var lastClick:Point;
		private var handToolRegion:Sprite;

		public function EditorLevelPane(editor:EditorPage) {
			this.editor = editor;

			this.x = POSITION_X;
			this.y = POSITION_Y;

			//init bg
			graphics.beginFill(BORDER_COLOR);
			graphics.drawRect(0, 0, WIDTH + (2 * BORDER_WIDTH), HEIGHT + (2 * BORDER_WIDTH));
			graphics.endFill();
			graphics.beginFill(BG_COLOR);
			graphics.drawRect(BORDER_WIDTH, BORDER_WIDTH, WIDTH, HEIGHT);
			graphics.endFill();

			//init level background
			levelBG = new Sprite();
			levelBG.x = BORDER_WIDTH;
			levelBG.y = BORDER_WIDTH;
			addChild(levelBG);

			//init scrollpane
			scroll = new ScrollPane();
			scroll.x = BORDER_WIDTH;
			scroll.y = BORDER_WIDTH;
			scroll.width = WIDTH;
			scroll.height = HEIGHT - HINTS_TEXT_HEIGHT;
			addChild(scroll);

			//init tabs
			tabMan = new EditorTabManager(this);
			addChild(tabMan);
		}

		public function updateScrollPane():void {
			level = currentLevel;
		}

		public function addLevel(level:EditorLevel = null):void {
			tabMan.addTab(level);
		}

		public function closeLevel():void {
			tabMan.closeLevel();
		}

		public function closeAllLevels():void {
			tabMan.closeAllLevels();
		}

		public function showLevelProperties():void {
			editor.showLevelProperties();
		}

		public function renameLevel(s:String):void {
			level.title = s;
		}

		public function get level():EditorLevel {
			return currentLevel;
		}

		/**
		 * Creates a new grid for the container
		 */
		public function set level(lvl:EditorLevel):void {
			if (lvl == null) {
				addLevel();
				return;
			}

			var doZoom:Boolean = false;
			//remember that level's scroll position
			if (currentLevel != null) {
				doZoom = true;
				currentLevel.horizontalScrollPosition = scroll.horizontalScrollPosition;
				currentLevel.verticalScrollPosition = scroll.verticalScrollPosition;
				currentLevel.zoomLevel = zoomLevel;

				//can only be set if scrollpane used to have a currentLevel
				scroll.horizontalScrollPosition = lvl.horizontalScrollPosition;
				scroll.verticalScrollPosition = lvl.verticalScrollPosition;
				zoomLevel = lvl.zoomLevel;
			}
			currentLevel = lvl;
			currentLevel.x = 1;
			currentLevel.y = 1;
			TileList.setTerrainType(currentLevel.terrainType);
			this.backgroundType = currentLevel.backgroundType;

			var container:Sprite = new Sprite();
			container.addChild(currentLevel);
			//if the editor is smaller than the scrollpane, do this so that mouse wheel events still work nicely
			if (container.width < WIDTH) {
				container.graphics.beginFill(0, 0);
				container.graphics.drawRect(0, 0, WIDTH - 16, currentLevel.height);
				container.graphics.endFill();
			}
			//add a border to the top and left sides of the grid
			container.graphics.beginFill(EditorCell.LINE_COLOR, EditorCell.LINE_ALPHA);
			container.graphics.drawRect(0, 0, currentLevel.width + 1, 1);
			container.graphics.drawRect(0, 0, 1, currentLevel.height + 1);
			container.graphics.endFill();
			scroll.source = container;

			//setup click-and-drag stuff
			handToolRegion = new Sprite();
			handToolRegion.graphics.beginFill(0, 0);
			handToolRegion.graphics.drawRect(0, 0, container.width, container.height);
			handToolRegion.graphics.endFill();
			handToolRegion.visible = false;
			handToolRegion.addEventListener(MouseEvent.MOUSE_DOWN, onDragMouseDown, false, 0, true);
			container.addChild(handToolRegion);

			//remember zoom value
			if (doZoom)
				zoomTo(currentLevel.zoomLevel);
		}

		public function get backgroundType():uint {
			return currentLevel.backgroundType;
		}

		public function set backgroundType(id:uint):void {
			if (levelBGID == id)
				return;
			levelBGID = id;

			var bg:BitmapData = LevelBackground.getBackground(id);
			var matrix:Matrix = new Matrix();

			var scaleH:Number = scroll.width / bg.width;
			var scaleV:Number = scroll.height / bg.height;
			var newWidth:Number;
			var newHeight:Number;
			if (scaleV < scaleH) {
				matrix.scale(scaleV, scaleV);
				newWidth = bg.width * scaleV;
				newHeight = bg.height * scaleV;
			} else {
				matrix.scale(scaleH, scaleH);
				newWidth = bg.width * scaleH;
				newHeight = bg.height * scaleH;
			}
			var bd:BitmapData = new BitmapData(newWidth, newHeight);
			bd.draw(bg, matrix);

			levelBG.graphics.clear();
			levelBG.graphics.beginBitmapFill(bd);
			levelBG.graphics.drawRect(0, 0, scroll.width, scroll.height);
			levelBG.graphics.endFill();
			levelBG.graphics.beginFill(BG_COLOR);
			var scrollBarWidth:Number = scroll.verticalScrollBar.width;
			levelBG.graphics.drawRect(scroll.width - scrollBarWidth, scroll.height - scrollBarWidth, scrollBarWidth, scrollBarWidth);
			levelBG.graphics.endFill();
		}

		public function zoom(zoomIn:Boolean):void {
			if (zoomIn && zoomLevel < ZOOM_MIN) {
				zoomLevel += ZOOM_SUPER_DELTA;
			} else if (zoomIn && zoomLevel < ZOOM_MAX) {
				zoomLevel += ZOOM_DELTA;
			} else if (!zoomIn && zoomLevel > ZOOM_MIN) {
				zoomLevel -= ZOOM_DELTA;
			} else if (!zoomIn && zoomLevel > ZOOM_SUPER_MIN) {
				zoomLevel -= ZOOM_SUPER_DELTA;
			}
			zoomTo(zoomLevel);
		}

		private function zoomTo(n:uint):void {
			var container:Sprite = Sprite(scroll.source);
			container.scaleX = container.scaleY = n / 100;
			scroll.source = container;
		}

		/**
		 * When spacebar is pressed, allow user to click-and-drag to scroll
		 * through the level.
		 */
		public function set handToolEnabled(b:Boolean):void {
			handToolRegion.visible = b;
		}

		private function onDragMouseDown(evt:MouseEvent):void {
			lastClick = new Point(evt.stageX, evt.stageY);
			stage.addEventListener(Event.ENTER_FRAME, onDrag, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDragMouseUp, false, 0, true);
		}

		private function onDragMouseUp(evt:MouseEvent):void {
			stage.removeEventListener(Event.ENTER_FRAME, onDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
		}

		private function onDrag(evt:Event):void {
			var curClick:Point = new Point(stage.mouseX, stage.mouseY);
			var delta:Point = new Point(curClick.x - lastClick.x, curClick.y - lastClick.y);

			scroll.horizontalScrollPosition -= delta.x;
			scroll.verticalScrollPosition -= delta.y;

			lastClick = curClick;
		}
	}
}
