package vector{
	/**
	 * @author charles
	 */
	public class vector2d {
		private var _x:Number; 
		private var _y:Number; 
		
		public function get x():Number {return _x;}
		
		public function get y():Number {return _y;} 
		
		public function set x(new_x:Number):void {_x = new_x;}
		
		public function set y(new_y:Number):void {_y = new_y;}
		
		public function vector2d(new_x:Number, new_y:Number) {
			_x = new_x; 
			_y = new_y; 
		}
		
		public function divide(dividend:Number):vector2d {
			_x /= dividend; 
			_y /= dividend; 
			return this;
		}
		
		public function multiply(factor:Number):vector2d {
			_x *= factor;
			_y *= factor;
			return this;
		}
		
		public function add(vec:vector2d):vector2d {
			_x += vec.x; 
			_y += vec.y; 
			return this;
		}
		
		public static function add(vec1:vector2d, vec2:vector2d):vector2d {
			return new vector2d(vec1.x + vec2.x, vec1.y + vec2.y);
		}
		
		public function get_unit_vec():vector2d {
			return new vector2d(_x / magnitude(), _y / magnitude());
		}
		
		public function magnitude():Number {
			return Math.sqrt(_x*_x + _y*_y); 
		}
		
		public function toXML():XML {
			var xml:XML = new XML(<vector2d />);
			xml.@x = _x; 
			xml.@y = _y; 
			
			return xml; 
		}
	}
}
