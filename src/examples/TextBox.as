package examples {

	/*
	Simple Hello World text box
	Run:
	right click this class as default application
	then run, it will show up as html in your default web browser
	*/
	
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class TextBox extends Sprite {
        private var label:TextField;

        private var labelText:String = "Hello world and welcome to the show.";

        public function TextBox() {
            label = new TextField();
            label.autoSize = TextFieldAutoSize.LEFT;
            label.background = true;
            label.border = true;

            var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            format.color = 0xFF0000;
            format.size = 10;
            format.underline = true;

            label.defaultTextFormat = format;
            addChild(label);
            label.text = labelText;
        }
    }
}
