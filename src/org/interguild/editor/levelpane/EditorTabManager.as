package org.interguild.editor.levelpane {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.interguild.editor.EditorPage;

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
			var cTab:EditorTab = null;
			
			if (level == null){
				level = new EditorLevel();
			}else if(!EditorPage.hasMadeFirstChange){
				cTab = currentTab;
			}

			var tab:EditorTab = new EditorTab(level, this);
			tab.x = tabs.length * TAB_WIDTH;
			tab.doubleClickEnabled = true;
			tab.addEventListener(MouseEvent.CLICK, onTabClick, false, 0, true);
			tab.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false, 0, true);
			tabs.push(tab);

			switchToTab(tab);
			addChild(tab);
			
			if(cTab){
				closeLevel(cTab);
			}
		}
		
		public function updateScrollPane():void{
			levelPane.updateScrollPane();
		}

		private function onTabClick(evt:MouseEvent):void {
			var tab:EditorTab = EditorTab(evt.target);
			switchToTab(tab);
		}
		
		private function onDoubleClick(evt:MouseEvent):void{
			levelPane.showLevelProperties();
		}

		private function switchToTab(tab:EditorTab):void {
			if (currentTab != null)
				currentTab.deactivate();
			tab.activate();
			currentTab = tab;
			addChild(currentTab);//move to top
			levelPane.level = tab.level;
		}

		public function closeLevel(tab:EditorTab = null):void {
			if (tab == null)
				tab = currentTab;
			var index:int = tabs.indexOf(tab);
			if (index == -1) //should hopefully never fire, but should help with debugging
				throw new Error("EditorTabManager.closeLevel() can't close a tab that isn't in its array of tabs.");

			//TODO prompt to save

			tabs.splice(index, 1);
			removeChild(tab);
			if (tabs.length == 0) {
				//if no more levels to switch to
				levelPane.level = null; //create a new level
			} else {
				//move tabs to the left
				for (var i:int = index; i < tabs.length; i++) {
					EditorTab(tabs[i]).x -= TAB_WIDTH;
				}
				if (currentTab == tab) {
					if (index >= tabs.length) {
						index--;
					}
					switchToTab(tabs[index]);
				}
			}
		}

		public function closeAllLevels():void {
			var n:uint = tabs.length;
			while (n > 0) {
				closeLevel();
				n--;
			}
		}
	}
}
