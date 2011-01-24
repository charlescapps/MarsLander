package lander{
	import flash.display.Sprite;
	import vector.*;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard; 
	
	/**
	 * @author charles
	 */
	public class MarsLander extends Sprite {
		
		private var imageFactory:ImageFactory; 
		
		private const THRUST:Number = 2.0;	//Units of pixels per frame^2
		private const ROTATIONAL_THRUST:Number = 2.0; //Units of degrees (per frame)
		private const GRAVITY:Number = 1.2; //Units of pixels per frame^2
		
		private var velocity:vector2d;	//Units of pixels per frame
		private var isThrusting:Boolean;
		private var isRotatingCW:Boolean; 
		private var isRotatingCCW:Boolean; 
		
		//public functions
		
		public function MarsLander() {
			trace("Entering MarsLander constructor...");
			//Initialize vars
			imageFactory = ImageFactory.getInstance();
			velocity = new vector2d(0, 0);
			isThrusting = isRotatingCW = isRotatingCCW = false; 
			
			//Add children
			addChild(imageFactory.landerImg); 
			
			 
		}
		
		public function afterAddedToStage():void {
			//Add events
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function get vel():vector2d {
			return velocity; 
		}
		
		public function stop():void {
			velocity.x = velocity.y = 0; 
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		
		//Motion functions
		
		private function startThrusting():void {
			if (contains(imageFactory.landerImg))
				removeChild(imageFactory.landerImg); 
			addChild(imageFactory.landerThrustImg); 
			isThrusting = true; 
		}
		
		private function stopThrusting():void {
			if (contains(imageFactory.landerThrustImg))
				removeChild(imageFactory.landerThrustImg); 
			addChild(imageFactory.landerImg); 
			isThrusting = false; 
		}
		
		private function thrust():void {
			velocity.add((getOrientation().multiply(THRUST)));
		}
		
		private function fall():void {
			velocity.y += GRAVITY; 
		}
		
		private function move():void {
			x += velocity.x; 
			y += velocity.y; 
		}
		
		private function rotateClockwise():void {
			rotation+=ROTATIONAL_THRUST; 
		}
		
		private function rotateCounterclockwise():void {
			rotation-=ROTATIONAL_THRUST;
		}
		
		private function getOrientation():vector2d {
			return new vector2d(Math.sin(rotation*2*Math.PI / 360), -Math.cos(rotation*2*Math.PI / 360));
		}
		
		//Event functions
		
		private function keyDown(evt:KeyboardEvent):void {
			switch(evt.keyCode) {
				case (Keyboard.UP): 
					startThrusting(); break; 
				case (Keyboard.LEFT):
					isRotatingCCW = true; break;
				case (Keyboard.RIGHT): 
					isRotatingCW = true; break; 
			}
				
		}
		
		private function keyUp(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case (Keyboard.UP):
					stopThrusting(); break; 
				case (Keyboard.LEFT): 
					isRotatingCCW = false; break ;
				case (Keyboard.RIGHT): 
					isRotatingCW = false; break; 
			}
		}
		
		private function enterFrame(evt:Event):void {
			//update velocity
			fall(); 
			if (isThrusting)
				thrust();
			if (isRotatingCW)
				rotateClockwise();
			else if (isRotatingCCW) 
				rotateCounterclockwise();
				
			//update position
			move();
			
		}
	}
	
	
}
