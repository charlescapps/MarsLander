package ccui{
	import com.pblabs.rendering2D.ui.PBButton;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent; 

	/**
	 * @author charles
	 */
	public class CCButton extends PBButton {
		private var p_downColor:uint; 
		private var p_upColor:uint; 
		private var p_upText:String;
		private var p_hoverColor:uint;  
		private var p_propogate:Boolean; 
		
		public function CCButton(text:String, upColor:uint, downColor:uint, hoverColor:uint, fontSiz:int, fontCol:uint, rec:Rectangle, 
										 propogate:Boolean = true) {
			super(); 
			this.label = this.p_upText = text; 
			this.color = this.p_upColor = upColor; 
			this.p_downColor = downColor; 
			this.fontSize = fontSiz; 
			this.fontColor = fontCol; 
			this.extents = rec; 
			
			p_propogate = propogate;
			
			this.p_hoverColor = hoverColor; 
			
			this.refresh();  
			
			//Add event listeners
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onUp);
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver );
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut );
		}
		
		//Dispose-- remove event listeners
		
		public function dispose():void {
			if (hasEventListener(MouseEvent.MOUSE_DOWN))
				removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				
			if (hasEventListener(MouseEvent.MOUSE_UP))
				removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			if (hasEventListener(MouseEvent.MOUSE_OVER))
				removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				
			if (hasEventListener(MouseEvent.MOUSE_OUT))
				removeEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		//*************Setters and Getters for down properties*******************
		
		public function get downColor():uint {
			return p_downColor; 
		}
		
		public function set downColor(col:uint):void {
			p_downColor = col; 
		}
		
		
		//*****************Setters and getters for Up Properties*********************
		
		public function get upColor():uint {
			return p_upColor; 
		}
		
		public function set upColor(col:uint):void {
			this.color = p_upColor = col; 
		}
		
		public function get upText():String {
			return p_upText; 
		}
		
		public function set upText(txt:String):void {
			p_upText = txt; 
		}
		
		
		//********************Mouse Events*********************8*****
		
		private function onDown(evt:MouseEvent):void {
			
			
			this.color = p_downColor; 
			
			this.refresh();
			
			if (!p_propogate)
				evt.stopImmediatePropagation();
				
		}
		
		private function onUp(evt:MouseEvent):void {
			
			this.color = p_upColor; 
			
			this.refresh();
			if (!p_propogate)
				evt.stopImmediatePropagation();
				
		}
		
		private function onOver(evt:MouseEvent):void {
			this.color = p_hoverColor; 
			this.refresh();
			
			if (!p_propogate)
				evt.stopImmediatePropagation();
			
		}
		
		private function onOut(evt:MouseEvent):void {
			this.color = p_upColor; 
			this.refresh();
			
			if (!p_propogate)
				evt.stopImmediatePropagation();
		}
	}
}
