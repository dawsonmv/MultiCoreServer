package net.MultiCoreServer.util
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class DBconnection extends EventDispatcher
	{
		
		private var DBconn:SQLConnection;
		
		// The database file is in the application storage directory 
		private var folder:File;
		private var accountDB:File; 
		private var listsDB:File;	
		private var attachmentsDB:File;

		private var _sendQ:ByteArray;
		private var _commQ:ByteArray;		

		
		
		public function DBconnection()
		{
			//TODO: implement function
			super();			
			
			DBconn = new SQLConnection();
			
			folder = File.applicationStorageDirectory; 
			accountDB = folder.resolvePath("CheckOffAccounts.db"); 
			listsDB = folder.resolvePath("CheckOffLists.db");
			attachmentsDB = folder.resolvePath("CheckOffAttachments.db");	
			
			DBconn.addEventListener( SQLErrorEvent.ERROR , errorHandler );
			DBconn.addEventListener( SQLEvent.OPEN , openHandler );
			
			DBconn.openAsync( accountDB , SQLMode.UPDATE );
			
		}	
		
		private function errorHandler(event:SQLErrorEvent):void 
		{ 
			
			trace("Error message:", event.error.message); 
			trace("Details:", event.error.details); 
			
		} 
		
		
		
		
// DB connection setup		
		
		
		private function openHandler(event:SQLEvent):void 
		{ 
			trace("the database was opened successfully"); 
			DBconn.removeEventListener( SQLEvent.OPEN , openHandler );
			DBconn.addEventListener( SQLEvent.ATTACH , attachListsHandler );
			DBconn.attach( "CheckOffLists" , listsDB );
		} 
		
		
		private function attachListsHandler (event:SQLEvent):void
		{
			trace("sucessfully attached: listsDB");
			DBconn.removeEventListener( SQLEvent.ATTACH , attachListsHandler );
			DBconn.addEventListener( SQLEvent.ATTACH , attachBinsHandler );
			DBconn.attach( "CheckOffAttachments" , attachmentsDB );
		}
		
		
		private function attachBinsHandler ( event:SQLEvent ):void
		{
			trace("sucessfully attached: attachmentsDB");
			DBconn.removeEventListener( SQLEvent.ATTACH , attachBinsHandler );
			trace("DataBase Ready...Waiting for Commands in Queue");
		}

		
		
		
// get functions
		
		private function getAccount( info:Object ):void
		{				
			var sql:SQLStatement = new SQLStatement();
			
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ email+"/'"; 
			
			sql.sqlConnection = this;
			sql.text = comm;
			sql.execute();
			
		}
			
		private function getList( info:Object ):void
		{
			
		}
			
		private function getItems( info:Object ):void
		{
				
		}
			
		private function getShares( info:Object ):void
		{
				
		}
			
		private function getAttachments( info:Object ):void
		{
				
		}
			
		private function getIcons( info:Object ):void
		{
				
		}
		
//add functions
		
		private function addAccount( info:Object ):void
		{				

			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			sql.sqlConnection = this;
			sql.text = comm;
			sql.execute();
			
		}
		
		private function addList( info:Object ):void
		{
			
		}
		
		private function addItems( info:Object ):void
		{
			
		}
		
		private function addShares( info:Object ):void
		{
			
		}
		
		private function addAttachments( info:Object ):void
		{
			
		}
		
		private function addIcons( info:Object ):void
		{
			
		}
		
//update functions
		
		private function updateAccount( info:Object ):void
		{				
			
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
		}
		
		private function updateList( info:Object ):void
		{
			
		}
		
		private function updateItems( info:Object ):void
		{
			
		}
		
		private function updateShares( info:Object ):void
		{
			
		}
		
		private function updateAttachments( info:Object ):void
		{
			
		}
		
		private function updateIcons( info:Object ):void
		{
			
		}
				
		
	}

}