package org.interguild {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.utils.Timer;

	public class KeyMan {

		private static var instance:KeyMan;

		public static function getMe():KeyMan {
			if (instance == null) {
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
		public var isKeyR:Boolean = false;

		public var walkingSound:Sound;
		public var walkSoundPlaying:Boolean = false;
		public var timer:Timer;

		public var spacebarCallback:Function;
		private var escapeCallback:Function;
		private var restartCallback:Function;
		private var menuCallback:Function;
		CONFIG::DEBUG {
			private var debugToggleCallback:Function;
			private var slowDownToggleCallback:Function;
			private var slowDownNextCallback:Function;
		}

		public function KeyMan(stage:Stage) {
			instance = this;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
		}

		public function forgetMe():void {
			spacebarCallback = null;
			escapeCallback = null;
			restartCallback = null;
		}

		private function onKeyDown(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case 27: //Esc key
					if (escapeCallback && !isKeyEsc)
						escapeCallback();
					isKeyEsc = true;
					break;
				case 82: // R key
					if (restartCallback && !isKeyR)
						restartCallback();
					isKeyR = true;
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
					if (spacebarCallback)
						spacebarCallback();
					break;
			}
			CONFIG::DEBUG {
				switch (evt.keyCode) {
					case 66: //b key
						if (debugToggleCallback)
							debugToggleCallback();
						break;
					case 191: // "/" or "?" key
						if (slowDownToggleCallback)
							slowDownToggleCallback();
						break;
					case 190: // "." or ">" key
						if (slowDownNextCallback)
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
				case 82: // R key
					isKeyR = false;
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

		public function resumeFromButton():void {
			if (escapeCallback)
				escapeCallback();
		}

		public function addEscapeListener(f:Function):void {
			escapeCallback = f;
		}

		public function addSpacebarListener(cb:Function):void {
			spacebarCallback = cb;
		}

		public function addRestartListener(f:Function):void {
			restartCallback = f;
		}

		public function addMenuCallback(cb:Function):void {
			menuCallback = cb;
		}

		CONFIG::DEBUG {
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
