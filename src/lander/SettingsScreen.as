package lander {
	import landerEvents.LanderEvent;
	import flash.display.Sprite;
	import flash.display.Bitmap; 
	import flash.geom.*;
	import flash.events.MouseEvent;
	import levelMaker.CCButton; 
	import levelMaker.CCToggleButton; 
	import levelMaker.CCScrollBox; 

	/**
	 * @author charles
	 */
	 [SWF (width="1024",height="768",framerate="60")]
	public class SettingsScreen extends Sprite {
		
		private const imageFactory:ImageFactory = ImageFactory.getInstance();
		private var settingsImage:Bitmap = imageFactory.settingsScreenImg;  
		
		private var backToHomeButton:CCButton = new CCButton("Back", 0xff8888, 0xff0000, 30, 0x00ff00, new Rectangle(100, 50, 200, 50), 0x666666); 
		private var gravityButton:CCToggleButton = new CCToggleButton("Gravity: LOW", "Gravity: HIGH", 0xff8888, 0xff0000, 30, 0x000000, new Rectangle(512 - 100, 300, 200, 50), 0x666666);
		private var scrollImgs:Vector.<Bitmap> = new Vector.<Bitmap>(); 
		private var scrollVals:Array = new Array();
		private var difficultyScrollBox:CCScrollBox; 
		
		public function SettingsScreen() {
			scrollImgs.push(imageFactory.easyScrollImg, imageFactory.normalScrollImg, imageFactory.hardScrollImg, imageFactory.impossibleScrollImg);
			scrollVals.push(Constants.DIFFICULTY_EASY, Constants.DIFFICULTY_NORMAL, Constants.DIFFICULTY_HARD, Constants.DIFFICULTY_IMPOSSIBLE);
			
			difficultyScrollBox = new CCScrollBox(new Point(512-100, 400), new Rectangle(0, 0, 200, 50), imageFactory.upScrollImg, imageFactory.downScrollImg, 
										scrollImgs, scrollVals, 4, 0xff2222);
			
			
			
			addChild(settingsImage);
			addChild(backToHomeButton);
			addChild(gravityButton);
			addChild(difficultyScrollBox);
			
			
			if (Settings.gravityHigh)
				gravityButton.isDown = true; 
			else
				gravityButton.isDown = false; 
			
			gravityButton.addEventListener(MouseEvent.CLICK, toggleGravity);
			backToHomeButton.addEventListener(MouseEvent.CLICK, clickHomeButton);
		}
		
		public function dispose():void {
			if (gravityButton.hasEventListener(MouseEvent.CLICK))
				gravityButton.removeEventListener(MouseEvent.CLICK, toggleGravity);
			
			if (backToHomeButton.hasEventListener(MouseEvent.CLICK))
				backToHomeButton.removeEventListener(MouseEvent.CLICK, clickHomeButton);
				
			removeChild(settingsImage);
			removeChild(backToHomeButton);
			removeChild(gravityButton);
			
			settingsImage = null; 
		}
		
		private function toggleGravity(evt:MouseEvent):void {
			Settings.gravityHigh = ! Settings.gravityHigh; 
		}
		
		private function clickHomeButton(evt:MouseEvent):void {
			dispatchEvent(new LanderEvent(LanderEvent.GO_TO_HOME, true));
		}
	}
}
