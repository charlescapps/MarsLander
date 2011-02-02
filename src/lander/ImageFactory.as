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
		
		[Embed(source="../../resources/easy.png")]
		private var EasyScrollImg:Class; 
		
		[Embed(source="../../resources/normal.png")]
		private var NormalScrollImg:Class; 
		
		[Embed(source="../../resources/hard.png")]
		private var HardScrollImg:Class; 
		
		[Embed(source="../../resources/impossible.png")]
		private var ImpossibleScrollImg:Class; 
		
		[Embed(source="../../resources/up.png")]
		private var UpScrollImg:Class; 
		
		[Embed(source="../../resources/down.png")]
		private var DownScrollImg:Class; 
		
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
		
		public function get easyScrollImg():Bitmap {
			return new EasyScrollImg() as Bitmap; 
		}
		
		public function get normalScrollImg():Bitmap {
			return new NormalScrollImg() as Bitmap; 
		}
		
		public function get hardScrollImg():Bitmap {
			return new HardScrollImg() as Bitmap; 
		}
		
		public function get impossibleScrollImg():Bitmap {
			return new ImpossibleScrollImg() as Bitmap; 
		}
		
		public function get upScrollImg():Bitmap {
			return new UpScrollImg() as Bitmap; 
		}
		
		public function get downScrollImg():Bitmap {
			return new DownScrollImg() as Bitmap; 
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
