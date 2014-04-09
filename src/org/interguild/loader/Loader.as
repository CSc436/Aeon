package org.interguild.loader {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import flexunit.utils.ArrayList;
	
	import org.interguild.Aeon;
	
	public class Loader {
		
		private static const LOOPS_PER_TICK:uint = 250;
		
		private var code:String; //the level encoding in the file
		private var codeLength:uint;
		private var timer:Timer;
		
		private var levelWidth:int;
		private var levelHeight:int;
		
		protected var initializedCallback:Function;
		private var progressCallback:Function;
		private var errorCallback:Function;
		private var loadingCompleteCallback:Function;
		private var levelParsedCallback:Function;
		
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
			var title:String;
			var errors:ArrayList = new ArrayList();
			
			code = levelCode;
			codeLength = code.length;
			
			var length:int = levelCode.split("\n").length;
			if(length < 3){
				errors.addItem("Invalid Level Code; title, dimensions, followed by encoding.");
			}
			
			//get title
			var eol:int = code.indexOf("\n");
			title = code.substr(0, eol);
			if(title.length < 1){
				errors.addItem("Invalid Encoding; first line must be level title.");
			}
			code = code.substr(eol + 1);
			
			//get dimensions
			eol = code.indexOf("\n");
			var dimensionsLine:String = code.substr(0, eol);
			var ix:int = dimensionsLine.indexOf("x");
			if(ix == -1)
				errors.addItem("Invalid Level Dimensions; input should be in the form ##x##.");
			
			if(dimensionsLine.substr(0, ix).length < 1)
				errors.addItem("Invalid Level Dimensions; input should be in the form ##x##.");
			levelWidth = Number(dimensionsLine.substr(0, ix));
			
			if(dimensionsLine.substr(ix + 1).length < 1)
				errors.addItem("Invalid Level Dimensions; input should be in the form ##x##.");
			levelHeight = Number(dimensionsLine.substr(ix + 1));
			
			code = code.substr(eol + 1);
			
			if (levelWidth <= 0 || levelHeight <= 0) {
				errors.addItem("Invalid Level Dimensions; must be positive values.");
			}
			
			if (errors.length() > 0){
				errorCallback(errors);
				return;
			}
			
			setLevelInfo(title, levelWidth, levelHeight);
			
			timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		/********************
		 * HIDDEN FUNCTIONS *
		 ********************/
		
		protected function setLevelInfo(title:String, lvlWidth:uint, lvlHeight:uint):void {
			throw new Error("initObject is abstract. Please override it.");
		}
		
		/**
		 * Called after the test level file has been loaded.
		 */
		private function onFileLoad(evt:Event):void {
			loadFromCode(evt.target.data,"LevelLoader");
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
	}
}
