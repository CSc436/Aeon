package org.interguild.game {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	public class KeyMan {
		
		private static var instance:KeyMan;
		
		public static function getMe():KeyMan{
			if(instance==null){
				throw new Error("You somehow called KeyMan.getMe() before Aeon.as did. How did you do that??");
			}
			return instance;
		}

		public var isKeyRight:Boolean = false;
		public var isKeyUp:Boolean = false;
		public var isKeyLeft:Boolean = false;
		public var isKeyDown:Boolean = false;
		public var isKeySpace:Boolean = false;

		public function KeyMan(stage:Stage) {
			instance = this;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
		}

		private function onKeyDown(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case 39: //right arrow key
					isKeyRight = true;
					break;
				case 40: //down arrow key
					isKeyDown = true;
					break;
				case 38: //up arrow key
					isKeyUp = true;
					break;
				case 37: //left arrow key
					isKeyLeft = true;
					break;
				case 32: //spacebar
					isKeySpace = true;
					break;
			}
		}

		private function onKeyUp(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case 39: //right arrow key
					isKeyRight = false;
					break;
				case 40: //down arrow key
					isKeyDown = false;
					break;
				case 38: //up arrow key
					isKeyUp = false;
					break;
				case 37: //left arrow key
					isKeyLeft = false;
					break;
				case 32: //spacebar
					isKeySpace = false;
					break;
			}
		}
	}
}