package lander {
	import landerEvents.LanderEvent;
	import flash.display.Sprite;
	import flash.display.Bitmap; 
	import flash.geom.*;
	import flash.events.MouseEvent;
	import ccui.CCButton; 
	import ccui.CCToggleButton; 
	import ccui.CCScrollBox; 

	/**
	 * @author charles
	 */
	 [SWF (width="1024",height="768",framerate="60")]
	public class SettingsScreen extends Sprite {
		
		private const imageFactory:ImageFactory = ImageFactory.getInstance();
		private var settingsImage:Bitmap = imageFactory.settingsScreenImg;  
		
		private var backToHomeButton:CCButton = new CCButton("Back", 0xff8888, 0xff0000, 0x666666, 30, 0x00ff00, new Rectangle(100, 50, 200, 50)); 
		private var gravityButton:CCToggleButton = new CCToggleButton("Gravity: LOW", "Gravity: HIGH", 0xff8888, 0xff0000, 0x666666, 30, 0x000000, new Rectangle(512 - 100, 300, 200, 50));
		private var scrollImgs:Vector.<Bitmap> = new Vector.<Bitmap>(); 
		private var scrollVals:Array = new Array();
		private var difficultyScrollBox:CCScrollBox; 
		
		public function SettingsScreen() {
			scrollImgs.push(imageFactory.easyScrollImg, imageFactory.normalScrollImg, imageFactory.hardScrollImg, imageFactory.impossibleScrollImg);
			scrollVals.push(Constants.DIFFICULTY_EASY, Constants.DIFFICULTY_NORMAL, Constants.DIFFICULTY_HARD, Constants.DIFFICULTY_IMPOSSIBLE);
			
			difficultyScrollBox = new CCScrollBox(new Point(512-100, 400), new Rectangle(0, 0, 200, 50), imageFactory.upScrollImg, imageFactory.downScrollImg, 
										scrollImgs, scrollVals, 4, 0xff2222);
			
			difficultyScrollBox.selectIndex(scrollVals.indexOf(Settings.difficulty)); //Select index for current Difficulty setting
			difficultyScrollBox.scrollToIndex(scrollVals.indexOf(Settings.difficulty)); //Scroll to this index
			
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
			difficultyScrollBox.addEventListener(MouseEvent.CLICK, grabDifficultySetting);
		}
		
		public function dispose():void {
			if (gravityButton.hasEventListener(MouseEvent.CLICK))
				gravityButton.removeEventListener(MouseEvent.CLICK, toggleGravity);
			
			if (backToHomeButton.hasEventListener(MouseEvent.CLICK))
				backToHomeButton.removeEventListener(MouseEvent.CLICK, clickHomeButton);
				
			if (difficultyScrollBox.hasEventListener(MouseEvent.CLICK))
				difficultyScrollBox.removeEventListener(MouseEvent.CLICK, grabDifficultySetting);
				
			backToHomeButton.dispose();
			gravityButton.dispose();
			difficultyScrollBox.dispose();
				
			removeChild(settingsImage);
			removeChild(backToHomeButton);
			removeChild(gravityButton);
			removeChild(difficultyScrollBox);
			
			settingsImage = null; 
			
			
		}
		
		private function grabDifficultySetting(evt:MouseEvent):void {
			Settings.difficulty = difficultyScrollBox.currentValue as String; 
			trace("Difficulty setting: " + Settings.difficulty );
		}
		
		private function toggleGravity(evt:MouseEvent):void {
			Settings.gravityHigh = ! Settings.gravityHigh; 
		}
		
		private function clickHomeButton(evt:MouseEvent):void {
			dispatchEvent(new LanderEvent(LanderEvent.GO_TO_HOME, true));
		}
	}
}
