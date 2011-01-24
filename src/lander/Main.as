package lander{
	import flash.display.Sprite;
	
	

	/**
	 * @author charles
	 */
	[SWF (width="1024",height="768")]
	public class Main extends Sprite {
		private var level:Level;
		public function Main() {
			XML.prettyPrinting = true; 
			level = new Level();
			addChild(level);
			level.afterAddedToStage(); 
			
			var ld:LevelData = new LevelData(); 
			var xml:XML = ld.toXML(); 
			
			
		}
	}
}
