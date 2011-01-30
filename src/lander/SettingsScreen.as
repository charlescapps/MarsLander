package lander {
	import flash.display.Sprite;
	import flash.display.Bitmap; 
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import levelMaker.CCButton; 
	import levelMaker.CCToggleButton; 

	/**
	 * @author charles
	 */
	 [SWF (width="1024",height="768",framerate="60")]
	public class SettingsScreen extends Sprite {
		
		private const imageFactory:ImageFactory = ImageFactory.getInstance();
		private var settingsImage:Bitmap = imageFactory.settingsScreenImg;  
		
		private var backToHomeButton:CCButton = new CCButton("Back", 0xff8888, 0xff0000, 30, 0x00ff00, new Rectangle(100, 50, 200, 50), 0x666666); 
		private var gravityButton:CCToggleButton = new CCToggleButton("Gravity: LOW", "Gravity: HIGH", 0xff8888, 0xff0000, 30, 0x000000, new Rectangle(512 - 100, 300, 200, 50), 0x666666);
		
		public function SettingsScreen() {
			addChild(settingsImage);
			addChild(backToHomeButton);
			addChild(gravityButton);
			
			gravityButton.addEventListener(MouseEvent.CLICK, toggleGravity);
		}
		
		private function toggleGravity(evt:MouseEvent):void {
			Settings.gravityHigh = ! Settings.gravityHigh; 
		}
	}
}
