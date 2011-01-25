package lander {
	import vector.*; 
	
	/**
	 * @author charles
	 */
	public class LevelData {
		
		private var p_groundPoints:Vector.<vector2d>; 
		private var p_groundColor:uint;
		private var p_groundLineColor:uint; 
		private var p_groundLineThickness:int; 
		
		private var p_landPt1:vector2d; 
		private var p_landPt2:vector2d; 
		private var p_landingColor:uint; 
		private var p_landingThickness:int; 
		
		public function LevelData() {
			 p_groundPoints = new Vector.<vector2d>(); 
			 
			 p_groundColor = 0xff0000;
			 p_groundLineColor = 0x000000; 
			 p_groundLineThickness = 2; 
			  
			 p_landPt1 = new vector2d(100, 100); 
			 p_landPt2 = new vector2d(200, 200); 
			 
			 p_landingColor = 0x00ff00; 
			 p_landingThickness = 2; 
		}
		
		public function get groundPoints():Vector.<vector2d> {
			return p_groundPoints; 
		}
		
		public function get landPt1():vector2d {
			return p_landPt1; 
		}
		
		public function get landPt2():vector2d {
			return p_landPt2; 
		}
		
		public function get landingColor():uint {
			return p_landingColor; 
		}
		
		public function get landingThickness():int {
			return p_landingThickness; 
		}
		
		public function get groundColor():uint {
			return p_groundColor; 
		}
		
		public function set groundColor(col:uint):void {
			p_groundColor = col; 
		}
		
		public function get groundLineColor():uint {
			return p_groundLineColor; 
		}
		
		public function get groundLineThickness():int {
			return p_groundLineThickness; 
		}
		
		public function toXML():XML {
			var xml:XML = new XML(<levelData />); 
			
			xml.appendChild(<groundPoints />);
			var groundPointsXML:XML = xml.groundPoints[0];
			
			for (var i:int = 0; i < p_groundPoints.length; i++) {
				groundPointsXML.appendChild(p_groundPoints[i].toXML());
			}
			
			groundPointsXML.@groundColor = p_groundColor.toString(16); 
			groundPointsXML.@lineThickness = p_groundLineThickness; 
			
			xml.appendChild(<landPoints />); 
			var landPointsXML:XML = xml.landPoints[0];
			 
			landPointsXML.appendChild(p_landPt1.toXML()); 
			landPointsXML.appendChild(p_landPt2.toXML()); 
			
			landPointsXML.@landingColor = p_landingColor.toString(16); 
			landPointsXML.@lineThickness = p_landingThickness; 
			
			trace(xml.toXMLString()); 
			return xml; 
		}
		
		public function loadXML(xml:XML):void {
			var groundPointsList:XMLList = xml.groundPoints[0].children();
			var tmpXML:XML; 
			
			for each (tmpXML in groundPointsList) {
				//trace("To add:\n" + tmpXML.toXMLString());
				p_groundPoints.push(new vector2d(tmpXML.@x, tmpXML.@y)); 
				//trace("Added x: " + p_groundPoints[p_groundPoints.length - 1].x); 
				//trace("Added y: " + p_groundPoints[p_groundPoints.length - 1].y); 
			}
			
			p_groundColor =  parseInt(xml.groundPoints[0].@groundColor, 16); 
			
			p_groundLineColor = parseInt(xml.groundPoints[0].@lineColor, 16);
			
			var landPointsList:XMLList = xml.landPoints[0].children();
			p_landPt1 = new vector2d(landPointsList[0].@x, landPointsList[0].@y);
			p_landPt2 = new vector2d(landPointsList[1].@x, landPointsList[1].@y);
			
			p_landingThickness = parseInt(xml.landPoints[0].@lineThickness);
			p_landingColor = parseInt(xml.landPoints[0].@landingColor, 16);
		}
	}
}
