package landerEvents {
	import flash.events.Event;

	/**
	 * @author charles
	 */
	public class LanderEvent extends Event {
		
		public static const HIT_GROUND_EVENT:String = "omghittheground";
		
		public function LanderEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
