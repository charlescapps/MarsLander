package levelMaker {
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.*; 

	/**
	 * @author charles
	 */
	public class CCScrollBox extends Sprite {
		
		public var currentValue:Object; 
		
		private var p_scrollExtent:Rectangle; 
		private var p_imageVec:Vector.<Bitmap>;
		
		private var p_upImg:Bitmap; 
		private var p_imageSprite:Sprite;
		private var p_downImg:Bitmap; 
		private var p_values:Array;  
		private var p_nudgePixels:int; 
		private var p_glowColor:uint;
		
		private var glowFilter:GlowFilter;
		
		//Filter Constants
		private static const STRENGTH:Number = 6; 
		private static const BLUR:Number = 24; 
		private static const ALPHA:Number = .8;
		
		public function CCScrollBox(location:Point, scrollExtent:Rectangle, upImg:Bitmap, downImg:Bitmap, 
									imageVec:Vector.<Bitmap>, values:Array, nudgePixels:int, glowColor:uint) {
										
			//Initialize value to first value in array
			if (values.length > 0)
				currentValue = values[0];
			
			//Just copy values/referaddEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);ences over
			p_scrollExtent = scrollExtent.clone(); 
			p_upImg = upImg; 
			p_downImg = downImg; 
			p_imageVec = imageVec.slice(); 
			p_nudgePixels = nudgePixels; 
			p_values = values.slice(); 
			p_glowColor = glowColor; 
			
			//Create glow filter based on given color
			glowFilter = new GlowFilter(glowColor);
			glowFilter.inner = true;
			glowFilter.strength = STRENGTH;
			glowFilter.blurX = glowFilter.blurY = BLUR; 
			glowFilter.alpha = ALPHA;
			
			//Actual image inside scrollable area is bounded by p_scrollExtent rectangle
			p_imageSprite = new Sprite();
			p_imageSprite.y = p_upImg.height;
			
			//Set y location for down arrow
			p_downImg.y = p_upImg.height + p_scrollExtent.height;
			
			//Throw message if length of image vector doesn't match length of value array
			if (p_values.length != p_imageVec.length)
				trace("The images don't match up with the values!"); 
			
			//Add each image inside the imageSprite
			var currentY:int = 0;
			for (var i:int = 0; i < imageVec.length; i++) {
				p_imageVec[i].y = currentY;  
				p_imageSprite.addChild(p_imageVec[i]); 
				currentY+=p_imageVec[i].height; 
			}
			
			//Now that we know the total image height (after adding images from imageVec),
			//we can set the location of the up arrow
			p_imageSprite.scrollRect = p_scrollExtent.clone(); 
			
			addChild(p_downImg);
			addChild(p_imageSprite);
			addChild(p_upImg);
			
			//Overall scroll box is bounded by extent Rectangle
			this.x = location.x; 
			this.y = location.y; 
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			p_imageSprite.addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		//Add glow filter if clicked--remove glow filters from every other image
		private function onClick(me:MouseEvent):void {
			var tmpFilters:Array;
			for (var j:int = 0; j < p_imageVec.length; j++) {
				if (mouseInDisplayObj(p_imageVec[j])) {
					tmpFilters = p_imageVec[j].filters; 
					if (tmpFilters==null)
						tmpFilters = new Array();
					if (tmpFilters.length == 0)
						tmpFilters.push(glowFilter);
					p_imageVec[j].filters = tmpFilters; 
					
					currentValue = p_values[j];
					break; 
				}
			}
			
			for (var i:int = 0; i < p_imageVec.length; i++) {
				if (i != j) 
					p_imageVec[i].filters = new Array(); 
				
			}
		}
		
		
		private function onMouseDown(evt:MouseEvent):void {
			if (mouseInDisplayObj(p_downImg)) {
				addEventListener(Event.ENTER_FRAME, autoNudgeDown);
				stage.addEventListener(MouseEvent.MOUSE_UP, removeAutoEvents);
			}
			else if (mouseInDisplayObj(p_upImg)) {
				addEventListener(Event.ENTER_FRAME, autoNudgeUp);
				stage.addEventListener(MouseEvent.MOUSE_UP, removeAutoEvents);
			}
		}
		
		private function removeAutoEvents(me:MouseEvent):void {
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, autoNudgeUp);
			
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, autoNudgeDown);
				
			if (stage!= null)
				stage.removeEventListener(MouseEvent.MOUSE_UP, removeAutoEvents);
		}
		

		
		private function autoNudgeDown(evt:Event):void {
			var r:Rectangle = p_imageSprite.scrollRect;
			r.y += p_nudgePixels; 
			if (r.y > p_imageVec[p_imageVec.length-1].y)
				r.y = p_imageVec[p_imageVec.length-1].y;
				
			p_imageSprite.scrollRect = r;
		}
		
		private function autoNudgeUp(evt:Event):void {
			var r:Rectangle = p_imageSprite.scrollRect;
			r.y -= p_nudgePixels; 
			
			if (r.y < 0)
				r.y = 0; 
				
			p_imageSprite.scrollRect = r;
		}
		
		private function mouseInDisplayObj(d:DisplayObject):Boolean {
			if (d.parent.mouseX >= d.x && d.parent.mouseX <= d.x + d.width && d.parent.mouseY >= d.y && d.parent.mouseY <= d.y+d.height)
				return true;
			return false; 
			
		}
		
		
	}
}