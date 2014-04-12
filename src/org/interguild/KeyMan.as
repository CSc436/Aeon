package org.interguild {
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
		public var isKeyEsc:Boolean = false;
		CONFIG::DEBUG {
			public var isDebugKey:Boolean = false;
			public var isClearKey:Boolean = false;
		}
		
		public var spacebarCallback:Function;
		private var escapeCallback:Function;
		
		private var menuCallback:Function;

		public function KeyMan(stage:Stage) {
			instance = this;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
		}

		private function onKeyDown(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case 27: //Esc key
					if(!isKeyEsc)
						isKeyEsc = true;
					else
						isKeyEsc = false;
					if(escapeCallback)
						escapeCallback();
					break;
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
					if(spacebarCallback)
						spacebarCallback(false);
					break;
			}
			CONFIG::DEBUG {
				if(evt.keyCode == 66)//b key
					isDebugKey = true;
				else if(evt.keyCode == 78)//n key
					isClearKey = true;
			}
			if(menuCallback)
				menuCallback(evt.keyCode);
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
			CONFIG::DEBUG {
				if(evt.keyCode == 66) //b key
					isDebugKey = false;
				else if(evt.keyCode == 78)//n key
					isClearKey = false;
			}
		}
		
		public function resumeFromButton():void {
			if(!isKeyEsc)
				isKeyEsc = true;
			else
				isKeyEsc = false;
			if(escapeCallback)
				escapeCallback();
		}
		
		public function resetEscKey():void {
			isKeyEsc = false;
		}
		
		public function addEscapeListener(f:Function):void {
			escapeCallback = f;
		}
		
		public function addSpacebarListener(cb:Function):void{
			spacebarCallback = cb;
		}
		
		public function removeSpacebarListener():void {
			spacebarCallback = null;
		}
		
		public function addMenuCallback(cb:Function):void{
			menuCallback = cb;
		}
	}
}
