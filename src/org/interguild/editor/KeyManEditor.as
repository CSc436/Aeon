package org.interguild.editor {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	public class KeyManEditor {
		
		private static var instance:KeyManEditor;
		
		public static function getMe():KeyManEditor {
			if (instance == null) {
				throw new Error("You somehow called KeyMan.getMe() before Aeon.as did. How did you do that??");
			}
			return instance;
		}
		
		public var isKeyEsc:Boolean = false;
		
		public var spacebarCallback:Function;
		private var escapeCallback:Function;
		private var menuCallback:Function;
		CONFIG::DEBUG{
			private var debugToggleCallback:Function;
			private var slowDownToggleCallback:Function;
			private var slowDownNextCallback:Function;
		}
			
			public function KeyManEditor(stage:Stage) {
				instance = this;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
			}
			
			private function onKeyDown(evt:KeyboardEvent):void {
				switch (evt.keyCode) {
					case 27: //Esc key
						if(escapeCallback && !isKeyEsc)
							escapeCallback();
						isKeyEsc = true;
						break;
				}
				CONFIG::DEBUG {
					switch(evt.keyCode){
						case 66: //b key
							if(debugToggleCallback)
								debugToggleCallback();
							break;
						case 191: // "/" or "?" key
							if(slowDownToggleCallback)
								slowDownToggleCallback();
							break;
						case 190: // "." or ">" key
							if(slowDownNextCallback)
								slowDownNextCallback();
							break;
					}
				}
					if (menuCallback)
						menuCallback(evt.keyCode);
			}
			
			private function onKeyUp(evt:KeyboardEvent):void {
				switch (evt.keyCode) {
					case 27: //Esc key
						isKeyEsc = false;
						break;
				}
			}
			
			public function resumeFromButton():void {
				if(escapeCallback)
					escapeCallback();
			}
			
			public function addEscapeListener(f:Function):void {
				escapeCallback = f;
			}
			
			public function addSpacebarListener(cb:Function):void {
				spacebarCallback = cb;
			}
			
			public function addMenuCallback(cb:Function):void {
				menuCallback = cb;
			}
			
			CONFIG::DEBUG{
				public function addSlowdownListeners(onToggle:Function, onNext:Function):void {
					slowDownToggleCallback = onToggle;
					slowDownNextCallback = onNext;
				}
				
				public function addDebugListeners(onToggle:Function):void {
					debugToggleCallback = onToggle;
				}
			}
	}
}

