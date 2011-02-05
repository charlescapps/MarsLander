package ccui {
	import flash.display.Sprite;
	import flash.text.*; 
	import flash.events.MouseEvent;

	/**
	 * @author charles
	 */
	public class CCModalDialog extends Sprite {
	
		private var mainText:TextField = new TextField();
		private var theFormat:TextFormat;   
		private var p_bgColor:uint;
		private var p_bgAlpha:Number; 
		 
		public function CCModalDialog( yPos:int, textHTML:String, 
										fontFam:String, fontSiz:int, fontCol:uint, textbgColor:uint, 
										bgColor:uint, bgAlpha:Number, borderCol:uint, 
										leftMar:int = 25, rightMar:int = 25) {
			theFormat = new TextFormat(fontFam, fontSiz, fontCol); 
			theFormat.leftMargin = leftMar; 
			theFormat.rightMargin = rightMar; 
			
			mainText.defaultTextFormat = theFormat; 
			
			mainText.htmlText = textHTML; 
			mainText.autoSize = TextFieldAutoSize.LEFT;

			mainText.y = yPos; 
			mainText.background = true; 
			mainText.backgroundColor = textbgColor; 
			mainText.border = true; 
			mainText.borderColor = borderCol; 
			mainText.selectable = false; 
			
			p_bgColor= bgColor;
			p_bgAlpha = bgAlpha;  
			
			addEventListener(MouseEvent.CLICK, onClickOutside);
			
		}
		
		public function dispose():void {
			if (hasEventListener(MouseEvent.CLICK))
				removeEventListener(MouseEvent.CLICK, onClickOutside);
				
			mainText = null; 
			theFormat = null; 
		}
		
		private function onClickOutside(evt:MouseEvent):void {
			if (mouseX < mainText.x || mouseX > (mainText.x + mainText.width) || mouseY < mainText.y || mouseY > (mainText.y + mainText.height) )
				parent.removeChild(this);
		}
		
		public function popup():void {
			this.graphics.clear();
			this.graphics.beginFill(p_bgColor, p_bgAlpha); 
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			mainText.x = stage.stageWidth / 2.0 - mainText.width / 2.0; 
			
			if (contains(mainText))
				removeChild(mainText);
				
			addChild(mainText);

			
		}
	}
}
