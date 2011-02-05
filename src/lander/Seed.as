package lander {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point; 
	import vector.vector2d; 

	/**
	 * @author charles
	 */
	public class Seed extends Sprite {
		
		private var GRAVITY:Number;
		private var velocity:vector2d;
		private var hitPoints:Vector.<Point> = new Vector.<Point>();
		 
		public function Seed(initialVelocity:vector2d) {
			setHighGravity();
			
			velocity = new vector2d(initialVelocity.x, initialVelocity.y);
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
		}
		
		public function grow():void {
			
		}
		
		public function stop():void {
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
	
		public function setHighGravity():void {
				GRAVITY = (Settings.gravityHigh ? Constants.HIGH_GRAVITY: Constants.LOW_GRAVITY);
		}
		
		private function enterFrame(evt:Event):void {
			velocity.y += GRAVITY; 
			
			this.x += velocity.x; 
			this.y += velocity.y; 
		}
		
	}
}
