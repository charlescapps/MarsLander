package lander {
	import flash.display.Sprite;
	import flash.display.Bitmap; 
	import flash.geom.Rectangle; 
	import levelMaker.CCButton; 

	/**
	 * @author charles
	 */
	 [SWF (width="1024",height="768",framerate="60")]
	public class HomeScreen extends Sprite {
		
		private const imageFactory:ImageFactory = ImageFactory.getInstance();
		private var homeImage:Bitmap = imageFactory.homeScreenImg;  
		
		private var newGameButton:CCButton = new CCButton("New Game", 0xff8888, 0xff0000, 30, 0x00ff00, new Rectangle(512 - 100, 384 - 25, 200, 50), 0x666666); 
		private var settingsButton:CCButton = new CCButton("Settings", 0xff8888, 0xff0000, 30, 0x00ff00, new Rectangle(512 - 100, 450, 200, 50), 0x666666);
		
		public function HomeScreen() {
			addChild(homeImage);
			addChild(newGameButton);
			addChild(settingsButton); 
		}
	}
}
