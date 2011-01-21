package lander {
	import flash.display.Bitmap; 
	/**
	 * @author charles
	 */
	public class ImageFactory {
		[Embed(source="../../resources/lander.png")]
		[Bindable]	
		private var Lander:Class; 
		private const landerImage:Bitmap = new Lander();
		
		[Embed(source="../../resources/lander_thrust.png")]
		[Bindable]	
		private var LanderThrust:Class; 
		private const landerThrustImage:Bitmap = new LanderThrust();
		
		private static var theInstance:ImageFactory = null;
		
		public function ImageFactory(x:oneFactory) {
		}
		
		public static function getInstance():ImageFactory {
			if (theInstance == null) 
				theInstance = new ImageFactory(new oneFactory());  
			
			return theInstance;
		}
		
		public function get landerImg():Bitmap {
			return landerImage; 
		}
		
		public function get landerThrustImg():Bitmap {
			return landerThrustImage;
		}
		
		public function toString() {
			return "Image factory exists!";
		}
		
	}
	
	
}

internal class oneFactory {
	public function oneFactory() {
			
	}
}
