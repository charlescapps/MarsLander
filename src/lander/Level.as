package lander {
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
	import levelMaker.CCButton; 

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
		
		private var messageBox:TextField;  //TextField that displays a message for the user
		private var speedBox:TextField;    //TextField that displays your current speed
		private var textFormat:TextFormat; //Format of the messageBox
		private var textFormat2:TextFormat; //Format of the speedBox
		
		private var levelData:LevelData; //The data for the level (shape of ground, location of landing pad)
		private var gameOver:Boolean = false; 
		
		private var homeButton:CCButton = new CCButton("Back Home", 0xff8888, 0xff0000, 30, 0x00ff00, new Rectangle(100, 25, 200, 50), 0x666666);
		private var pauseButton:CCButton = new CCButton("Pause", 0xff8888, 0xff0000, 30, 0x00ff00, new Rectangle(100, 25, 200, 50), 0x666666);
		
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
				
			if (hasEventListener(LanderEvent.HIT_GROUND_EVENT))
				removeEventListener(LanderEvent.HIT_GROUND_EVENT, hitGround);
				
			if (pauseButton.hasEventListener(MouseEvent.CLICK))
				pauseButton.removeEventListener(MouseEvent.CLICK, onClickPause);
				
			if (homeButton.hasEventListener(MouseEvent.CLICK))
				homeButton.removeEventListener(MouseEvent.CLICK, onClickHome);
				
		}
		
		public function resumeFromMenu():void {
			
			//Add time-based events if the game isn't over
			if (!gameOver) {
				addEventListener(Event.ENTER_FRAME, enterFrame);
				addEventListener(LanderEvent.HIT_GROUND_EVENT, hitGround);
				marsLander.start();
				
				addChild(pauseButton);
				pauseButton.addEventListener(MouseEvent.CLICK, onClickPause);
			}
			else {
				addChild(messageBox);
				centerTextField(messageBox);
				
				addChild(homeButton);
				homeButton.addEventListener(MouseEvent.CLICK, onClickHome);
			}
			
			
		}
		
		private function centerTextField(aTextField:TextField):void {
			aTextField.x = stage.stageWidth / 2 - aTextField.width/2;  
			aTextField.y = stage.stageHeight / 4;
		}
		
		
		private function hitGround(evt:LanderEvent):void {
			var angleDiff:Number = Math.abs(marsLander.rotation*Math.PI / 180.0 - vector2d.getAngle(levelData.landPt1, levelData.landPt2));
			trace("Angle diff: " + angleDiff);
			trace("Max angle: " + MAX_ROTATION);
			
			if (angleDiff > MAX_ROTATION) {
				messageBox.text = "You crashed and died cause your angle was off!"; 
			}
			else if (marsLander.vel.magnitude() > MAX_SPEED) 
				 {
				messageBox.text = "You crashed and died cause you were going too fast!"; 
				trace("You crashed!"); 
			}
			else if (!landingPad.hitTestPoint(marsLander.localToGlobal(marsLander.hitPoints[2]).x, marsLander.localToGlobal(marsLander.hitPoints[2]).y, true) 
					&& !landingPad.hitTestPoint(marsLander.localToGlobal(marsLander.hitPoints[3]).x, marsLander.localToGlobal(marsLander.hitPoints[3]).y, true)) {
					messageBox.text = "Your legs didn't hit the landing area!";
					trace ("Legs didn't hit landing area!");
				}
			else {
				messageBox.text = "You win!"; 
				trace("You win!");
			}
			
			centerTextField(messageBox); 
			addChild(messageBox);
				
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			marsLander.stop();
			
			if (contains(pauseButton)) {
				removeChild(pauseButton);
				pauseButton.removeEventListener(MouseEvent.CLICK, onClickPause);
			}
			
			addChild(homeButton);
			homeButton.addEventListener(MouseEvent.CLICK, onClickHome);
			
			gameOver = true; 
			
		}
		
		private function enterFrame(evt:Event):void {
			
			speedBox.htmlText = "<b>Keep your speed under 10 m/s!</b>\n" 
								+ "<i>Current speed:</i> " + marsLander.vel.magnitude().toFixed(2) + " m/s"; 
			
			for each (var pt:Point in marsLander.hitPoints)  {
				if (ground.hitTestPoint(marsLander.localToGlobal(pt).x, marsLander.localToGlobal(pt).y, true)) 
					dispatchEvent(new LanderEvent(LanderEvent.HIT_GROUND_EVENT));
					
				else if (landingPad.hitTestPoint(marsLander.localToGlobal(pt).x, marsLander.localToGlobal(pt).y, true)) 
					dispatchEvent(new LanderEvent(LanderEvent.HIT_GROUND_EVENT));
					
				}
				
			
		}
		
		public function loadLevel(ld:LevelData):void {
			this.levelData = ld; 
			
			ground.graphics.beginFill(ld.groundColor);
			
			ground.graphics.lineStyle(ld.groundLineThickness, ld.groundLineColor);
			ground.graphics.moveTo(ld.groundPoints[0].x, ld.groundPoints[0].y);
			
			trace("Ground color: " + ld.groundColor.toString(16));
			
			for (var i:int = 1; i < ld.groundPoints.length; i++) 
				ground.graphics.lineTo(ld.groundPoints[i].x, ld.groundPoints[i].y);
			
			
			ground.graphics.lineTo(ld.groundPoints[0].x, ld.groundPoints[0].y);
			ground.graphics.endFill();
			
			//Draw landing pad
			
			landingPad.graphics.lineStyle(ld.landingThickness, ld.landingColor);
			landingPad.graphics.moveTo(ld.landPt1.x, ld.landPt1.y); 
			landingPad.graphics.lineTo(ld.landPt2.x, ld.landPt2.y);
			
		}
		
		public function loadLevelState(ls:LevelState):void {
			if (ls!=null) {
				marsLander.x = ls.landerPosition.x; 
				marsLander.y = ls.landerPosition.y; 
				marsLander.rotation = ls.landerRotation; 
				marsLander.vel = ls.landerVelocity; 
				gameOver = ls.gameOver; 
				messageBox.text = ls.messageStr;
				speedBox.text = ls.speedBoxStr; 
			}
		}
		
		public function dumpLevelState():LevelState {
			return new LevelState(new vector2d(marsLander.x, marsLander.y), marsLander.vel, marsLander.rotation, gameOver, messageBox.text, speedBox.text);
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
			
			
		}

				
	}
	
}
