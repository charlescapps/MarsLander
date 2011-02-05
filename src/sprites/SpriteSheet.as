package sprites {
	import flash.display.Sprite;
	import flash.display.Bitmap; 
	import flash.geom.*; 

	/**
	 * @author charles
	 */
	public class SpriteSheet extends Sprite {
		
		protected var bmp:Bitmap; 
		private var xJump:int; 
		private var yJump:int; 
		private var rows:int; 
		private var cols:int;
		private var spriteLocations:Object = new Object();
		
		public function SpriteSheet(spriteSheet:Bitmap, viewRect:Rectangle, spacing:Point, numRows:int, numCols:int) {
			
			bmp = spriteSheet;
			bmp.scrollRect = viewRect;
			xJump = spacing.x; 
			yJump = spacing.y;
			rows = numRows;
			cols = numCols;  
			 
		}
		
		//Rows and Columns begin at 0
		public function goToSprite(rowAndCol:Point):void {
			if (rowAndCol.x >= rows || rowAndCol.x < 0 || rowAndCol.y >= cols || rowAndCol.y < 0) {
				trace("Invalid row, col entered for Sprite Sheet access!");
				return;
			}
			var sr:Rectangle = bmp.scrollRect; 
			sr.x = rowAndCol.y*xJump;
			sr.y = rowAndCol.x*yJump;  
			bmp.scrollRect = sr;
		}
		
		public function setLoc(key:String, row:int, col:int ):void {
			spriteLocations[key] = new Point(row, col); 
		}
		
		public function getCurrentPoint():Point {
			var r:Rectangle = bmp.scrollRect;
			return new Point(r.x, r.y); 
		}
		
		public function loadSprite(key:String):void {
			if (spriteLocations[key] == null) {
				trace("No such sprite key exists");
				return;
			}
			goToSprite(spriteLocations[key]);
		}
		
		public function draw():void {
			addChild(bmp);
		}
		
		public function hide():void {
			if (contains(bmp))
				removeChild(bmp);
		}
	}
}
