package lander{
	import flash.display.Sprite;
	import landerEvents.*;
	

	/**
	 * @author charles
	 */
	[SWF (width="1024",height="768",framerate="60")]
	public class Main extends Sprite {
		
		
		private var levelData:LevelData; 
		private var levelState:LevelState; 
		
		private var levelScreen:Level;
		private var homeScreen:HomeScreen = new HomeScreen();
		private var settingsScreen:SettingsScreen; 
		
		public function Main() {
			
			getNextLevelData();
			
			addChild(homeScreen); 
			
			addEventListener(LanderEvent.GO_TO_SETTINGS, goToSettings);
			addEventListener(LanderEvent.START_GAME, startGame);
			addEventListener(LanderEvent.GO_TO_HOME, goToHome);
			addEventListener(LanderEvent.RESUME_GAME, resumeGame);
			
		}
		
		private function goToSettings(evt:LanderEvent):void {
			if (this.contains(homeScreen)) {
				removeChild(homeScreen);
				homeScreen.dispose();
				homeScreen = null; 
			}
			
			settingsScreen = new SettingsScreen();
			addChild(settingsScreen);
		}
		
		private function startGame(evt:LanderEvent):void {
			if (this.contains(homeScreen)) {
				removeChild(homeScreen);
				homeScreen.dispose();
				homeScreen = null; 
			}
				
			if (levelScreen != null){
				levelScreen.dispose();
				levelScreen = null; 
			}
			
			levelState = null; 
			
			initCurrentLevel();
			
			addChild(levelScreen);
			levelScreen.resumeFromMenu();
		}
		
		private function resumeGame(evt:LanderEvent):void {
			if (this.contains(homeScreen)) {
				removeChild(homeScreen);
				homeScreen.dispose();
				homeScreen = null; 
			}
			
			if (levelScreen == null)
				initCurrentLevel();
			
			addChild(levelScreen);
			
			levelScreen.resumeFromMenu();
		}
		
		private function initCurrentLevel():void {
			
			levelScreen = new Level();	
			levelScreen.loadLevel(levelData);
			if (levelState != null)
				levelScreen.loadLevelState(levelState);
			
		}
		
		private function getNextLevelData():void {
			if (AllLevels.outOfLevels())
				AllLevels.getEmbeddedLevels();
				
			levelData = AllLevels.popLevelData();
		}
		
		
		private function goToHome(evt:LanderEvent):void {
			if (settingsScreen != null && this.contains(settingsScreen)) {
				settingsScreen.dispose();
				removeChild(settingsScreen);
				settingsScreen = null; 
			}
			
			if (levelScreen!=null && this.contains(levelScreen)) {
				removeChild(levelScreen);
				levelState = levelScreen.dumpLevelState(); 
				levelScreen.dispose(); 
				levelScreen = null; 
				HomeScreen.resumeButtonActive = true; 
				
			}
			
			homeScreen = new HomeScreen();
			
			addChild(homeScreen);
		}
		
	
	}
}
