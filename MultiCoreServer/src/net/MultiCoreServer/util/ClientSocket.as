package net.MultiCoreServer.util
{

	import flash.net.Socket;
	
	public class ClientSocket
	{
		public var sock:Socket;
		
		public function ClientSocket( _s:Socket  )
		{
				
			sock = _s;
			
		}
	}	
}
/*  old stuff dont use anymore
		
		private function socketRequestHandler( event:ProgressEvent ):void
		{
			var _sock:Socket = Socket(event.target);
			
			while ( _sock.bytesAvailable )
			{	
			
				try
				{
					var data:Object = _sock.readObject();
					doRequest( data );
				}
				catch( error:IOError )
				{
					trace("Error message:", error.message); 
					trace("Details:", error.details); 
				}
		
			}
			
		}
		
		
		private function resultHandler( evt:SQLEvent ):void
		{
			
			var result:SQLResult =  _stmt.getResult();
			var stmt:SQLStatement = SQLStatmentevt.target)
			
			for( var i:int=0; i < result.data.length; i++){
			_sock.writeObject( result.data[i] );}
			
			_sock.flush();
			
		}
		

		
		private function doRequest( vars:Object ):void
		{
			
			var command:String = vars.command;
								
			switch( command )
			{
				
				case "getAccount":
					_dbConn.getAccount( vars );				
				break;
				
				case "getList":
					_dbConn.getList( vars );
				break;
				
				case "getItems":
					_dbConn.getItems( vars );
				break;
				
				case "getAttachments":
					_dbConn.getAttachments( vars );					
				break;
				
				case "getIcons":
					_dbConn.getIcons( vars );					
				break;
				
				case "addAccount":
					_dbConn.addAccount( vars );				
				break;
				
				case "addList":
					_dbConn.addList( vars );
				break;
				
				case "addItem":
					_dbConn.addItem( vars );
				break;
				
				case "addAttachment":
					_dbConn.addAttachment( vars );					
				break;
				
				case "addIcon":
					_dbConn.addIcon( vars );					
				break;
				
				case "deleteAccount":
					_dbConn.deleteAccount( vars );				
				break;
				
				case "deleteList":
					_dbConn.deleteList( vars );
				break;
				
				case "deleteItem":
					_dbConn.deleteItem( vars );
				break;
				
				case "deleteAttachment":
					_dbConn.deleteAttachment( vars );					
				break;
				
				case "deleteIcon":
					_dbConn.deleteIcon( vars );					
				break;
				
				case "updateAccount":
					_dbConn.updateAccount( vars );				
				break;
				
				case "updateList":
					_dbConn.updateList( vars );
				break;
				
				case "updateItem":
					_dbConn.updateItem( vars );
				break;
				
				case "updateShare":
					_dbConn.updateShare( vars );
				break;
				
				case "updateAttachment":
					_dbConn.updateAttachment( vars );					
				break;
				
				case "updateIcon":
					_dbConn.updateIcon( vars );					
				break;
				
				default:
					trace( "unrecognised command:" , command );
				break;
				
			}
			
		}	

		private function socketCloseHandler( event:Event ):void
		{
				
			trace( "connection closed from:" , _sock.remoteAddress , _sock.remotePort );
			_sock.removeEventListener(Event.CLOSE,socketCloseHandler);
			_sock.removeEventListener(ProgressEvent.SOCKET_DATA , socketRequestHandler );
			_sock = null; 

		}
			
		private function errorHandler(event:SQLErrorEvent):void 
		{ 
			trace("Error message:", event.error.message); 
			trace("Details:", event.error.details); 
		} 
*/		
