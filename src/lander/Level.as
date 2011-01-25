package lander {
	import vector.*;
	import flash.text.TextField; 
	import flash.text.TextFormat; 
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import landerEvents.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author charles
	 */
	public class Level extends Sprite {
		
		private const LANDER_START:vector2d = new vector2d(200, 100);
		private const SPEED_START:vector2d = new vector2d(500 , 25);
		
		private const MAX_SPEED:int = 10; 
		private const MAX_ROTATION:Number = 15*Math.PI / 180.0 ;
		
		private var marsLander:MarsLander; 
		private var ground:Sprite; 
		private var landingPad:Sprite; 
		
		private var messageBox:TextField;
		private var speedBox:TextField; 
		private var textFormat:TextFormat; 
		private var textFormat2:TextFormat; 
		
		private var levelData:LevelData; 
		
		public function Level() {
			trace("Testing git2");
			//initialize variables
			marsLander = new MarsLander(); 
			marsLander.x = LANDER_START.x; 
			marsLander.y = LANDER_START.y; 
			
			ground = new Sprite();
			landingPad = new Sprite();
			
			//Initialize text field and format
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
			
			//Add events
			addEventListener(Event.ENTER_FRAME, enterFrame);
			addEventListener(LanderEvent.HIT_GROUND_EVENT, hitGround);
			
		}
		
		public function afterAddedToStage():void {
			marsLander.afterAddedToStage(); 
				
		}
		
		
		public function centerTextField(aTextField:TextField):void {
			aTextField.x = stage.stageWidth / 2 - aTextField.width/2;  
			aTextField.y = stage.stageHeight / 4;
		}
		
		
		private function hitGround(evt:LanderEvent):void {
			var angleDiff:Number = Math.abs(marsLander.rotation*Math.PI / 180.0 - vector2d.getAngle(levelData.landPt1, levelData.landPt2));
			trace("Angle diff: " + angleDiff);
			trace("Max angle: " + MAX_ROTATION);
			
			if (angleDiff > this.MAX_ROTATION) {
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
		
	}
}
