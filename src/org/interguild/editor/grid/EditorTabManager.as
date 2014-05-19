package org.interguild.editor.grid {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class EditorTabManager extends Sprite {

		private static const POSITION_Y:uint = 29; //distance above editorLevel
		private static const POSITION_X:uint = 3;

		private static const TAB_WIDTH:uint = 134;

		private var tabs:Array;
		private var currentTab:EditorTab;

		private var levelPane:EditorLevelPane;

		public function EditorTabManager(levelPane:EditorLevelPane) {
			this.levelPane = levelPane;
			this.y = -POSITION_Y;
			this.x = POSITION_X;

			tabs = new Array();
			addTab();
		}

		public function addTab(level:EditorLevel = null):void {
			if (level == null)
				level = new EditorLevel();

			var tab:EditorTab = new EditorTab(level, this);
			tab.x = tabs.length * TAB_WIDTH;
			tab.addEventListener(MouseEvent.CLICK, onTabClick, false, 0, true);
			tabs.push(tab);

			switchToTab(tab);
			addChild(tab);
		}

		private function onTabClick(evt:MouseEvent):void {
			var tab:EditorTab = EditorTab(evt.target);
			switchToTab(tab);
		}

		private function switchToTab(tab:EditorTab):void {
			tab.activate();
			if (currentTab != null)
				currentTab.deactivate();
			currentTab = tab;
			levelPane.level = tab.level;
		}
	}
}
