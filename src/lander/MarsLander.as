package lander{
	import flash.display.Sprite;
	import flash.display.Bitmap; 
	import vector.*;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.geom.*;
	import com.pblabs.engine.core.InputKey; 
	
	/**
	 * @author charles
	 */
	public class MarsLander extends Sprite {
		
		private var imageFactory:ImageFactory = ImageFactory.getInstance(); 
		private var currentImage:Bitmap; 
		
		private var THRUST:Number;	//Units of pixels per frame^2
		private var SIDE_THRUST:Number; //Units of pixels per frame^2
		private var GRAVITY:Number; //Units of pixels per frame^2
		
		private const ROTATIONAL_THRUST:Number = Constants.ROTATIONAL_THRUST; //Units of degrees (per frame)
		
		private var velocity:vector2d;	//Units of pixels per frame
		
		private var isThrusting:Boolean;
		private var isThrustingDown:Boolean;
		private var isThrustingLeft:Boolean;
		private var isThrustingRight:Boolean;
		
		private var isRotatingCW:Boolean; 
		private var isRotatingCCW:Boolean; 
		
		public var hitPoints:Vector.<Point>;
		
		//public functions
		
		public function MarsLander() {
			
			trace("Entering MarsLander constructor...");
			//Initialize vars

			currentImage = imageFactory.landerImg; 
			addChild(currentImage);
			
			setHighGravity(Settings.gravityHigh); //Sets thrust and gravity based on Settings variable
			
			velocity = new vector2d(0, 0);
			
			isThrusting = isThrustingDown = isThrustingLeft = isThrustingRight = isRotatingCW = isRotatingCCW = false; 
			
			hitPoints = new Vector.<Point>();
			
			hitPoints.push(new Point(0, 0), 
							new Point(Constants.LANDER_WIDTH, 0), 
							new Point(0, Constants.LANDER_HEIGHT), 
							new Point(Constants.LANDER_WIDTH, Constants.LANDER_HEIGHT));
	
		}
		
		
		public function get vel():vector2d {
			return velocity; 
		}
		
		public function set vel(v:vector2d):void {
			velocity = v; 
		}
		
		public function stop():void {
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			if (stage != null && stage.hasEventListener(KeyboardEvent.KEY_DOWN))
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
				
			if (stage != null && stage.hasEventListener(KeyboardEvent.KEY_UP))
				stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
				
		}
		
		public function start():void {
			//Add stage events
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function setHighGravity(isHigh:Boolean):void {
			GRAVITY = (isHigh ? Constants.HIGH_GRAVITY: Constants.LOW_GRAVITY); 
			THRUST = (isHigh ? Constants.HIGH_THRUST: Constants.LOW_THRUST);
			SIDE_THRUST = (isHigh ? Constants.HIGH_SIDE_THRUST: Constants.LOW_SIDE_THRUST);
		}
		
		//Function to pause and free up image resource when user goes to menu
		//Image was obtained as a clone from the ImageFactory class, so after setting currentImage = null
		//there will be no more reference to this object--it should be garbage collected
		public function dispose():void {
			stop(); 
			
			if (currentImage !=null && contains(currentImage))
				removeChild(currentImage);
			currentImage = null; 
		}
		
		
		//Motion functions
		
		private function startThrusting():void {
			if (!isThrusting && !isThrustingDown && !isThrustingLeft && !isThrustingRight) {
				trace("Current Image in startThrusting: " + currentImage);
				if (currentImage!=null && contains(currentImage))
					removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerThrustImg);
			} 
			isThrusting = true; 
		}
		
		private function startThrustingDown():void {
			if (!isThrusting && !isThrustingDown && !isThrustingLeft && !isThrustingRight) {
				if (currentImage!=null && contains(currentImage))
					removeChild(currentImage);  
				addChild(currentImage=imageFactory.landerThrustImg);
			} 
			isThrustingDown = true; 
		}
		
		private function startThrustingLeft():void {
			if (!isThrusting && !isThrustingDown && !isThrustingLeft && !isThrustingRight) {
				if (currentImage!=null && contains(currentImage))
					removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerThrustImg);
			} 
			isThrustingLeft = true; 
		}
		
		private function startThrustingRight():void {
			if (!isThrusting && !isThrustingDown && !isThrustingLeft && !isThrustingRight) {
				if (currentImage!=null && contains(currentImage))
					removeChild(currentImage);  
				addChild(currentImage=imageFactory.landerThrustImg);
			} 
			isThrustingRight = true; 
		}
		
		private function stopThrusting():void {
			isThrusting = false; 
			
			if (!isThrusting && !isThrustingDown && !isThrustingLeft && !isThrustingRight) {
				if (currentImage!=null && contains(currentImage))
					removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerImg);
			} 
			
		}
		
		private function stopThrustingDown():void {
			isThrustingDown = false; 
			
			if (!isThrusting && !isThrustingDown && !isThrustingLeft && !isThrustingRight) {
				if (currentImage!=null && contains(currentImage))
					removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerImg);
			}
			
		}
		
		private function stopThrustingLeft():void {
			isThrustingLeft = false; 
			
			if (!isThrusting && !isThrustingDown && !isThrustingLeft && !isThrustingRight) {
				if (currentImage!=null && contains(currentImage))
					removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerImg);
			} 
			
		}
		
		private function stopThrustingRight():void {
			isThrustingRight = false; 
			
			if (!isThrusting && !isThrustingDown && !isThrustingLeft && !isThrustingRight) {
				if (currentImage!=null && contains(currentImage))
					removeChild(currentImage);  
				addChild(currentImage=imageFactory.landerImg);
			}
			
		}
		
		private function thrust():void {
			velocity.add((getOrientation(rotation).multiply(THRUST)));
		}
		
		private function thrustDown():void {
			velocity.add((getOrientation(rotation).multiply(-1.0*SIDE_THRUST)));
		}
		
		private function thrustLeft():void {
			velocity.add((getOrientation(rotation - 90.0).multiply(SIDE_THRUST)));
		}
		
		private function thrustRight():void {
			velocity.add((getOrientation(rotation - 90.0).multiply(-1*SIDE_THRUST)));
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
		
		private function getOrientation(angle:Number):vector2d {
			return new vector2d(Math.sin(angle*Math.PI / 180.0), -Math.cos(angle*Math.PI / 180.0));
		}
		
		//Event functions
		
		private function keyDown(evt:KeyboardEvent):void {
			switch(evt.keyCode) {
				case (InputKey.UP.keyCode): 
					startThrusting(); break; 
				case (InputKey.DOWN.keyCode): 
					startThrustingDown(); break; 
				case (InputKey.LEFT.keyCode): 
					startThrustingLeft(); break;
				case (InputKey.RIGHT.keyCode): 
					startThrustingRight(); break;
				case (InputKey.A.keyCode):
					isRotatingCCW = true; break;
				case (InputKey.D.keyCode): 
					isRotatingCW = true; break; 
			}
				
		}
		
		private function keyUp(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case (InputKey.UP.keyCode):
					stopThrusting(); break; 
				case (InputKey.DOWN.keyCode):
					stopThrustingDown(); break; 
				case (InputKey.LEFT.keyCode):
					stopThrustingLeft(); break; 
				case (InputKey.RIGHT.keyCode):
					stopThrustingRight(); break; 
				case (InputKey.A.keyCode): 
					isRotatingCCW = false; break ;
				case (InputKey.D.keyCode): 
					isRotatingCW = false; break; 
			}
		}
		
		private function enterFrame(evt:Event):void {
			//update velocity
			fall(); 
			if (isThrusting)
				thrust();
			if (isThrustingDown)
				thrustDown();
			if (isThrustingLeft)
				thrustLeft();
			if (isThrustingRight)
				thrustRight();
			if (isRotatingCW)
				rotateClockwise();
			else if (isRotatingCCW) 
				rotateCounterclockwise();
				
			//update position
			move();
			
		}
	}
	
	
}
