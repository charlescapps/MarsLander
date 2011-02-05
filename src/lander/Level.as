package lander {
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import vector.*;
	import flash.text.TextField; 
	import flash.text.TextFormat; 
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import landerEvents.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.*;
	import ccui.CCButton; 

	/**
	 * @author charles
	 * 
	 * Class representing the rendering of a Mars Lander Level
	 * 
	 */
	public class Level extends Sprite {
		
		private static const LANDER_START:vector2d = new vector2d(200, 150); //Default position of lander when game starts
		private static const SPEED_START:vector2d = new vector2d(500 , 25);  //Position of box that displays your speed
		
		private static const MAX_SPEED:int = 10; //Max speed allowed when you try to land
		private static const MAX_ROTATION:Number = 15*Math.PI / 180.0 ; //Max rotation off from orientation of landing pad allowed
		
		private var marsLander:MarsLander; //The Marslander!
		private var ground:Sprite; 		   //Sprite displaying the ground
		private var landingPad:Sprite; 	   //Sprite displaying the landing pad
		
		private var seeds:Vector.<Seed> = new Vector.<Seed>(); //All seeds currently on stage (drawn into sprite after growing).
		
		private var messageBox:TextField;  //TextField that displays a message for the user
		private var speedBox:TextField;    //TextField that displays your current speed
		private var textFormat:TextFormat; //Format of the messageBox
		private var textFormat2:TextFormat; //Format of the speedBox
		
		private var levelData:LevelData; //The data for the level (shape of ground, location of landing pad)
		private var gameOver:Boolean = false; 
		private var wonGame:Boolean = false; 
		
		private var homeButton:CCButton = new CCButton("Back Home", 0xff8888, 0xff0000, 0x666666, 30, 0x00ff00, new Rectangle(100, 25, 200, 50));
		private var pauseButton:CCButton = new CCButton("Pause", 0xff8888, 0xff0000, 0x666666, 30, 0x00ff00, new Rectangle(100, 25, 200, 50));
		
		public function Level() {
			
			//initialize variables
			marsLander = new MarsLander(); 
			marsLander.x = LANDER_START.x; 
			marsLander.y = LANDER_START.y; 
			
			ground = new Sprite();
			landingPad = new Sprite();
			
			//Initialize text fields and formats
			messageBox = new TextField();
			messageBox.autoSize = TextFieldAutoSize.LEFT;
			
			speedBox = new TextField(); 
			speedBox.autoSize = TextFieldAutoSize.LEFT;
			speedBox.x = SPEED_START.x; 
			speedBox.y = SPEED_START.y; 
			
			textFormat = new TextFormat(); 
			textFormat.font = "Impact";
			textFormat.size = 36; 
			textFormat.bold = true;
			
			textFormat2 = new TextFormat(); 
			textFormat2.font = "Arial";
			textFormat2.size = 26; 
			textFormat2.bold = false;
			textFormat2.align = TextFormatAlign.LEFT; 
			
			messageBox.defaultTextFormat = textFormat;  
			speedBox.defaultTextFormat = textFormat2; 
			
			//Add children
			addChild(marsLander);
			addChild(ground);
			addChild(landingPad);
			addChild(speedBox);
			
			
		}
		
		public function removeAllListeners():void {
			
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, enterFrame);
				
			if (hasEventListener(KeyboardEvent.KEY_DOWN))
				removeEventListener(KeyboardEvent.KEY_DOWN, pressSpace);
				
			if (pauseButton.hasEventListener(MouseEvent.CLICK))
				pauseButton.removeEventListener(MouseEvent.CLICK, onClickPause);
				
			if (homeButton.hasEventListener(MouseEvent.CLICK))
				homeButton.removeEventListener(MouseEvent.CLICK, onClickHome);
				
			pauseButton.dispose(); //Remove listeners inside pause button
			homeButton.dispose();  //""               inside home button
				
		}
		
		public function resumeFromMenu():void {
			
			//Add time-based events if the game isn't over
			if (!gameOver) {
				addEventListener(Event.ENTER_FRAME, enterFrame);
				addEventListener(KeyboardEvent.KEY_DOWN, pressSpace);
				marsLander.start();
				marsLander.draw();
				
				addChild(pauseButton);
				pauseButton.addEventListener(MouseEvent.CLICK, onClickPause);
			}
			else {
				addChild(messageBox);
				centerTextField(messageBox);
				
				addChild(homeButton);
				homeButton.addEventListener(MouseEvent.CLICK, onClickHome);
				
				if (wonGame) 
					marsLander.draw();
			}
		}
		
		public function pressSpace(evt:KeyboardEvent):void {
			var s:Seed = marsLander.spawnSeed(); 
			seeds.push(s);
		}
		
		//Just a helper function to put a box in the center of the screen based on its current size
		private function centerTextField(aTextField:TextField):void {
			aTextField.x = stage.stageWidth / 2 - aTextField.width/2;  
			aTextField.y = stage.stageHeight / 4;
		}
		
		//Event that occurs to determine if you won the game after hitting the ground sprite
		private function hitGround():void {
			
			marsLander.stop();
			marsLander.explode();
			
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			messageBox.text = "You hit the rough terrain and exploded!"; 
			trace("You hit the ground and exploded!");
		
			
			centerTextField(messageBox); 
			addChild(messageBox);
			
			if (contains(pauseButton)) {
				removeChild(pauseButton);
				pauseButton.removeEventListener(MouseEvent.CLICK, onClickPause);
			}
			
			addChild(homeButton);
			homeButton.addEventListener(MouseEvent.CLICK, onClickHome);
			
			gameOver = true; 
			
		}
		
		private function hitLandingPad():void {
			
			marsLander.stop();
			
			//Get difference in angle between lander and landing pad
			var angleDiff:Number = Math.abs(marsLander.rotation*Math.PI / 180.0 - vector2d.getAngle(levelData.landPt1, levelData.landPt2));
			
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			if (angleDiff > MAX_ROTATION) {
				messageBox.text = "You crashed and died cause your angle was off!"; 
				marsLander.explode();
				
			}
			else if (marsLander.vel.magnitude() > MAX_SPEED) 
				 {
				messageBox.text = "You crashed and died cause you were going too fast!"; 
				marsLander.explode();
				trace("You crashed!"); 
			}

			else {
				messageBox.text = "You win!"; 
				wonGame = true; 
				trace("You win!");
			}
			
			centerTextField(messageBox); 
			addChild(messageBox);
			
			if (contains(pauseButton)) {
				removeChild(pauseButton);
				pauseButton.removeEventListener(MouseEvent.CLICK, onClickPause);
			}
			
			addChild(homeButton);
			homeButton.addEventListener(MouseEvent.CLICK, onClickHome);
			
			gameOver = true; 
			
		}
		
		private function didHitGround():Boolean {
			for each (var pt:Point in marsLander.hitPoints)  {
				
				if (ground.hitTestPoint(marsLander.localToGlobal(pt).x, marsLander.localToGlobal(pt).y, true)) 
					return true; 
			}
			
			return false; 
		}
		
		private function didHitLandingPad():Boolean {

			for each (var pt:Point in marsLander.hitPoints)  {
				
				if (landingPad.hitTestPoint(marsLander.localToGlobal(pt).x, marsLander.localToGlobal(pt).y, true)) 
					return true; 
			}
			
			return false; 
		}
		
		private function seedHitGround():int {
			for (var i:int = 0; i < seeds.length; i++) {
				
			}
		}
		
		//Write HTML giving current speed to speedBox and check if the mars lander has collided with anything
		private function enterFrame(evt:Event):void {
			
			speedBox.htmlText = "<b>Keep your speed under 10 m/s!</b>\n" 
								+ "<i>Current speed:</i> " + marsLander.vel.magnitude().toFixed(2) + " m/s"; 
			
			if (didHitGround())
				hitGround();
					
			else if (didHitLandingPad()) 
				hitLandingPad();
				
			if (marsLander.x > Constants.STAGE_WIDTH ) 
				marsLander.x = marsLander.x - Constants.STAGE_WIDTH;
			
			else if (marsLander.x < 0)
				marsLander.x = Constants.STAGE_WIDTH + marsLander.x;
					
		}
		
		//Load geometry of level from LevelData object and draw to screen
		public function loadLevel(ld:LevelData):void {
			this.levelData = ld; 
			
			ground.graphics.beginFill(ld.groundColor);
			
			ground.graphics.lineStyle(ld.groundLineThickness, ld.groundLineColor);
			ground.graphics.moveTo(ld.groundPoints[0].x, ld.groundPoints[0].y);
			
			for (var i:int = 1; i < ld.groundPoints.length; i++) 
				ground.graphics.lineTo(ld.groundPoints[i].x, ld.groundPoints[i].y);
			
			
			ground.graphics.lineTo(ld.groundPoints[0].x, ld.groundPoints[0].y);
			ground.graphics.endFill();
			
			//Draw landing pad
			
			landingPad.graphics.lineStyle(ld.landingThickness, ld.landingColor);
			landingPad.graphics.moveTo(ld.landPt1.x, ld.landPt1.y); 
			landingPad.graphics.lineTo(ld.landPt2.x, ld.landPt2.y);
			
		}
		
		//Load state of level (i.e. mars lander position), etc.
		public function loadLevelState(ls:LevelState):void {
			if (ls!=null) {
				marsLander.x = ls.landerPosition.x; 
				marsLander.y = ls.landerPosition.y; 
				marsLander.rotation = ls.landerRotation; 
				marsLander.vel = ls.landerVelocity; 
				gameOver = ls.gameOver; 
				wonGame = ls.wonGame;
				messageBox.text = ls.messageStr;
				speedBox.text = ls.speedBoxStr; 
			}
		}
		
		public function dumpLevelState():LevelState {
			return new LevelState(new vector2d(marsLander.x, marsLander.y), marsLander.vel, marsLander.rotation, gameOver, wonGame, messageBox.text, speedBox.text);
		}
		
		private function onClickHome(evt:MouseEvent):void {
			dispatchEvent(new LanderEvent(LanderEvent.GO_TO_HOME, true));
		}
		
		private function onClickPause(evt:MouseEvent):void {
			dispatchEvent(new LanderEvent(LanderEvent.GO_TO_HOME, true));
		}
		
		public function dispose():void {

			removeAllListeners(); //removes all event listeners
			
			marsLander.dispose();
			
			if (contains(marsLander))
				removeChild(marsLander);
			if (contains(homeButton)) 
				removeChild(homeButton);
			if (contains(pauseButton))
				removeChild(pauseButton);
			marsLander = null; 
			homeButton = pauseButton = null; 
			ground = landingPad = null; 
			messageBox = speedBox = null; 
			
			
		}

				
	}
	
}
