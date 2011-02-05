package lander{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System; 
	import landerEvents.*;
	
	

	/**
	 * @author charles
	 * 
	 * Entry point for MarsLander game created by Charles L. Capps
	 * Includes features for final project of CS233G Game Programming at PCC
	 * 
	 * All sprites, bitmaps, and event listeners are disposed of when not present on screen. 
	 * State of level is stored in LevelState object. 
	 * Geometry of level is stored in LevelData object. 
	 * 
	 */
	 
	[SWF (width="1024",height="768",framerate="60")]
	public class Main extends Sprite {
		
		
		private var levelData:LevelData;	//Geometry of Level
		private var levelState:LevelState; 	//State of level (i.e. position/velocity of Mars Lander, etc.)
		
		private var levelScreen:Level;	//Sprite class representing display of level
		private var homeScreen:HomeScreen = new HomeScreen();	//Sprite class with image / buttons for Home Screen
		private var settingsScreen:SettingsScreen; 	//Sprite class with image / buttons for Settings Screen
		
		private static var currentFrame:uint = 0; 
		
		public function Main() {
			
			getNextLevelData();	//Gets next LevelData object from embedded XML data, stores in levelData
			
			addChild(homeScreen); 
			
			//Events thrown by children for flow between different views
			addEventListener(LanderEvent.GO_TO_SETTINGS, goToSettings);	
			addEventListener(LanderEvent.START_GAME, startGame);
			addEventListener(LanderEvent.GO_TO_HOME, goToHome);
			addEventListener(LanderEvent.RESUME_GAME, resumeGame);
			
			//Simple function to trace memory usage
			addEventListener(Event.ENTER_FRAME, memoryTrace);
			
		}
		
		//Function called when a GO_TO_SETTINGS event is thrown. 
		//Disposes of Home Screen (can only go to settings from Home Screen), then loads Settings Screen
		private function goToSettings(evt:LanderEvent):void {
			if (this.contains(homeScreen)) {
				homeScreen.dispose();
				removeChild(homeScreen);
				homeScreen = null; 		//May as well force garbage collection before we make a new home screen
										//...not sure how necessary this is, but seemed optimal!
										//That way less things need to happen when the user goes back 
			}
			
			settingsScreen = new SettingsScreen();
			addChild(settingsScreen);
		}
		
		//Function to start a new game--disposes of current Level Screen if a game is in progress
		//Creates a new Level object (sprite) from the current Level Data
		private function startGame(evt:LanderEvent):void {
				
			if (levelScreen != null){  //If a game is in progress, dispose it
				levelScreen.dispose();
				levelScreen = null; 	//Similar, forcing garbage collection so less has to happen "under the covers"
										//when New Game or Resume buttons are pressed
			}
			
			levelState = null; //Starting a new game, set levelState to null so defaults are loaded
			
			resumeGame(evt);
		}
		
		//Resume game, first remove home screen
		private function resumeGame(evt:LanderEvent):void {
			if (this.contains(homeScreen)) {
				homeScreen.dispose();
				removeChild(homeScreen);
				homeScreen = null; 
			}
			
			initCurrentLevel();
			
			addChild(levelScreen);
			
			levelScreen.resumeFromMenu();
		}
		
		//Load the Level Data (geometry) and Level State of the level into a new Level object
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
			
			if (levelScreen!=null && this.contains(levelScreen)) {  //Dispose of levelScreen if we just came from there
			
				levelState = levelScreen.dumpLevelState(); //Get state of level in case player resumes
				levelScreen.dispose(); 
				removeChild(levelScreen);
				levelScreen = null; 
					
				HomeScreen.resumeButtonActive = true; 
				
			}
			
			homeScreen = new HomeScreen();
			
			addChild(homeScreen);
		}
		
		private function memoryTrace(evt:Event):void {
			++currentFrame; 
			if (currentFrame % 100 ==0) {
				trace("Memory allocated at frame " + currentFrame + " : " + System.totalMemory);
				//System.gc(); //Attempt to force garbage collection, doesn't seem to make a difference
			}	
		}
	}
}
