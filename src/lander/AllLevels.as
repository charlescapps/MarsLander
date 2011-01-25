package lander {
	/**
	 * @author charles
	 */
	 
	 import flash.utils.ByteArray; 
	 
	public class AllLevels {
		
		[Embed(source='../../resources/levels/level1.xml',
        mimeType="application/octet-stream")]
        private static const Level1:Class; 
        
        public static const level1XML:XML = fileToXML(new Level1());
			
        
        public function AllLevels() {
        	
        }
        
        private static function fileToXML(file:ByteArray):XML {
        	var str:String = file.readUTFBytes( file.length );
			return new XML( str );
        }
	}
}
