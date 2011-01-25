package lander{
	import flash.display.Sprite;
	
	

	/**
	 * @author charles
	 */
	[SWF (width="1024",height="768",framerate="60")]
	public class Main extends Sprite {
		private var level:Level;
		public function Main() {
			XML.prettyPrinting = true; 
			level = new Level();
			addChild(level);
			level.afterAddedToStage(); 
			
			var level1:XML = AllLevels.level1XML; 
			
			var ld:LevelData = new LevelData();
			ld.loadXML(level1);
			level.loadLevel(ld);
			//trace(level1.toXMLString());
			
			
		}
	}
}
