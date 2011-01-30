package lander {
	import flash.display.Bitmap; 
	/**
	 * @author charles
	 */
	public class ImageFactory {
		[Embed(source="../../resources/lander.png")]
		private var LanderImg:Class; 
		
		[Embed(source="../../resources/lander_thrust.png")]
		private var LanderThrustImg:Class; 
		
		[Embed(source="../../resources/home_screen.png")]
		private var HomeScreenImg:Class; 
		
		[Embed(source="../../resources/settings_screen.png")]
		private var SettingsScreenImg:Class; 
		
		private static var theInstance:ImageFactory = null;
		
		public function ImageFactory(x:oneFactory) {
		}
		
		public static function getInstance():ImageFactory {
			if (theInstance == null) 
				theInstance = new ImageFactory(new oneFactory());  
			
			return theInstance;
		}
		
		public function get landerImg():Bitmap {
			return new LanderImg() as Bitmap;  
		}
		
		public function get landerThrustImg():Bitmap {
			return new LanderThrustImg() as Bitmap; 
		}
		
		public function get homeScreenImg():Bitmap {
			return new HomeScreenImg() as Bitmap; 
		}
		
		public function get settingsScreenImg():Bitmap {
			return new SettingsScreenImg() as Bitmap; 
		}
		
		public function toString():String {
			return "Image factory exists!";
		}
	}
}

internal class oneFactory {
	public function oneFactory() {
			
	}
}
