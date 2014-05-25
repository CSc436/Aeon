package org.interguild.editor.levelpane {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import fl.containers.ScrollPane;
	
	import org.interguild.Aeon;
	import org.interguild.editor.EditorPage;

	public class EditorLevelPane extends Sprite {

		private static const POSITION_X:uint = 0;
		private static const POSITION_Y:uint = 89;

		private static const BORDER_COLOR:uint = 0x222222;
		private static const BORDER_WIDTH:uint = 1;
		private static const BG_COLOR:uint = 0x115867;

		private static const HINTS_TEXT_HEIGHT:uint = 20;
		private static const WIDTH:uint = 636;
		private static const HEIGHT:uint = Aeon.STAGE_HEIGHT - POSITION_Y - BORDER_WIDTH;

		private var editor:EditorPage;
		private var tabMan:EditorTabManager;
		private var currentLevel:EditorLevel;

		private var scroll:ScrollPane;
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

		public function addLevel(level:EditorLevel = null):void {
			tabMan.addTab(level);
		}

		public function closeLevel():void {
			tabMan.closeLevel();
		}

		public function closeAllLevels():void {
			tabMan.closeAllLevels();
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

			//remember that level's scroll position
			if (currentLevel != null) {
				currentLevel.horizontalScrollPosition = scroll.horizontalScrollPosition;
				currentLevel.verticalScrollPosition = scroll.verticalScrollPosition;

				//can only be set if scrollpane used to have a currentLevel
				scroll.horizontalScrollPosition = lvl.horizontalScrollPosition;
				scroll.verticalScrollPosition = lvl.verticalScrollPosition;
			}
			currentLevel = lvl;
			currentLevel.x = 1;
			currentLevel.y = 1;

			var container:Sprite = new Sprite();
			container.addChild(currentLevel);
			//if the editor is smaller than the scrollpane, do this so that mouse wheel events still work nicely
			if (container.width < WIDTH) {
				container.graphics.beginFill(0, 0);
				container.graphics.drawRect(0, 0, WIDTH - 16, currentLevel.height);
				container.graphics.endFill();
			}
			//add a border to the top and left sides of the grid
			container.graphics.beginFill(EditorCell.LINE_COLOR);
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
		}

		private static const ZOOM_MIN:Number = 10;
		private static const ZOOM_SUPER_MIN:Number = 1;
		private static const ZOOM_MAX:Number = 100;
		private static const ZOOM_DELTA:Number = 10;
		private static const ZOOM_SUPER_DELTA:Number = 1;

		private var zoomLevel:uint = 100;


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
			var container:Sprite = Sprite(scroll.source);
			container.scaleX = container.scaleY = zoomLevel / 100;
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

		public function resize(rows:int, cols:int):void {
			currentLevel.resize(rows, cols);
		}
	}
}
