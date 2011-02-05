package lander{
	import sprites.SpriteSheet; 
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.geom.*;
	import com.pblabs.engine.core.InputKey;
	import vector.*; 
	
	/**
	 * @author charles
	 */
	public class MarsLander extends SpriteSheet {
		
		private var imageFactory:ImageFactory = ImageFactory.getInstance(); 
		
		private var THRUST:Number;	//Units of pixels per frame^2
		private var SIDE_THRUST:Number; //Units of pixels per frame^2
		private var GRAVITY:Number; //Units of pixels per frame^2
		
		private const ROTATIONAL_THRUST:Number = Constants.ROTATIONAL_THRUST; //Units of degrees (per frame)
		
		private var velocity:vector2d;	//Units of pixels per frame
		
		private var isThrusting:Boolean;
		private var isThrustingHigh:Boolean;
		private var isThrustingLeft:Boolean;
		private var isThrustingRight:Boolean;
		
		private var isRotatingCW:Boolean; 
		private var isRotatingCCW:Boolean; 
		
		private const framesTilHighThrust:int = 10;
		private const explodeFrames:int = 6; 
		private var numFramesThrusting:int; 
		private var numFramesExploding:int; 
		
		public var hitPoints:Vector.<Point>;
		
		private const seedSpawnPoint:Point = new Point(7, 21); 
		
		//public functions
		
		public function MarsLander() {
			super(imageFactory.landerSpriteSheet, new Rectangle(0, 0, 31, 31), new Point(32, 32), 4, 4);
			
			//Keys for sprite locations
			setLoc("DEFAULT", 0, 0);
			setLoc("THRUST_LOW", 0, 1);
			setLoc("THRUST_HIGH", 0, 2);
			setLoc("THRUST_R", 0, 3);
			setLoc("THRUST_LOW_R", 1, 0);
			setLoc("THRUST_HIGH_R", 1, 1);
			setLoc("THRUST_L_R", 1, 2);
			setLoc("THRUST_LOW_L_R", 1, 3);
			setLoc("THRUST_HIGH_L_R", 2, 0);
			setLoc("THRUST_L", 2, 1);
			setLoc("THRUST_LOW_L", 2, 2);
			setLoc("THRUST_HIGH_L", 2, 3);
			setLoc("EXPLODE_1", 3, 0); 
			setLoc("EXPLODE_2", 3, 1);
			setLoc("EXPLODE_3", 3, 2);
			setLoc("EXPLODE_4", 3, 3);
			
			//Show sprite sheet
			loadSprite("DEFAULT");
			
			//Initialize stuff
			
			bmp.smoothing = true; //Turn on smoothing for image
			
			setHighGravity(Settings.gravityHigh); //Sets thrust and gravity based on Settings variable
			
			velocity = new vector2d(0, 0);
			
			isThrusting = isThrustingLeft = isThrustingRight = isRotatingCW = isRotatingCCW = false; 
			
			hitPoints = new Vector.<Point>();
			
			hitPoints.push(new Point(7, 21), 
							new Point(9, 21), 
							new Point(22, 21), 
							new Point(24, 21), 
							new Point(5, 1), 
							new Point(5, 11), 
							new Point(26, 1), 
							new Point(26, 11));
			
			numFramesThrusting = 0;
			numFramesExploding = 0;
	
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
		
		public function spawnSeed():Seed {
			var s:Seed = new Seed(velocity);
			var loc:Point = this.localToGlobal(seedSpawnPoint);
			s.x = loc.x; 
			s.y = loc.y; 
			
			return s;
		}
		
		public function start():void {
			//Add stage events
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function explode():void {
			addEventListener(Event.ENTER_FRAME, enterFrameExplode);
		}
		
		//Set gravity and thrust based on whether high gravity is turned on
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
		
			imageFactory = null;  
		}
		
		//Load image based on thrusting state
		private function loadThrustSprite():void {
			if (isThrusting && isThrustingLeft && isThrustingRight) {
				if (!isThrustingHigh)
					loadSprite("THRUST_LOW_L_R");
				else
					loadSprite("THRUST_HIGH_L_R");
			}
			
			else if (isThrusting && isThrustingLeft && !isThrustingRight) {
				if (!isThrustingHigh)
					loadSprite("THRUST_LOW_L");
				else
					loadSprite("THRUST_HIGH_L");
			}
			
			else if (!isThrusting && isThrustingLeft && isThrustingRight)
				loadSprite("THRUST_L_R");
				
			else if (isThrusting && !isThrustingLeft && isThrustingRight) {
				 if (!isThrustingHigh)
				 	loadSprite("THRUST_LOW_R");
				 else
				 	loadSprite("THRUST_HIGH_R"); 
			}
			
			else if (isThrusting ) {
				if (!isThrustingHigh)
					loadSprite("THRUST_LOW");
				else
					loadSprite("THRUST_HIGH"); 
			}
			
			else if (isThrustingLeft)
				loadSprite("THRUST_L");
				
			else if (isThrustingRight)
				loadSprite("THRUST_R"); 
			
			else
				loadSprite("DEFAULT");
				
			
			 
		}	
		//Motion functions
		
		private function startThrusting():void {
			
			isThrusting = true;
			
			loadThrustSprite(); 
		}
		
		private function startThrustingLeft():void {

			isThrustingLeft = true; 
			
			loadThrustSprite();
		}
		
		private function startThrustingRight():void {

			isThrustingRight = true; 
			
			loadThrustSprite();
		}
		
		private function stopThrusting():void {
			isThrusting = isThrustingHigh = false; 
			numFramesThrusting = 0; 
			
			loadThrustSprite();
			
		}
		
		
		private function stopThrustingLeft():void {
			isThrustingLeft = false; 
			
			loadThrustSprite();
			
		}
		
		private function stopThrustingRight():void {
			isThrustingRight = false; 
			
			loadThrustSprite();
			
		}
		
		private function thrust():void {
			velocity.add((getOrientation(rotation).multiply(THRUST)));
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
			if (isThrusting) {
				thrust();
				if (++numFramesThrusting > framesTilHighThrust) {
					isThrustingHigh = true;
					loadThrustSprite();  
				}
			}
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
		
		private function enterFrameExplode(evt:Event):void {
			numFramesExploding++; 
			if (numFramesExploding < explodeFrames) 
				loadSprite("EXPLODE_1");
			else if (numFramesExploding >= explodeFrames && numFramesExploding < explodeFrames*2)
				loadSprite("EXPLODE_2"); 
			else if (numFramesExploding >= explodeFrames*2 && numFramesExploding < explodeFrames*3)
				loadSprite("EXPLODE_3");
			else if (numFramesExploding >= explodeFrames*3 && numFramesExploding < explodeFrames*4)
				loadSprite("EXPLODE_4");
			else {
				hide();
				removeEventListener(Event.ENTER_FRAME, enterFrameExplode);
			}
		}
	}
	
	
}
