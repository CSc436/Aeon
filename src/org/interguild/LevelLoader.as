package org.interguild {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.interguild.tiles.Terrain;

	/**
	 * Takes in a level encoding and constructs a level.
	 */
	public class LevelLoader {

		private static const LOOPS_PER_TICK:uint = 250;
		private static const TILE_WIDTH:uint = 32;
		private static const TILE_HEIGHT:uint = 32;

		private var level:Level;

		private var code:String;
		private var codeLength:uint;
		private var timer:Timer;

		public function LevelLoader(file:String, lvl:Level) {
			level = lvl;

			code = file;
			codeLength = code.length;

			timer = new Timer(20);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}

		public function start():void {
			timer.start();
		}

		private var i:uint = 0;
		private var px:int = 0;
		private var py:int = 0;
		private var prevChar:String;

		/**
		 * We use a timer so that we can interrupt the loading code every once in
		 * a while in order to display progress to the screen.
		 *
		 * We use a for loop inside the timer so that we can get as much work done
		 * for tick as possible. Amount of work done is determined by LOOPS_PER_TICK,
		 * so we'll have to play around with its value when optimizing.
		 */
		private function onTimer(evt:TimerEvent):void {
			for (var j:uint = 0; j < LOOPS_PER_TICK && i < codeLength; j++, i++) {
				var curChar:String = code.charAt(i);
				//this switch only handles special characters.
				//the default case handles non-special characters.
				switch (curChar) {
					case " ":
						px += TILE_WIDTH;
						break;
					/*
					 * Not all operating systems write the end-of-line character
					 * in the same way. So the following is to compensate for that.
					 */
					case "\r":
						var i1:uint = i + 1;
						//if sequence of "\r\n" then skip the "\n" character
						if (i1 < codeLength && code.charAt(i + 1) == "\n") {
							i++;
						} //then treat it as a new line:
					case "\n":
						px = 0;
						py += TILE_HEIGHT;
						break;
					default:
						createObject(curChar, px, py);
						px += TILE_WIDTH;
						break;
				} //end switch
			} //end for loop

			//if done loading
			if (i == codeLength) {
				timer.stop();
				level.startGame();
			}
		}

		/**
		 * Parses the non-special characters of the level encoding
		 */
		private function createObject(curChar:String, px:int, py:int):void {
			var tile:Sprite;
			switch (curChar) {
				case "#": //Player
					level.setPlayer(px, py);
					break;
				case "x": //Terrain
					tile = new Terrain(px, py);
					level.createTile(tile);
					break;
				default:
					trace("Unknown level code character: " + curChar);
					break;
			}
		}
	}
}
