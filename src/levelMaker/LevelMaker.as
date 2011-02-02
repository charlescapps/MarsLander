package levelMaker {
	
	import flash.display.Sprite;
	import lander.LevelData;
	import lander.Constants; 
	import flash.events.MouseEvent;
	import flash.text.TextField; 
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize; 

	import flash.events.KeyboardEvent;
	import flash.geom.*; 
	import vector.*;  	
	import ccui.*;
	
	

	/**
	 * @author charles
	 */
	 [SWF (width="1124",height="868")]
	public class LevelMaker extends Sprite {
		
		private var ld:LevelData;
		private var groundColorInput:CCColorInput; 
		private var addPointsButton:CCToggleButton; 
		private var completeButton:CCButton; 
		
		private var finalTextFormat:TextFormat; 
		
		private var addPoints:Boolean; 
		
		private var finalXML:TextField; 
		
		public function LevelMaker() {
			ld = new LevelData();
			
			addPoints = false; 
			
			//Set up color input boxes
			groundColorInput = new CCColorInput("Ground color:", 0x000000, "000000");
			groundColorInput.x = 100; 
			groundColorInput.y = 50; 
			groundColorInput.addEventListener(KeyboardEvent.KEY_UP, keyUpGroundColor );
			addChild(groundColorInput);
			
			// Set default line style to black 
			graphics.lineStyle(2, 0x000000);
			
			//Set up buttons
			
			addPointsButton = new CCToggleButton("ADD POINTS: NO", "ADD POINTS: YES", 0xaaffaa, 0x11ff11, 0xaaaaff, 24, 0x000000, 
													new Rectangle(400, 50, 225, 50), true);
			
			
			completeButton = new CCButton("COMPLETE", 0xaaffaa, 0x11ff11, 0xaaaaff, 24, 0x000000, 
											new Rectangle(650, 50, 225, 50), true );
											
			addPointsButton.addEventListener(MouseEvent.CLICK, toggleClick);
			completeButton.addEventListener(MouseEvent.CLICK, completeClick);
	
			addChild(completeButton);
			addChild(addPointsButton);
			
			
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
				
				ld.groundPoints.push(new vector2d(parseInt(mouseX.toFixed(0)), parseInt(mouseY.toFixed(0)))); 
			}
			
		}
		
		private function toggleClick(evt:MouseEvent):void {
			
			addPoints = !addPoints; 
			
			evt.stopImmediatePropagation();
		}
		
		private function completeClick(evt:MouseEvent):void {
			
			finalXML.text = ld.toXML().toXMLString();
			
			addChild(finalXML); 
			
			removeChild(addPointsButton); 
			removeChild(completeButton);
			removeChild(groundColorInput);
			graphics.clear();
			
			evt.stopImmediatePropagation();
		}
		
		private function keyUpGroundColor(evt:KeyboardEvent):void {
			graphics.lineStyle(2, groundColorInput.colorValue);
			ld.groundColor = groundColorInput.colorValue; 
			
		}
		
		
	}
}
