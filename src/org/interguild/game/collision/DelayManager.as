package org.interguild.game.collision {
	import org.interguild.game.tiles.Player;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.DynamiteStick;

	public class DelayManager {

		private static const DEATH_DELAY:uint = 5;
		private static const ACTIVATION_DELAY:uint = 10;

		private var deathList:Array;
		private var deathTimer:uint = 0;
		
		private var activateList:Array;
		private var activateTimer:uint = 0;

		public function DelayManager() {
			var i:uint;
			deathList = new Array(DEATH_DELAY);
			for (i = 0; i < deathList.length; i++) {
				deathList[i] = new Array();
			}
			activateList = new Array(ACTIVATION_DELAY);
			for (i = 0; i < activateList.length; i++) {
				activateList[i] = new Array();
			}
		}

		public function onDeath(obj:CollidableObject):void {
			if (!obj.markedForDeath) {
				obj.markedForDeath = true;
				if (diesImmediately(obj)) {
					if (deathTimer == 0) {
						deathList[deathList.length - 1].push(obj);
					} else {
						deathList[deathTimer - 1].push(obj);
					}
				} else {
					deathList[deathTimer].push(obj);
				}
			}
		}
		
		private function diesImmediately(obj:CollidableObject):Boolean{
			return obj is Player || obj is DynamiteStick;
		}

		public function getDeaths():Array {
			if (deathTimer == 0) {
				deathTimer = deathList.length - 1;
			} else {
				deathTimer--;
			}
			var list:Array = deathList[deathTimer];
			deathList[deathTimer] = new Array();
			return list;
		}

		public function onActivate(tile:GridTile):void {
			if (!tile.markedForActivation) {
				tile.markedForActivation = true;
				activateList[activateTimer].push(tile);
			}
		}

		public function getActivations():Array {
			if (activateTimer == 0) {
				activateTimer = activateList.length - 1;
			} else {
				activateTimer--;
			}
			var list:Array = activateList[activateTimer];
			activateList[activateTimer] = new Array();
			return list;
		}
	}
}
