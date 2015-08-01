package 
{
	import flash.concurrent.Condition;
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Sprite;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	import flash.net.registerClassAlias;
	import flash.system.Worker;
	import flash.system.WorkerState;
	import flash.utils.ByteArray;
	import flash.events.Event;
	
	import net.MultiCoreServer.core.Constants;
	
	public class DBconnectionWorker extends Sprite
	{
	
		private var DBconn:SQLConnection;
						
		private var _sendQ:ByteArray;
		private var _commQ:ByteArray;
		private var _sCon:Condition;
		private var _cCon:Condition;
				
		public function DBconnectionWorker()
		{
			//TODO: implement function
			super();			
			
			registerClassAlias( Constants.ResultClass , SQLResult );
			registerClassAlias( Constants.StatmentClass , SQLStatement );

			DBconn = new SQLConnection();
			
			_sendQ = Worker.current.getSharedProperty( Constants.SendQueue );
			_commQ = Worker.current.getSharedProperty( Constants.CommandQueue );
			_sCon = Worker.current.getSharedProperty( Constants.SendCondition );
			_cCon = Worker.current.getSharedProperty( Constants.CommandCondition );
							
			// DB connection setup		
			try{			
					DBconn.open( Constants.accountDB , SQLMode.UPDATE );
					trace("the database was opened successfully"); 
			
					DBconn.attach( "CheckOffLists" , Constants.listsDB );
					trace("sucessfully attached: listsDB");
			
					DBconn.attach( "CheckOffAttachments" , Constants.attachmentsDB );
					trace("sucessfully attached: attachmentsDB");
				}
				catch( err:SQLError )
				{
					trace("Error message:", err.message );
					trace("Details:", err.details );
					DBconn.close();
					Worker.current.terminate();
				}
				finally
				{
					trace("DataBase Ready...Waiting for Commands in Queue");
					idle();
				}
			
		}	
		
		private function WorkerDispose( e:Event ):void
		{
			if ( DBconn.connected )
			{
				DBconn.close();
			}
		}
		
		private function idle():void
		{
			
			var commandStatement:SQLStatement;
			
			while (DBconn.connected)
			{	
				if( _commQ.bytesAvailable < 1 )
				{
					_cCon.wait();
				}
								
				try{							
						_cCon.mutex.lock();
						commandStatement = _commQ.readObject() as SQLStatement;
						_cCon.mutex.unlock();
						_cCon.notify();
						commandStatement.sqlConnection = DBconn;
						commandStatement.execute();				
					}
					catch( err:SQLError )
					{
						trace("Error message:", err.message );
						trace("Details:", err.details );
						DBconn.close();
						Worker.current.terminate();
					}
					finally
					{
						var res:SQLResult = commandStatement.getResult();
						_sendQ.writeObject( res );
						commandStatement.sqlConnection = null;
						commandStatement.clearParameters();
					}
				
			}
			
		}
		
/* 		
		//old async error handler
		private function errorHandler(event:SQLErrorEvent):void 
		{ 
			trace("Error message:", event.error.message);
			trace("Details:", event.error.details);
		} 
		
			
		// get functions abandoned in favor of serialized SQLobjects. 		
		private function getAccount( info:Object ):void
		{				
						
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();
			
		}
		
		private function getList( info:Object ):void
		{
			
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();
			
		}
		
		private function getItems( info:Object ):void
		{
			
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		private function getShares( info:Object ):void
		{
			
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		private function getAttachments( info:Object ):void
		{
			
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		private function getIcons( info:Object ):void
		{
			
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		//add functions
		
		private function addAccount( info:Object ):void
		{				
			
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();
			
		}
		
		private function addList( info:Object ):void
		{
			
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		private function addItems( info:Object ):void
		{
			
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		private function addShares( info:Object ):void
		{
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		private function addAttachments( info:Object ):void
		{
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		private function addIcons( info:Object ):void
		{
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		//update functions
		
		private function updateAccount( info:Object ):void
		{				
			
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();
			
		}
		
		private function updateList( info:Object ):void
		{
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		private function updateItems( info:Object ):void
		{
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		private function updateShares( info:Object ):void
		{
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		private function updateAttachments( info:Object ):void
		{
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
		
		private function updateIcons( info:Object ):void
		{
			var comm:String = 
				"SELECT DISTINCT FROM CheckOffAccounts.accounts WHERE user_email = /'"+ info.email +"/'"; 
			
			_sql.text = comm;
			_sql.execute();

		}
*/
		
	}
	
	
}