package org.interguild {
	import flash.media.Sound;
	import flash.net.URLRequest;

	public class SoundMan {

		public static const JUMP_SOUND:uint = 0;
		public static const TREASURE_COLLECT_SOUND:uint = 1;
		public static const ARROW_FIRING_SOUND:uint = 2;
		public static const EXPLOSION_SOUND:uint = 3;

		private static var instance:SoundMan;

		public static function getMe():SoundMan {
			if (instance == null) {
				instance = new SoundMan();
			}
			return instance;
		}

		CONFIG::ONLINE {
			private static const SOUND_PATH:String = INTERGUILD.ORG + "/aeon_demo/";
		}
		CONFIG::OFFLINE {
			private static const SOUND_PATH:String = "../assets/";
		}

		private var jump:Sound;
		private var treasure:Sound;
		private var arrowFiring:Sound;
		private var explosion:Sound;

		public function SoundMan() {
			jump = new Sound();
			jump.load(new URLRequest(SOUND_PATH + "jump.mp3"));

			treasure = new Sound();
			treasure.load(new URLRequest(SOUND_PATH + "coin.mp3"));

			arrowFiring = new Sound();
			arrowFiring.load(new URLRequest(SOUND_PATH + "Arrow.mp3"));
			
			explosion = new Sound();
			explosion.load(new URLRequest(SOUND_PATH + "Explosion.mp3"));
		}

		/**
		 * Plays the sound specified by the given constant. Use the
		 * constants defined in SoundMan for the argument.
		 */
		public function playSound(id:uint):void {
			switch (id) {
				case JUMP_SOUND:
//					jump.play();
					break;
				case TREASURE_COLLECT_SOUND:
//					treasure.play();
					break;
				case ARROW_FIRING_SOUND:
//					arrowFiring.play();
					break;
				case EXPLOSION_SOUND:
//					explosion.play();
					break;
			}
		}
	}
}
