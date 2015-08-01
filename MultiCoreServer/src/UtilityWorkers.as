package 
{
	
	import flash.utils.ByteArray;
	
	public class UtilityWorkers
	{
		
		[Embed(source="../workerswfs/ClientSocketWorker.swf", mimeType="application/octet-stream")]
		private static var ClientSocketWorker_ByteClass:Class;
		
		[Embed(source="../workerswfs/DBconnectionWorker.swf", mimeType="application/octet-stream")]
		private static var DBconnectionWorker_ByteClass:Class;
		
		
		public function UtilityWorkers()
		{
		}
		
		public static function get ClientSocketWorkerBytes():ByteArray
		{
			return new ClientSocketWorker_ByteClass();
		}
		
		public static function get DBconnectionWorkerBytes():ByteArray
		{
			return new DBconnectionWorker_ByteClass();
		}

		
		
	}
}