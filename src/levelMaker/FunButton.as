package levelMaker {
	import flash.text.TextField; 
	import flash.text.TextFormat; 
	import flash.display.Sprite; 
	import flash.display.SimpleButton; 
	/**
	 * @author charles
	 */
	 
	public class FunButton extends SimpleButton {
		private var textUp:TextField;
		private var textDown:TextField;
		private var textOver:TextField; 
		
		public function FunButton(words:String, textFormat:TextFormat, width:int, height:int, 
									borderColor:int, upColor:int, downColor:int, overColor:int) {
			super();
			
			textUp = new TextField();
			textDown = new TextField();
			textOver = new TextField(); 
			
			setText(textUp, words, textFormat, width, height);
			setText(textDown, words, textFormat, width, height);
			setText(textOver, words, textFormat, width, height);
			
			upState = new Sprite(); 
			downState = new Sprite(); 
			overState = new Sprite(); 
			
			hitTestState = overState;
			
			this.drawARect(upState as Sprite, width, height, upColor, borderColor);
			this.drawARect(downState as Sprite, width, height, downColor, borderColor);
			this.drawARect(overState as Sprite, width, height, overColor, borderColor);
			
			(downState as Sprite).addChild(textUp); 
			(overState as Sprite).addChild(textDown);
			(upState as Sprite).addChild(textOver);
			
			
		}
		
		public function setButtonText(str:String) {
			textUp.text = textDown.text = textOver.text = str; 
		}
	
		private function setText(tf:TextField, words:String, format:TextFormat, width:int, height:int):void {
			tf.text = words; 
			tf.width = width; 
			tf.height = height; 
			tf.setTextFormat(format);
			tf.defaultTextFormat = format;
		}
	
		private function drawARect(spr:Sprite, width:int, height:int, color:int, borderColor:int):void {
			spr.graphics.beginFill(color); 
			spr.graphics.lineStyle(2, borderColor);
			spr.graphics.drawRect(0, 0, width, height); 
		}
	}

}
