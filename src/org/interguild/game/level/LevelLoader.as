package org.interguild.game.level {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import org.interguild.Aeon;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.SteelCrate;
	import org.interguild.game.tiles.Terrain;
	import org.interguild.game.tiles.WoodCrate;

	/**
	 * Takes in a level encoding and constructs a level.
	 */
	public class LevelLoader {

		private static const LOOPS_PER_TICK:uint = 250;

		private var level:Level;

		private var file:String;
		private var code:String; //the level encoding
		private var codeLength:uint;
		private var timer:Timer;
		
		private var progress:LevelProgressBar;

		/**
		 * TODO: if isEditor==true, construct LevelEdit
		 */
		public function LevelLoader(fileName:String, lvl:Level, progressBar:LevelProgressBar) {
			level = lvl;
			file = fileName;
			progress = progressBar;
			//don't start loading until start() is called
		}

		/**
		 * First loads in the file. Then after it's loaded,
		 * start parsing the level encoding.
		 * When completed, will call the level's startGame()
		 */
		public function start():void {
			var getFile:URLLoader = new URLLoader();
			getFile.addEventListener(Event.COMPLETE, onFileLoad);
			getFile.load(new URLRequest(file));
		}

		/**
		 * Called after the test level file has been loaded.
		 */
		private function onFileLoad(evt:Event):void {
			code = evt.target.data;
			codeLength = code.length;

			//get title
			var eol:int = code.indexOf("\n");
			level.setTitle(code.substr(0, eol));
			code = code.substr(eol + 1);
			
			//get dimensions
			eol = code.indexOf("\n");
			var dimensionsLine:String = code.substr(0, eol);
			var ix:int = dimensionsLine.indexOf("x");
			var lvlWidth:Number = Number(dimensionsLine.substr(0, ix));
			var lvlHeight:Number = Number(dimensionsLine.substr(ix + 1));
			level.setLevelSize(lvlWidth, lvlHeight);
			code = code.substr(eol + 1);
			
			timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
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
				parseChar(curChar);
			}

			//if done loading
			if (i == codeLength) {
				timer.stop();
				level.startGame();
			} else {
				progress.setProgress(i / codeLength);
			}
		}

		private function parseChar(curChar:String):void {
			//this switch only handles special chars
			switch (curChar) {
				case " ":
					px += Aeon.TILE_WIDTH;
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
					py += Aeon.TILE_HEIGHT;
					break;
				case "=":
					var number:String = "";
					//first get all the digits of the number
					var nextChar:String = code.charAt(i + 1);
					while (!isNaN(Number(nextChar)) && i + 1 < codeLength) {
						number += nextChar;
						i++;
						nextChar = code.charAt(i + 1);
						switch (nextChar) {
							case " ":
							case "\r":
							case "\n":
								nextChar = "x"; //definitely NaN
								break;
						}
					}
					var n:Number = Number(number) - 1;
					if (!isNaN(n)) {
						//then create N tiles
						for (var k:uint = 0; k < n; k++) {
							parseChar(prevChar);
						}
					}
					break;
				default:
					createObject(curChar, px, py);
					px += Aeon.TILE_WIDTH;
					break;
			}
			prevChar = curChar;
		}

		/**
		 * Parses the non-special characters of the level encoding
		 */
		private function createObject(curChar:String, px:int, py:int):void {
			//if off the map, do nothing
			if(px > level.pixelWidth || py > level.pixelHeight)
				return;
			
			var tile:CollidableObject;
			switch (curChar) {
				case "#": //Player
					level.setPlayer(px, py);
					break;
				case "x": //Terrain
					tile = new Terrain(px, py);
					level.createCollidableObject(tile, false);
					break;
				case "w": //WoodCrate
					tile = new WoodCrate(px, py);
					level.createCollidableObject(tile, false);
					break;
				case "s": //SteelCrate
					tile = new SteelCrate(px, py);
					level.createCollidableObject(tile, false);
				default:
					trace("Unknown level code character: '" + curChar+"'");
					break;
			}
		}
	}
}
