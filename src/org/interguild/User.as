package org.interguild {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * User is not a class that you instantiate.
	 * Use its static methods to get info about the state
	 * of the user.
	 */
	public class User {

		private static const GET_LOGIN_PAGE:String = INTERGUILD.ORG + "/get_login.php";
		private static const LOGGED_OUT_TEXT:String = "<logged out>";

		private static var isLoggedIn:Boolean = false;
		private static var username:String = "Guest";

		public static function get IS_LOGGED_IN():Boolean {
			return isLoggedIn;
		}

		public static function get NAME():String {
			return username;
		}

		/**
		 * Called by Aeon.as
		 */
		public static function init(onLoadCallback:Function):void {
			CONFIG::ONLINE {
				var getFile:URLLoader = new URLLoader();
				getFile.addEventListener(Event.COMPLETE, onFileLoad);
				getFile.load(new URLRequest(GET_LOGIN_PAGE));

				function onFileLoad(evt:Event):void {
					var contents:String = String(evt.target.data);
					if (contents != LOGGED_OUT_TEXT) {
						isLoggedIn = true;
						username = contents;
						trace("LOGGED IN AS: " + username);
					} else {
						isLoggedIn = false;
						username = "";
						trace("NOT LOGGED IN");
					}
					onLoadCallback();
				}
			}
			CONFIG::NOONLINE {
				isLoggedIn = false;
				onLoadCallback();
			}
		}
	}
}
