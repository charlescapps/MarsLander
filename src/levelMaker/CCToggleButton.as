package {
	import com.pblabs.rendering2D.ui.PBButton;
	import flash.events.MouseEvent; 

	/**
	 * @author charles
	 */
	public class CCToggleButton extends PBButton {
		private var p_downColor:uint; 
		private var p_downText:String; 
		private var p_upColor:uint; 
		private var p_upText:String;
		
		private var p_isDown:Boolean; 
		
		public function CCToggleButton() {
			super(); 
			
			p_isDown = false; 
			
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		//Setters and Getters for down variables
		
		public function get downColor():uint {
			return p_downColor; 
		}
		
		public function set downColor(col:uint):void {
			p_downColor = col; 
		}
		
		public function get downText():String {
			return p_downText; 
		}
		
		public function set downText(txt:String):void {
			p_downText = txt; 
		}
		
		//Setters and getters for Up Color
		
		public function get upColor():uint {
			return p_upColor; 
		}
		
		public function set upColor(col:uint):void {
			p_upColor = col; 
		}
		
		public function get upText():String {
			return p_upText; 
		}
		
		public function set upText(txt:String):void {
			p_upText = txt; 
		}
		
		private function onClick(evt:MouseEvent):void {
			p_isDown = !p_isDown; 
			
			if (p_isDown) {
				 this.label = p_downText; 
				 this.color = p_downColor; 
			}
			else {
				this.label = p_upText; 
				this.color = p_upColor; 
			}
			
			evt.stopImmediatePropagation();
				
		}
	}
}
