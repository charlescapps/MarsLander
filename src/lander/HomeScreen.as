package lander {
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Bitmap; 
	import flash.geom.Rectangle; 
	import ccui.CCButton;
	import ccui.CCModalDialog;
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
		
		private var newGameButton:CCButton = new CCButton("New Game", 0xff8888, 0xff0000, 0x666666, 30, 0x00ff00, new Rectangle(512 - 100, 384 - 125, 200, 50)); 
		private var resumeButton:CCButton = new CCButton("Resume Game", 0x666666, 0x666666, 0x666666, 30, 0x00ff00, new Rectangle(512 - 125, 384 - 50, 250, 50));
		private var settingsButton:CCButton = new CCButton("Settings", 0xff8888, 0xff0000, 0x666666, 30, 0x00ff00, new Rectangle(512 - 100, 384 + 25, 200, 50));
		private var controlsButton:CCButton = new CCButton("Controls",  0xff8888, 0xff0000, 0x666666, 30, 0x00ff00, new Rectangle(512 - 100, 384 + 100, 200, 50));
		
		private var controlsDialog:CCModalDialog = new CCModalDialog(300, Constants.CONTROLS_HTML, "Bookman Old Style", 26, 0x000000, 0xffffff , 0x444444, .9, 0xdd0000 );
		
		
		public function HomeScreen() {
			addChild(homeImage);
			addChild(newGameButton);
			addChild(settingsButton); 
			addChild(resumeButton);
			addChild(controlsButton);
			
			
			settingsButton.addEventListener(MouseEvent.CLICK, clickSettings);
			newGameButton.addEventListener(MouseEvent.CLICK, clickNewGame);
			controlsButton.addEventListener(MouseEvent.CLICK, clickControls);
			
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
				
			if (controlsButton.hasEventListener(MouseEvent.CLICK))
				controlsButton.removeEventListener(MouseEvent.CLICK, clickControls); 
			
			newGameButton.dispose();	
			resumeButton.dispose();
			settingsButton.dispose();
			controlsButton.dispose();
			controlsDialog.dispose();
			
			removeChild(newGameButton);
			removeChild(resumeButton);
			removeChild(settingsButton); 
			removeChild(controlsButton);
			
			if (contains(controlsDialog))
				removeChild(controlsDialog);
			
			newGameButton = resumeButton = settingsButton = controlsButton = null; 
			controlsDialog = null; 
			
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
		
		private function clickControls(evt:MouseEvent):void {
			addChild(controlsDialog);
			controlsDialog.popup();
		}
	}
}
