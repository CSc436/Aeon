package org.interguild.editor {
	
	public class TabButton extends TabButtonButton {
		
		private var tNum:int;
		public function TabButton() {
			super();
		}
		
		public function get tabNum():int{
			return tNum;
		}
		
		public function set tabNum(s:int):void{
			tNum = s;
		}
	}
	
}
