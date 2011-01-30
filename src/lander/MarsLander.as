package lander{
	import flash.display.Sprite;
	import flash.display.Bitmap; 
	import vector.*;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard; 
	import flash.geom.*;
	
	/**
	 * @author charles
	 */
	public class MarsLander extends Sprite {
		
		private var imageFactory:ImageFactory; 
		private var currentImage:Bitmap; 
		
		private const THRUST:Number = .7;	//Units of pixels per frame^2
		private const DOWN_THRUST:Number = .3;
		private const LEFT_THRUST:Number = .6;
		private const RIGHT_THRUST:Number = .6; 
		private const ROTATIONAL_THRUST:Number = 1.0; //Units of degrees (per frame)
		private const GRAVITY:Number = .4; //Units of pixels per frame^2
		
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
			imageFactory = ImageFactory.getInstance();
			velocity = new vector2d(0, 0);
			isThrusting = isRotatingCW = isRotatingCCW = false; 
			
			hitPoints = new Vector.<Point>();
			hitPoints.push(new Point(0, 0), 
							new Point(Constants.LANDER_WIDTH, 0), 
							new Point(0, Constants.LANDER_HEIGHT), 
							new Point(Constants.LANDER_WIDTH, Constants.LANDER_HEIGHT));
			
			//Add children
			currentImage = imageFactory.landerImg;
			addChild(currentImage); 
			
			
			 
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
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function start():void {
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		//Function to pause and free up image resource when user goes to menu
		//Image was obtained as a clone from the ImageFactory class, so after setting currentImage = null
		//there will be no more reference to this object--it should be garbage collected
		public function pauseForMenu():void {
			stop(); 
			removeChild(currentImage);
			currentImage = null; 
		}
		
		//Function to resume from menu -- gets clone of appropriate image from imageFactory then adds it
		public function resumeFromMenu():void {
			if (isThrusting || isThrustingLeft || isThrustingRight || isThrustingDown)
				currentImage = imageFactory.landerThrustImg; 
			else
				currentImage = imageFactory.landerImg; 
				
			addChild(currentImage);
			
			start();
		}
		
		
		//Motion functions
		
		private function startThrusting():void {
			if (currentImage!=(imageFactory.landerThrustImg)) {
				removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerThrustImg);
			} 
			isThrusting = true; 
		}
		
		private function startThrustingDown():void {
			if (currentImage!=(imageFactory.landerThrustImg)) {
				removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerThrustImg);
			} 
			isThrustingDown = true; 
		}
		
		private function startThrustingLeft():void {
			if (currentImage!=(imageFactory.landerThrustImg)) {
				removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerThrustImg);
			} 
			isThrustingLeft = true; 
		}
		
		private function startThrustingRight():void {
			if (currentImage!=(imageFactory.landerThrustImg)) {
				removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerThrustImg);
			} 
			isThrustingRight = true; 
		}
		
		private function stopThrusting():void {
			if (currentImage!=(imageFactory.landerImg)) {
				removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerImg);
			} 
			isThrusting = false; 
		}
		
		private function stopThrustingDown():void {
			if (currentImage!=(imageFactory.landerImg)) {
				removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerImg);
			}
			isThrustingDown = false; 
		}
		
		private function stopThrustingLeft():void {
			if (currentImage!=(imageFactory.landerImg)) {
				removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerImg);
			} 
			isThrustingLeft = false; 
		}
		
		private function stopThrustingRight():void {
			if (currentImage!=(imageFactory.landerImg)) {
				removeChild(currentImage); 
				addChild(currentImage=imageFactory.landerImg);
			}
			isThrustingRight = false; 
		}
		
		private function thrust():void {
			velocity.add((getOrientation(rotation).multiply(THRUST)));
		}
		
		private function thrustDown():void {
			velocity.add((getOrientation(rotation).multiply(-1.0*DOWN_THRUST)));
		}
		
		private function thrustLeft():void {
			velocity.add((getOrientation(rotation - 90.0).multiply(LEFT_THRUST)));
		}
		
		private function thrustRight():void {
			velocity.add((getOrientation(rotation - 90.0).multiply(-1*RIGHT_THRUST)));
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
				case (Keyboard.UP): 
					startThrusting(); break; 
				case (Keyboard.DOWN): 
					startThrustingDown(); break; 
				case (Keyboard.LEFT): 
					startThrustingLeft(); break;
				case (Keyboard.RIGHT): 
					startThrustingRight(); break;
				case (Constants.A_KEY):
					isRotatingCCW = true; break;
				case (Constants.D_KEY): 
					isRotatingCW = true; break; 
			}
				
		}
		
		private function keyUp(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case (Keyboard.UP):
					stopThrusting(); break; 
				case (Keyboard.DOWN):
					stopThrustingDown(); break; 
				case (Keyboard.LEFT):
					stopThrustingLeft(); break; 
				case (Keyboard.RIGHT):
					stopThrustingRight(); break; 
				case (Constants.A_KEY): 
					isRotatingCCW = false; break ;
				case (Constants.D_KEY): 
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
