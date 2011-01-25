package lander {
	import flash.display.Sprite;

	/**
	 * @author charles
	 */
	public class testhit extends Sprite {
		public function testhit() {
			import flash.display.Shape;

var circle1:Shape = new Shape();
circle1.graphics.beginFill(0x0000FF);
circle1.graphics.drawCircle(40, 40, 40);
addChild(circle1);

var circle2:Shape = new Shape();
circle2.graphics.beginFill(0x00FF00);
circle2.graphics.drawCircle(40, 40, 40);
circle2.x = 50;
addChild(circle2);

var circle3:Shape = new Shape();
circle3.graphics.beginFill(0xFF0000);
circle3.graphics.drawCircle(40, 40, 40);
circle3.x = 100;
circle3.y = 67;
addChild(circle3);

trace(circle1.hitTestObject(circle2)); // true
trace(circle1.hitTestObject(circle3)); // false
trace(circle2.hitTestObject(circle3)); // true
		}
	}
}
