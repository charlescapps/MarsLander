package lander {
	import vector.*;
	import flash.text.TextField; 
	import flash.text.TextFormat; 
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import landerEvents.*;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author charles
	 */
	public class Level extends Sprite {
		
		private const LANDER_START:vector2d = new vector2d(200, 100);
		private const GROUND_START:vector2d = new vector2d(0, 600); 
		private const SPEED_START:vector2d = new vector2d(500 , 25);
		
		
		private const MAX_SPEED:int = 10; 
		private const MAX_ROTATION:int = 15;
		
		private var marsLander:MarsLander; 
		private var ground:Sprite; 
		
		private var messageBox:TextField;
		private var speedBox:TextField; 
		private var textFormat:TextFormat; 
		private var textFormat2:TextFormat; 
		
		public function Level() {
			//initialize variables
			marsLander = new MarsLander(); 
			marsLander.x = LANDER_START.x; 
			marsLander.y = LANDER_START.y; 
			
			ground = new Sprite();
			ground.y = GROUND_START.y;
			ground.x = GROUND_START.x;
			
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
			addChild(speedBox);
			
			//Add events
			addEventListener(Event.ENTER_FRAME, enterFrame);
			addEventListener(LanderEvent.HIT_GROUND_EVENT, hitGround);
			
		}
		
		public function afterAddedToStage():void {
			marsLander.afterAddedToStage(); 
			
			ground.graphics.beginFill(0xff3333);
			ground.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight - ground.y); 	
		}
		
		public function centerTextField(aTextField:TextField):void {
			aTextField.x = stage.stageWidth / 2 - aTextField.width/2;  
			aTextField.y = stage.stageHeight / 4;
		}
		
		
		private function hitGround(evt:LanderEvent):void {
			if (marsLander.vel.magnitude() > MAX_SPEED || Math.abs(marsLander.rotation) > MAX_ROTATION ) {
				messageBox.text = "You crashed and died!"; 
				trace("You crashed!"); 
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
			
			if (marsLander.y > GROUND_START.y || marsLander.hitTestObject(ground))
				dispatchEvent(new LanderEvent(LanderEvent.HIT_GROUND_EVENT));
				
			
		}
	}
}
