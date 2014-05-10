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
		public var isCtrlO:Boolean = false;
		public var isCtrlY:Boolean = false;
		public var isCtrlZ:Boolean = false;
		public var isCtrlS:Boolean = false;
		public var isKeyEsc:Boolean = false;
		
		private var openCallback:Function;
		private var saveCallback:Function;
		private var undoCallback:Function;
		private var redoCallback:Function;
		private var spacebarCallback:Function;
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
				if(evt.ctrlKey){
					switch (evt.keyCode) {
						
						case 78://ctrl+n
							trace('hi')
							break;
						case 79://ctrl+o
							if(openCallback)
									openCallback();
							isCtrlO = true;
							break;
						
						case 83://ctrl+s
							if(saveCallback)
								saveCallback();
							isCtrlS = true;
							break;
						case 89://ctrl+y
							
							if(redoCallback)
								redoCallback();
							isCtrlY = true;
							break;
						case 90://ctrl+z
							if(undoCallback)
								undoCallback();
							isCtrlZ= true;
							break;
						
						case 27: //Esc key
							if(escapeCallback && !isKeyEsc)
								escapeCallback();
							isKeyEsc = true;
							break;
					}
				}
					if (menuCallback)
						menuCallback(evt.keyCode);
			}
			
			private function onKeyUp(evt:KeyboardEvent):void {
				switch (evt.keyCode) {
					case 78://ctrl+n
						trace('key n up')
						break;
					
					case 79://ctrl+o
						isCtrlO = false;
						break;
					case 83://ctrl+s
						isCtrlS = false;
						break;
					case 90://ctrl+z
						isCtrlZ = false;
						break;
					case 89://ctrl+Y
						isCtrlY = false;
						break;
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
			
			public function addOpenLevelCallback(cb:Function):void {
				openCallback = cb;
			}
			
			public function addSaveLevelCallback(cb:Function):void {
				saveCallback = cb;
			}
			
			public function addUndoLevelCallback(cb:Function):void {
				undoCallback = cb;
			}
			
			public function addRedoLevelCallback(cb:Function):void {
				redoCallback = cb;
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

