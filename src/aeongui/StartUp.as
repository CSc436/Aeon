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
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class Game extends Sprite
	{
		public function Game()
		{
			var textField:TextField = new TextField(400, 300, "Welcome to Starling!");
			addChild(textField);
		}
	}
}