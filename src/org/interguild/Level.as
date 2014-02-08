package org.interguild {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * Level will handle the actual gameplay. It's responsible for
	 * constructing itself based off of the level encoding, but it
	 * is not responsible for displaying its preloading progress
	 * to the user.
	 * 
	 * Level controls the camera, game logic, etc.
	 */
	public class Level extends Sprite {
		
		private static const FRAME_RATE:uint = 30;
		private static const PERIOD:Number = 1000 / FRAME_RATE;
		
		private var camera:Sprite;
		private var player:Player;
		
		private var timer:Timer;
		
		public function Level() {
			//initialize camera
			camera = new Sprite();
			addChild(camera);
			
			//init player
			player = new Player();
			camera.addChild(player);
			
			//init game loop
			timer = new Timer(PERIOD);
			timer.addEventListener(TimerEvent.TIMER, onGameLoop, false, 0, true);
			timer.start();
		}
		
		private function onGameLoop(evt:TimerEvent):void{
			trace("I'm looping!");
		}
	}
}
