package lander {
	/**
	 * @author charles
	 */
	 
	 import flash.utils.ByteArray; 
	 
	public class AllLevels {
		
		[Embed(source='../../resources/levels/level1.xml',
        mimeType="application/octet-stream")]
        private static const Level1:Class; 
        
        private static var levelDataVector:Vector.<LevelData> = new Vector.<LevelData>(); 
			
        public function AllLevels() {
        	
     
        }
        
        public static function getEmbeddedLevels():void {
        	levelDataVector.push(fileToLevelData(new Level1()));
        }
        
        private static function fileToXML(file:ByteArray):XML {
        	var str:String = file.readUTFBytes( file.length );
			return new XML( str );
        }
        
        private static function fileToLevelData(file:ByteArray):LevelData {
        	var ld:LevelData = new LevelData();
        	ld.loadXML(fileToXML(file));
        	return ld;
        }
        
        public static function popLevelData():LevelData {
        	return levelDataVector.pop();
        }
	}
}
