package lander {
	/**
	 * @author charles
	 */
	  
	 
	public class Constants {
		public static const STAGE_WIDTH:int = 1024; 
		public static const STAGE_HEIGHT:int = 768; 
		public static const LANDER_WIDTH:int = 54; 
		public static const LANDER_HEIGHT:int = 49; 
		
		public static const LOW_GRAVITY:Number = .4; 
		public static const HIGH_GRAVITY:Number = .8; 
		
		public static const LOW_THRUST:Number = .7; 
		public static const HIGH_THRUST:Number = 1.0; 
		
		public static const LOW_SIDE_THRUST:Number = .3; 
		public static const HIGH_SIDE_THRUST:Number = .6; 
		
		public static const ROTATIONAL_THRUST:Number = 1.0; 
		
		public static const DIFFICULTY_EASY:String = "EASY";
		public static const DIFFICULTY_NORMAL:String = "NORMAL";
		public static const DIFFICULTY_HARD:String = "HARD";
		public static const DIFFICULTY_IMPOSSIBLE:String = "IMPOSSIBLE";
		
		public static const CONTROLS_HTML:String = 
													"<b>Controls:</b></font> \n\n" +
													"<b>UP:</b>&nbsp; <i>Thrust</i> \n" +
													"<b>LEFT:</b>&nbsp; <i>Thrust Left</i> \n" +
													"<b>RIGHT:</b>&nbsp; <i>Thrust Right</i> \n" +
													"<b>A:</b>&nbsp; <i>Rotate Left</i> \n" +
													"<b>D:</b>&nbsp; <i>Rotate Right</i> \n" +
													"&nbsp;"; 
		
	}
}
