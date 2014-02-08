package aeongui
{
	import flash.display.Sprite;
	import starling.core.Starling;
	public class StartUp extends Sprite
	{
		private var _starling:Starling;
		
		public function StartUp()
		{
			_starling = new Starling(Game, stage);
			_starling.start();
		}
	}
}