package org.interguild.loader {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import org.interguild.game.level.LevelBackground;
	import org.interguild.game.tiles.Terrain;

	public class Loader {

		private static const INVALID_FILE:String = "Invalid Level Code.";
		private static const INVALID_DIMENSIONS_FORMAT:String = "Invalid Level Dimensions.\nThey should in the form 30x30, for example.\nYour file had: ";
		private static const INVALID_DIMENSIONS_NUMBERS:String = "Invalid Level Dimensions.\nThey must be positive integer values.\nYour file had: ";
		private static const INVALID_TERRAIN:String = "Invalid Terrain Type: ";
		private static const INVALID_BACKGROUND:String = "Invalid Background Type: ";

		private static const LOOPS_PER_TICK:uint = 250;

		private var code:String; //the level encoding in the file
		private var codeLength:uint;
		private var timer:Timer;

		protected var initializedCallback:Function;
		private var progressCallback:Function;
		private var errorCallback:Function;
		private var loadingCompleteCallback:Function;
		private var levelParsedCallback:Function;

		protected var title:String;
		protected var levelWidth:int;
		protected var levelHeight:int;
		protected var terrainType:uint;
		protected var backgroundType:uint;
		protected var encoding:String;

		private var errors:Array;

		public function Loader() {
		}

		/*******************************
		 * LISTENER/CALLBACK FUNCTIONS *
		 *******************************/

		/**
		 * If you want to display the progress of level loading.
		 *
		 * For the callback method, you'll typically pass in
		 * 		LevelProgressBar.setProgress;
		 *
		 * Your callback function must have this format:
		 * 		myFunctionName(percent:Number);
		 */
		public function addProgressListener(onProgress:Function):void {
			progressCallback = onProgress;
		}

		/**
		 * This function is how we will pass you the Level object.
		 * This is called when we first initialized the level, which
		 * is usually before we begin to parse the level code to
		 * construct the level. Giving you the reference to the Level
		 * object at this stage allows as to pass you some info, such
		 * as the level name, dimensions, and level code, so that you
		 * can use these while the level is being constructed.
		 *
		 * If you're using LevelLoader, your callback function must
		 * have this format:
		 * 		myFunctionName(level:Level);
		 *
		 * If you're using EditorLoader, your callback function must
		 * have this format:
		 * 		myFunctionName(title:String, grid:EditorGrid);
		 */
		public function addInitializedListener(cb:Function):void {
			initializedCallback = cb;
		}

		/**
		 * If an error happens, we'll pass it to you so that you can
		 * display it to the user.
		 *
		 * Your callback function must have this format:
		 * 		myFunctionName(error:String);
		 */
		public function addErrorListener(cb:Function):void {
			errorCallback = cb;
		}

		/**
		 * This is called when the level has finished being parsed
		 * and constructed.
		 *
		 * Your callback function must have this format:
		 * 		myFunctionName();
		 */
		public function addCompletionListener(cb:Function):void {
			loadingCompleteCallback = cb;
		}

		/**********************************
		 * PUBLIC LEVEL LOADING FUNCTIONS *
		 **********************************/

		/**
		 * This will first open the file, and then start
		 * constructing the level. Calls these callbacks:
		 * 		ErrorListener
		 * 		LevelInitializedListener
		 * 		ProgressListener
		 * 		CompletionListener
		 */
		public function loadFromFile(filename:String):void {
			var getFile:URLLoader = new URLLoader();
			getFile.addEventListener(Event.COMPLETE, onFileLoad);
			getFile.load(new URLRequest(filename));
		}

		/**
		 * If you already have the levelCode, you can have LevelLoader
		 * parse it for you.
		 *
		 * If constructLevel is false, it will not construct the level
		 * for you, and it will call the following callbacks:
		 * 		LevelParsedListener
		 *
		 * If constructLevel is true, LevelLoader will automatically
		 * start parsing the level and constructing a Level object.
		 * Calls the following callbacks:
		 * 		ErrorListener
		 * 		LevelInitializedListener
		 * 		ProgressListener
		 * 		CompletionListener
		 *
		 */
		public function loadFromCode(levelCode:String, src:String):void {
			errors = new Array();

			code = levelCode;
			codeLength = levelCode.length;

			parseLevelInfo();

			if (errors.length > 0) {
				errorCallback(errors);
				return;
			}

			setLevelInfo();

			timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}

		private function parseLevelInfo():void {
			if (code == null || code.length == 0) {
				errors.push(INVALID_FILE)
				return;
			}
			//trim leading whitespaces (buggy)
//			var i:int = 0;
//			var ch:String = code.charAt(i);
//			while (ch == "\n" || ch == " " || ch.concat(code.charAt(i + 1)) == "\r\n") {
//				i++;
//				code = code.substring(1);
//				ch = code.charAt(i);
//			}

			//get title
			var eol:int = code.indexOf("\n");
			if (eol == -1) {
				errors.push(INVALID_FILE);
				return;
			}
			title = code.substr(0, eol);
//			if (title.length < 1) {
//				errors.push("Invalid Level Code: Your level must have a title.");
//				return;
//			}
			code = code.substr(eol + 1);

			//get level info
			eol = code.indexOf("\n");
			var infoLine:String = code.substr(0, eol);
			var info:Array = infoLine.split("|");

			//get dimensions
			var dimensions:String = info[0];
			var ix:int = dimensions.indexOf("x");
			if (ix == -1) {
				errors.push();
				return;
			}
			if (dimensions.substr(0, ix).length < 1) {
				errors.push(INVALID_DIMENSIONS_FORMAT + "'" + dimensions + "'");
				return;
			}
			levelWidth = Number(dimensions.substr(0, ix));
			if (dimensions.substr(ix + 1).length < 1) {
				errors.push(INVALID_DIMENSIONS_FORMAT + "'" + dimensions + "'");
				return;
			}
			levelHeight = Number(dimensions.substr(ix + 1));
			code = code.substr(eol + 1);
			if (isNaN(levelWidth) || isNaN(levelHeight) || levelWidth <= 0 || levelHeight <= 0) {
				errors.push(INVALID_DIMENSIONS_NUMBERS + "'" + dimensions + "'");
				return;
			}

			//backwards compatibility
			if (info.length < 2) {
				terrainType = 0;
				backgroundType = 0;
				return;
			}

			//get terrain type
			var n:Number = Number(info[1]);
			if (isNaN(n) || Terrain.getTerrainImage(n) == null) {
				errors.push(INVALID_TERRAIN + "'" + info[1] + "'");
				return;
			}
			terrainType = n;
			
			//use default background if not specified
			if (info.length < 3) {
				backgroundType = 0;
				return;
			}
			
			//get background type
			n = Number(info[2]);
			if (isNaN(n) || LevelBackground.getThumbnail(n) == null) {
				errors.push(INVALID_BACKGROUND + "'" + info[1] + "'");
				return;
			}
			backgroundType = n;
		}

		/********************
		 * HIDDEN FUNCTIONS *
		 ********************/

		/**
		 * Instead of passing in arguments, use the info stored in the protected
		 * variables of this class.
		 */
		protected function setLevelInfo():void {
			throw new Error("initObject is abstract. Please override it.");
		}

		/**
		 * Called after the test level file has been loaded.
		 */
		private function onFileLoad(evt:Event):void {
			loadFromCode(evt.target.data, "LevelLoader");
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
				finishLoading();
				if (loadingCompleteCallback)
					loadingCompleteCallback();
			} else if (progressCallback) {
				progressCallback(i / codeLength);
			}
		}

		/**
		 * This method parses the special characters in the level
		 * encoding. It passes the other chars to createObject().
		 */
		private function parseChar(curChar:String):void {
			//this switch only handles special chars
			switch (curChar) {
				case " ":
					px += 1;
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
					py += 1;
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
					//if off the map, do nothing
					if (px < levelWidth && py < levelHeight) {
						initObject(curChar, px, py);
						px += 1;
					}
					break;
			}
			prevChar = curChar;
		}

		/**
		 * Parses the non-special characters of the level encoding
		 */
		protected function initObject(curChar:String, px:int, py:int):void {
			throw new Error("initObject is abstract. Please override it.");
		}

		/**
		 * Called when loading complete. Supposed to be overridden
		 * by subclasses, but optional.
		 */
		protected function finishLoading():void {
			//nothing, until subclasses override this
		}
	}
}
