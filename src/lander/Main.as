package lander{
	import flash.display.Sprite;
	
	[SWF (width="1024",height="768")]

	/**
	 * @author charles
	 */
	public class Main extends Sprite {
		private var level:Level;
		public function Main() {
			level = new Level();
			addChild(level);
			level.afterAddedToStage(); 
			
		}
	}
}
