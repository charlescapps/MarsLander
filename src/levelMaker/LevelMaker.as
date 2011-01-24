package levelMaker {
	
	import flash.display.Sprite;
	import lander.LevelData;
	import lander.Constants; 
	import flash.events.MouseEvent;
	import flash.text.TextField; 
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize; 
	import flash.text.TextFormatAlign; 
	import flash.events.KeyboardEvent; 
	import vector.*;  	
	
	

	/**
	 * @author charles
	 */
	 [SWF (width="1124",height="868")]
	public class LevelMaker extends Sprite {
		
		private var ld:LevelData;
		private var groundColorInput:ColorInput; 
		private var addPointsButton:FunButton; 
		private var completeButton:FunButton; 
		
		private var textFormat:TextFormat; 
		
		private var finalTextFormat:TextFormat; 
		
		private var addPoints:Boolean; 
		
		private var finalXML:TextField; 
		
		public function LevelMaker() {
			ld = new LevelData();
			
			addPoints = false; 
			
			//Set up color input boxes
			groundColorInput = new ColorInput("Ground color:", 0x000000, "000000");
			groundColorInput.x = 100; 
			groundColorInput.y = 50; 
			groundColorInput.addEventListener(KeyboardEvent.KEY_UP, keyUpGroundColor );
			addChild(groundColorInput);
			
			// Set default line style to black 
			graphics.lineStyle(2, 0x000000);
			
			//Set up buttons
			
			textFormat = new TextFormat(); 
			textFormat.size = 20; 
			textFormat.font = "Impact";
			textFormat.bold = true; 
			textFormat.align = TextFormatAlign.CENTER;
			
			addPointsButton = new FunButton("ADD POINTS: NO", textFormat, 175, 30, 0x000000, 0xffffff, 0xaaaaaa, 0xdddddd );
			addPointsButton.x = 400; 
			addPointsButton.y = 50; 
			addChild(addPointsButton);
			addPointsButton.addEventListener(MouseEvent.CLICK, buttonClick);
			
			completeButton = new FunButton("COMPLETE", textFormat, 175, 30, 0x000000, 0xffffff, 0xaaaaaa, 0xdddddd );
			completeButton.x = 700; 
			completeButton.y = 50; 
			addChild(completeButton);
			completeButton.addEventListener(MouseEvent.CLICK, completeClick);
			
			//Set up text field
			
			finalXML = new TextField(); 
			finalTextFormat = new TextFormat(); 
			finalXML.autoSize = TextFieldAutoSize.LEFT; 
			
			
			//Draw bounding rectangle
			
			graphics.drawRect(0, 0, Constants.STAGE_WIDTH, Constants.STAGE_HEIGHT); 
			
			//Add events
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		private function onClick(evt:MouseEvent):void {
			if (addPoints) {
				if (ld.groundPoints.length == 0) {
					//Draw green circle around initial point
					graphics.beginFill(0x00ff00);
					graphics.drawCircle(mouseX, mouseY, 5);
					graphics.moveTo(mouseX, mouseY);
				} 
				else {
					graphics.lineTo(mouseX, mouseY);
					graphics.moveTo(mouseX, mouseY);
				} 
				
				ld.groundPoints.push(new vector2d(mouseX, mouseY)); 
			}
			
		}
		
		private function buttonClick(evt:MouseEvent):void {
			
				
			addPoints = !addPoints; 
			
			if (addPoints)
				addPointsButton.setButtonText ("ADD POINTS: YES"); 
			else
				addPointsButton.setButtonText ("ADD POINTS: NO"); 
			
			evt.stopImmediatePropagation();
		}
		
		private function completeClick(evt:MouseEvent):void {
			
			finalXML.text = ld.toXML().toXMLString();
			
			addChild(finalXML); 
			
			
			
			evt.stopImmediatePropagation();
		}
		
		private function keyUpGroundColor(evt:KeyboardEvent):void {
			graphics.lineStyle(2, groundColorInput.colorValue);
			ld.groundColor = groundColorInput.colorValue; 
			
		}
		
		
	}
}
