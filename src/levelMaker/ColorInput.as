package levelMaker {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat; 
	import flash.text.TextFieldType; 
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.events.KeyboardEvent;

	/**
	 * @author charles
	 */
	public class ColorInput extends Sprite {
		private var label:TextField; 
		private var labelFormat:TextFormat;
		
		private var input:TextField; 
		private var inputFormat:TextFormat; 
		
		private var sample:Sprite; 
		
		public var colorValue:int; 
		
		public function ColorInput(labelStr:String, initialColor:uint, initialText:String) {
			colorValue = initialColor; 
			
			label = new TextField();
			label.text = labelStr; 
			label.autoSize = TextFieldAutoSize.LEFT;
			
			labelFormat = new TextFormat();
			labelFormat.align = TextFormatAlign.RIGHT;
			labelFormat.size = 16; 
			labelFormat.bold = true; 
			label.setTextFormat(labelFormat);
			
			input = new TextField(); 
			input.width = 80; 
			input.height = label.height;
			input.type = TextFieldType.INPUT;
			input.border = true; 
			input.borderColor = 0x000000;
			input.multiline = false;
			input.maxChars = 6;
			
			inputFormat = new TextFormat(); 
			inputFormat.size = 16; 
			inputFormat.bold = true; 
			inputFormat.align = TextFormatAlign.LEFT;
			input.defaultTextFormat = inputFormat;
			input.text = initialText;
			
			sample = new Sprite();
			sample.graphics.beginFill(colorValue); 
			sample.graphics.drawCircle(0, 0, label.height/2);
			
			label.x = label.y = 0; 
			input.x = label.width + 5; 
			input.y = 0; 
			sample.x = input.x + input.width + label.height/2 + 5; 
			sample.y = label.height / 2; 
			
			addChild(label); 
			addChild(input);
			addChild(sample);
			
			input.addEventListener(KeyboardEvent.KEY_UP, getColorValue); 
		}
		
		public function redrawColor():void {
			removeChild(sample);
			sample = new Sprite();
			sample.x = input.x + input.width + label.height/2 + 5; 
			sample.y = label.height / 2;
			sample.graphics.beginFill(colorValue); 
			sample.graphics.drawCircle(0, 0, label.height/2);
			addChild(sample);
		}
		
		public function setInputText(str:String):void {
			input.text = str; 
		}
		
		private function getColorValue(evt:KeyboardEvent):void {
			this.colorValue = parseHexInt(input.text); 
			sample.graphics.beginFill(colorValue);
			sample.graphics.drawCircle(0, 0, label.height/2); 
			trace("Color value:" + colorValue);
			trace("Color text:" + input.getLineText(0));
		}
		
		private function parseHexInt(str:String):int {
			var val:int = 0; 
			trace("String length:" + str.length);
			for (var i:int = 0; i < str.length; i++) {
				if (!isHexDigit(str.charCodeAt(i)))
					break;
				
				val = 16*val + hexValue(str.charCodeAt(i));
				
			}
			return val; 
		}
		
		private function isHexDigit(char:int):Boolean {
			if ( 
			   (   (char >= '0'.charCodeAt(0)) && (char <='9'.charCodeAt(0)) ) 
			|| (   (char >='a'.charCodeAt(0) ) && (char <='f'.charCodeAt(0)) ) 
			|| (   (char >='A'.charCodeAt(0) ) && (char <='F'.charCodeAt(0)) )
			   ) {
			   	trace("Valid hex digit found.");
				return true;
			   } 
			else
				return false; 
		}
		
		private function hexValue(char:int):int {
			if (char>= '0'.charCodeAt(0) && char <= '9'.charCodeAt(0))
				return (char - '0'.charCodeAt(0) );
			else if (char>= 'a'.charCodeAt(0) && char <= 'f'.charCodeAt(0) )
				return (char - 'a'.charCodeAt(0) + 10); 
			else if (char >= 'A'.charCodeAt(0) && char <= 'F'.charCodeAt(0))
				return (char - 'A'.charCodeAt(0) + 10); 
			else 
				return -1;  
		}
	}
}
