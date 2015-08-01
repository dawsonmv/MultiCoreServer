package
{
	
	import flash.concurrent.Condition;
	import flash.concurrent.Mutex;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	import flash.utils.ByteArray;
	import flash.net.registerClassAlias;
	import flash.net.Socket;
	import net.MultiCoreServer.util.ClientSocket;
	import net.MultiCoreServer.core.Constants;
	
	
	public class MultiCoreServerWorker extends Sprite
	{
	
		private var ClientSessionSocket:Worker;
		private var DataBaseConnection:Worker;
		private var CommandQueue:ByteArray;
		private var SendQueue:ByteArray;
		private var CommandCondition:Condition;
		private var SendCondition:Condition;
		
		public function MultiCoreServerWorker(  )
		{
			
			super();
						
			registerClassAlias( Constants.ClientSocketClass , ClientSocket );
			registerClassAlias( Constants.SocketClass , Socket );
			
			DataBaseConnection = WorkerDomain.current.createWorker( UtilityWorkers.DBconnectionWorkerBytes , true );
			ClientSessionSocket = WorkerDomain.current.createWorker( UtilityWorkers.ClientSocketWorkerBytes , true );
			
			CommandQueue = new ByteArray();
			SendQueue = new ByteArray();
			
			CommandQueue.shareable = true;
			SendQueue.shareable = true;	
			
			CommandCondition = new Condition( new Mutex( ) );
			SendCondition = new Condition( new Mutex( ) );		
			
			ClientSessionSocket.setSharedProperty( Constants.ClientSocket , Worker.current.getSharedProperty( Constants.ClientSocket ) );
			ClientSessionSocket.setSharedProperty( Constants.SendQueue , SendQueue );
			ClientSessionSocket.setSharedProperty( Constants.CommandQueue , CommandQueue );
			ClientSessionSocket.setSharedProperty( Constants.CommandCondition , CommandCondition );
			ClientSessionSocket.setSharedProperty( Constants.SendCondition , SendCondition );		
			
			DataBaseConnection.setSharedProperty( Constants.SendQueue , SendQueue );
			DataBaseConnection.setSharedProperty( Constants.CommandQueue , CommandQueue );
			DataBaseConnection.setSharedProperty( Constants.CommandCondition , CommandCondition );
			DataBaseConnection.setSharedProperty( Constants.SendCondition , SendCondition );	
						
			ClientSessionSocket.addEventListener(Event.WORKER_STATE , sessionEnd );			
			DataBaseConnection.addEventListener( Event.WORKER_STATE , dbError );		
			
			ClientSessionSocket.start();
			DataBaseConnection.start();
		}
		
		
		private function sessionEnd( e:Event ):void
		{				
			if( ClientSessionSocket.state == WorkerState.TERMINATED )
			{	
				ClientSessionSocket.removeEventListener(Event.WORKER_STATE , sessionEnd );
				DataBaseConnection.removeEventListener( Event.WORKER_STATE , dbError );
			
				trace( "Client Session Terminated" );
				DataBaseConnection.terminate();
				Worker.current.terminate();			
			}			
		}
		
		
		private function dbError( e:Event ) :void
		{			
			if( ClientSessionSocket.state == WorkerState.TERMINATED )
			{
				ClientSessionSocket.removeEventListener(Event.WORKER_STATE , sessionEnd );
				DataBaseConnection.removeEventListener( Event.WORKER_STATE , dbError );

				trace( "DataBase Connection Terminated" );
				ClientSessionSocket.terminate();
				Worker.current.terminate();			
			}			
		}		
		

	}
	
	
}