package lander {
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Bitmap; 
	import flash.geom.Rectangle; 
	import levelMaker.CCButton; 
	import landerEvents.*;

	/**
	 * @author charles
	 */
	 [SWF (width="1024",height="768",framerate="60")]
	public class HomeScreen extends Sprite {
		
		//Static variable so home screen knows if resume button should be active
		public static var resumeButtonActive:Boolean = false; 
		
		private const imageFactory:ImageFactory = ImageFactory.getInstance();
		private var homeImage:Bitmap = imageFactory.homeScreenImg;  
		
		private var newGameButton:CCButton = new CCButton("New Game", 0xff8888, 0xff0000, 30, 0x00ff00, new Rectangle(512 - 100, 384 - 25, 200, 50), 0x666666); 
		private var resumeButton:CCButton = new CCButton("Resume Game", 0x666666, 0x666666, 30, 0x00ff00, new Rectangle(512 - 125, 384 + 50, 250, 50), 0x666666);
		private var settingsButton:CCButton = new CCButton("Settings", 0xff8888, 0xff0000, 30, 0x00ff00, new Rectangle(512 - 100, 384 + 125, 200, 50), 0x666666);
		
		
		
		public function HomeScreen() {
			addChild(homeImage);
			addChild(newGameButton);
			addChild(settingsButton); 
			addChild(resumeButton);
			
			settingsButton.addEventListener(MouseEvent.CLICK, clickSettings);
			newGameButton.addEventListener(MouseEvent.CLICK, clickNewGame);
			
			if (resumeButtonActive) {
				activateResumeButton();
			}
		}
		
		public function activateResumeButton():void {
			resumeButton.downColor = 0xff0000;
			resumeButton.upColor = 0xff8888;
			resumeButton.refresh();
			
			resumeButton.addEventListener(MouseEvent.CLICK, clickResume);
		}
		
		public function dispose():void {
			if (settingsButton.hasEventListener(MouseEvent.CLICK))
				settingsButton.removeEventListener(MouseEvent.CLICK, clickSettings); 
				
			if (newGameButton.hasEventListener(MouseEvent.CLICK))
				newGameButton.removeEventListener(MouseEvent.CLICK, clickNewGame);
				
			if (resumeButton.hasEventListener(MouseEvent.CLICK))
				resumeButton.removeEventListener(MouseEvent.CLICK, clickResume); 
				
			homeImage = null; 
		}
		
		private function clickResume(evt:MouseEvent):void {
			dispatchEvent(new LanderEvent(LanderEvent.RESUME_GAME));
		} 
		
		private function clickSettings(evt:MouseEvent):void {
			dispatchEvent(new LanderEvent(LanderEvent.GO_TO_SETTINGS));
		}
		
		private function clickNewGame(evt:MouseEvent):void {
			dispatchEvent(new LanderEvent(LanderEvent.START_GAME));
		}
	}
}
