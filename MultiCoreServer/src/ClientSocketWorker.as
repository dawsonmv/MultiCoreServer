package 
{

	import flash.concurrent.Condition;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.net.registerClassAlias;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	import net.MultiCoreServer.core.Constants;
	import net.MultiCoreServer.util.ClientSocket;
	
	public class ClientSocketWorker extends Sprite
	{

		private var _sock:Socket;
		private var _sendQ:ByteArray;
		private var _commQ:ByteArray;
		private var _sCon:Condition;
		private var _cCon:Condition;
		
		private var _requests_in_process:uint;
		
		
		public function ClientSocketWorker( )
		{
			//TODO: implement function
			super();
			
			registerClassAlias( Constants.ClientSocketClass , ClientSocket );
			registerClassAlias( Constants.SocketClass , Socket );
			registerClassAlias( Constants.ResultClass , SQLResult );
			registerClassAlias( Constants.StatmentClass , SQLStatement );
			
			_requests_in_process = new uint();
			
			var sockwrapper:ClientSocket = Worker.current.getSharedProperty( Constants.ClientSocket );
			
			_sendQ = Worker.current.getSharedProperty( Constants.SendQueue );
			_commQ = Worker.current.getSharedProperty( Constants.CommandQueue );
			_sCon =  Worker.current.getSharedProperty( Constants.SendCondition );
			_cCon = Worker.current.getSharedProperty( Constants.CommandCondition );
					
			_sock = sockwrapper.sock;
			
			_sock.addEventListener( ProgressEvent.SOCKET_DATA , socketRequestHandler );
			_sock.addEventListener( Event.CLOSE , socketCloseHandler );
			_sock.addEventListener( IOErrorEvent.IO_ERROR , errorHandler );
						
		}
		
		private function idle( ):void
		{
			var resObj:SQLResult;	
			
			try
			{
				while( _requests_in_process > 0 )
				{	
					if( _sendQ.bytesAvailable < 1 )
					{
						_sCon.wait();
					}
			
					while( _sendQ.bytesAvailable )
					{	
						_sCon.mutex.lock();					
						resObj = _sendQ.readObject() as SQLResult;
						_sCon.mutex.unlock();
						_sCon.notifyAll();
						
						_sock.writeObject( resObj );
						_sock.flush();
						_requests_in_process--;
					}
				}				
			}	
			catch( error:IOError )
			{
				trace("Error message:", error.message); 
				trace("Details:", error.details); 
			}
			
		}
		
		private function socketRequestHandler( event:ProgressEvent ):void
		{
			var CommandStatement:SQLStatement;
			
			try
			{
				while ( _sock.bytesAvailable )
				{	
					CommandStatement = _sock.readObject() as SQLStatement;
					
					_cCon.mutex.lock();
					_commQ.writeObject( CommandStatement );
					_cCon.mutex.unlock();
					_cCon.notifyAll();
					_requests_in_process++;
				}			
			}
			catch( error:IOError )
			{
				trace("Error message:", error.message); 
				trace("Details:", error.details); 
			}
			finally
			{	
				idle();
			}
			
		}
		
		private function socketCloseHandler( event:Event ):void
		{
			
			trace( "connection closed from:" , _sock.remoteAddress , _sock.remotePort );
			_sock.removeEventListener(Event.CLOSE,socketCloseHandler);
			_sock.removeEventListener(ProgressEvent.SOCKET_DATA , socketRequestHandler );
			_sock = null; 
			
			Worker.current.terminate();
		}
				
		private function errorHandler(event:IOErrorEvent):void 
		{ 
			trace("Error message: ", event.errorID ); 
			trace("Details: ", event.text ); 
		} 
		
		
	}
	
}