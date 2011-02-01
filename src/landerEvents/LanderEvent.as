package landerEvents {
	import flash.events.Event;

	/**
	 * @author charles
	 */
	public class LanderEvent extends Event {
		
		public static const HIT_GROUND_EVENT:String = "omghittheground";
		public static const START_GAME:String = "startthegame";
		public static const RESUME_GAME:String = "resumepausedgame";
		public static const GO_TO_SETTINGS:String = "gotosettings";
		public static const GO_TO_HOME:String = "gotohome";
		
		public function LanderEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
