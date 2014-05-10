package org.interguild.menu {
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import fl.controls.TextInput;

	import org.interguild.Aeon;
	import org.interguild.INTERGUILD;

	public class UserLevelsPage extends Sprite {

		private static const INSTRUCTIONS_TEXT:String = "Please enter a level ID:";
		private static const HINT_TEXT:String = "(Hint: Try 65177)";

		private var input:TextInput;

		public function UserLevelsPage() {
			var wrapper:Sprite = new Sprite();

			//init instructions text
			var instructionText:TextField = new TextField();
			instructionText.defaultTextFormat = new TextFormat("Verdana", 14, 0xFFFFFF);
			instructionText.autoSize = TextFieldAutoSize.LEFT;
			instructionText.selectable = false;
			instructionText.text = INSTRUCTIONS_TEXT;
			wrapper.addChild(instructionText);

			//init input field
			input = new TextInput();
			input.width = 60;
			input.x = instructionText.width + 10;
			input.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			wrapper.addChild(input);

			//init hint text
			var hintText:TextField = new TextField();
			hintText.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF, false, true);
			hintText.autoSize = TextFieldAutoSize.LEFT;
			hintText.selectable = false;
			hintText.text = HINT_TEXT;
			hintText.x = wrapper.width / 2 - hintText.width / 2;
			hintText.y = 30;
			wrapper.addChild(hintText);

			wrapper.x = Aeon.STAGE_WIDTH / 2 - wrapper.width / 2;
			wrapper.y = Aeon.STAGE_HEIGHT / 2 - wrapper.height / 2;
			addChild(wrapper);
		}

		private function onKeyDown(evt:KeyboardEvent):void {
			if (evt.keyCode == 13) { //pressed Enter
				var id:Number = Number(input.text);
				Aeon.getMe().playLevelFile(INTERGUILD.ORG + "/levels/levels/" + id + ".txt");
			}
		}
	}
}
