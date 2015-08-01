package net.MultiCoreServer.core
{
	import flash.filesystem.File;

	public class Constants
	{
		private static const AccountDB_FileName:String = "CheckOffAccounts.db";
		private static const ListsDB_FileName:String = "CheckOffLists.db";
		private static const AttachmentsDB_FileName:String = "CheckOffAttachments.db";

		public static const ServerListeningPort:uint = 1466;
		public static const MaximumPendingConnectionRequests:uint = 16;  
		public static const FreeMemoryLimit:Number = 0.1;

		
		public static const SendQueue:String = "SendQueue";
		public static const CommandQueue:String = "CommandQueue";
		public static const SendCondition:String = "SendCondition";
		public static const CommandCondition:String = "CommandCondition";
		public static const ClientSocket:String = "ClientSocket";
		
		public static const folder:File = File.applicationStorageDirectory; 
		public static const accountDB:File = File.applicationStorageDirectory.resolvePath( AccountDB_FileName) ; 
		public static const listsDB:File = folder.resolvePath( ListsDB_FileName );
		public static const attachmentsDB:File = folder.resolvePath( AttachmentsDB_FileName );	
		
		public static const ResultClass:String = "flash.data.SQLResult";
		public static const StatmentClass:String = "flash.data.SQLStatement";
		public static const ClientSocketClass:String = "net.MultiCoreServer.utils.ClientSocket";
		public static const SocketClass:String = "flash.net.Socket";
		
		public function Constants()
		{
			
		}
	}
}