package levelMaker {
	import com.pblabs.rendering2D.ui.PBButton;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent; 

	/**
	 * @author charles
	 */
	public class CCToggleButton extends PBButton {
		private var p_downColor:uint; 
		private var p_downText:String; 
		private var p_upColor:uint; 
		private var p_upText:String;
		private var p_hoverColor:uint; 
		
		private var p_propogate:Boolean;
		
		private var p_isDown:Boolean; 
		
		public function CCToggleButton(upText:String, downText:String, upColor:uint, downColor:uint, fontSiz:int, fontCol:uint, rec:Rectangle, 
										hoverColor:uint, propogate:Boolean = true) {
			super(); 
			this.label = this.p_upText = upText; 
			this.p_downText = downText; 
			this.color = this.p_upColor = upColor; 
			this.p_downColor = downColor; 
			this.fontSize = fontSiz; 
			this.fontColor = fontCol; 
			this.extents = rec; 
			p_propogate = propogate; 
			
			this.p_hoverColor = hoverColor; 
			
			this.refresh(); 
			
			p_isDown = false; 
			
			//Add event listeners
			
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver );
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut );
		}
		
		//*************Setters and Getters for down properties*******************
		
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
		
		//*****************Setters and getters for Up Properties*********************
		
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
		
		public function get isDown():Boolean {
			return p_isDown;
		}
		
		public function set isDown(down:Boolean):void {
			if (down!=p_isDown) {
				p_isDown = !p_isDown; 
				
				if (p_isDown) {
					 this.label = p_downText; 
					 this.color = p_downColor; 
				}
				else {
					this.label = p_upText; 
					this.color = p_upColor; 
				}
				this.refresh();
			}
		}
		
		//********************Mouse Events*********************8*****
		
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
			this.refresh();
			
			if (!p_propogate)
				evt.stopImmediatePropagation();
				
		}
		
		private function onOver(evt:MouseEvent):void {
			if (!p_isDown) {
				this.color = p_hoverColor; 
				this.refresh();
			}
			
			if (!p_propogate)
				evt.stopImmediatePropagation();
		}
		
		private function onOut(evt:MouseEvent):void {
			if (!p_isDown) {
				this.color = p_upColor; 
				this.refresh();
			}
			
			if (!p_propogate)
				evt.stopImmediatePropagation();
		}
	}
}
