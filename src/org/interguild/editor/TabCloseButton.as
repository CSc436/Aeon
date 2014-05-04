package org.interguild.editor {
	
	public class TabCloseButton extends TabCloseButtonButton {
		
		private var tNum:int;
		public function TabCloseButton() {
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
