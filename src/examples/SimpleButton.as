package examples {
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.net.URLRequest;

    public class SimpleButton extends Sprite {

        public function SimpleButton(_alpha:Number) {
            var my_loader:Loader = new Loader();
            my_loader.load(new URLRequest("Test Button.png"));
            addChild(my_loader);

            this.alpha = _alpha;
        }
    }
}
