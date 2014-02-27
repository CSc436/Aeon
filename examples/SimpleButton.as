package examples {
    import flash.display.Sprite;
    import flash.display.SimpleButton;

    public class SimpleButton extends Sprite {
        public function SimpleButton() {
            var button:CustomSimpleButton = new CustomSimpleButton();
            addChild(button);
        }
    }
}

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.SimpleButton;

class CustomSimpleButton extends SimpleButton {
    private var upColor:uint = 0xFFCC00;

    private var overColor:uint = 0xCCFF00;

    private var downColor:uint = 0x00CCFF;

    private var size:uint = 80;

    public function CustomSimpleButton() {
        downState = new ButtonDisplayState(downColor, size);
        overState = new ButtonDisplayState(overColor, size);
        upState = new ButtonDisplayState(upColor, size);
        hitTestState = new ButtonDisplayState(upColor, size); // changes button hitbox
        hitTestState.x = -(size / 4);
        hitTestState.y = hitTestState.x;
        useHandCursor = true;
    }
}

class ButtonDisplayState extends Shape {
    private var bgColor:uint;

    private var size:uint;

    public function ButtonDisplayState(bgColor:uint, size:uint) {
        this.bgColor = bgColor;
        this.size = size;
        draw();
    }

    private function draw():void {
        graphics.beginFill(bgColor);
        graphics.drawRect(0, 0, size, size);
        graphics.endFill();
    }
}
