package lander{
	import flash.display.Sprite;
	
	

	/**
	 * @author charles
	 */
	[SWF (width="1024",height="768",framerate="60")]
	public class Main extends Sprite {
		
		private var level:Level;
		private var homeScreen:HomeScreen = new HomeScreen();
		
		
		public function Main() {
			
			initFirstLevel();
			
			
			
		}
		
		private function initFirstLevel():void {
			AllLevels.getEmbeddedLevels();
			
			level = new Level();
			addChild(level);
			level.afterAddedToStage(); 
			
			level.loadLevel(AllLevels.popLevelData());
		}
		
	
	}
}
