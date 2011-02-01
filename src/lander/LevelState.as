package lander {
	import vector.vector2d;
	/**
	 * @author charles
	 */
	public class LevelState {
		
		private var p_landerPosition:vector2d; 
		private var p_landerVelocity:vector2d; 
		private var p_landerRotation:Number; 
		private var p_gameOver:Boolean;
		private var p_messageStr:String; 
		private var p_speedBoxStr:String; 
		
		public function LevelState(landerPosition:vector2d, landerVelocity:vector2d, landerRotation:Number, gameOver:Boolean, msg:String, 
									speedBoxStr:String){
			p_landerPosition = new vector2d(landerPosition.x, landerPosition.y); 
			p_landerVelocity = new vector2d(landerVelocity.x, landerVelocity.y); 
			p_landerRotation = landerRotation; 
			p_gameOver = gameOver; 
			p_messageStr = msg; 
			p_speedBoxStr = speedBoxStr; 
		}
		
		public function get landerPosition():vector2d {
			return p_landerPosition; 
		}
		
		public function get landerVelocity():vector2d {
			return p_landerVelocity; 
		}
		
		public function get landerRotation():Number {
			return p_landerRotation; 
		}
		
		public function get gameOver():Boolean {
			return p_gameOver; 
		}
		
		public function get messageStr():String {
			return p_messageStr;
		}
		
		public function get speedBoxStr():String {
			return p_speedBoxStr;
		}
	}
}
