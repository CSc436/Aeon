package org.interguild.editor.grid {
	import flash.display.Sprite;

	import fl.containers.ScrollPane;

	import org.interguild.Aeon;
	import org.interguild.editor.EditorPage;

	public class EditorLevelPane extends Sprite {

		private static const POSITION_X:uint = 0;
		private static const POSITION_Y:uint = 89;

		private static const BORDER_COLOR:uint = 0x222222;
		private static const BORDER_WIDTH:uint = 1;
		private static const BG_COLOR:uint = 0x115867;

		private static const WIDTH:uint = 636;
		private static const HEIGHT:uint = Aeon.STAGE_HEIGHT - POSITION_Y - BORDER_WIDTH;

		private var editor:EditorPage;
		private var tabMan:EditorTabManager;
		private var currentLevel:EditorLevel;

		private var scroll:ScrollPane;

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
			scroll.height = HEIGHT;
			addChild(scroll);

			//init tabs
			tabMan = new EditorTabManager(this);
			addChild(tabMan);
		}

		public function addLevel(level:EditorLevel = null):void {
			tabMan.addTab(level);
		}

		public function get level():EditorLevel {
			return currentLevel;
		}

		/**
		 * Creates a new grid for the container
		 */
		public function set level(lvl:EditorLevel):void {
			if (currentLevel != null) {
				currentLevel.horizontalScrollPosition = scroll.horizontalScrollPosition;
				currentLevel.verticalScrollPosition = scroll.verticalScrollPosition;

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
		}

		/**
		 * resize the level
		 */
		public function resize(rows:int, cols:int):void {
			currentLevel.resize(rows, cols);
		}
	}
}
