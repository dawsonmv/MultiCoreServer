package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.net.registerClassAlias;
	import flash.system.System;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	
	import net.MultiCoreServer.core.Constants;
	import net.MultiCoreServer.core.DButility;
	import net.MultiCoreServer.util.ClientSocket;
	import net.MultiCoreServer.util.Stats;
	
	public class MultiCoreServer extends Sprite
	{
		
		private var listenerConnection:ServerSocket;
		private var openSessions:Vector.<Worker>;
		private var ServerStats:Stats;
		
		public function MultiCoreServer()
		{
			
			registerClassAlias( Constants.ClientSocketClass , ClientSocket );
			registerClassAlias( Constants.SocketClass , Socket );
			
			listenerConnection = new ServerSocket();
			openSessions = new Vector.<Worker>();
			ServerStats = new Stats();
			
			addChild(ServerStats);
			ServerStats.updateDisplay();
			
			DButility.checkDB();
			
			listenerConnection.bind( Constants.ServerListeningPort );
			
			listenerConnection.addEventListener( ServerSocketConnectEvent.CONNECT , serverConnectionHandler );
			listenerConnection.listen( Constants.MaximumPendingConnectionRequests );
			
		}
		
		private function serverConnectionHandler(event:ServerSocketConnectEvent):void
		{
			
			var newConnection:ClientSocket = new ClientSocket(event.socket);
			var newWorker:Worker = WorkerDomain.current.createWorker( CoreWorkers.CheckOffServerWorkerBytes , true );
			
			if ( ( System.freeMemory / System.privateMemory) > Constants.FreeMemoryLimit )
			{
				newWorker.setSharedProperty( Constants.ClientSocket , newConnection );
				openSessions.push( newWorker );	
				newWorker.addEventListener(Event.WORKER_STATE, sessionDispose );
				newWorker.start();
				ServerStats.ConnectionNumber++;
				ServerStats.updateDisplay();
			}
			else
			{
				ServerStats.updateDisplay();
				newConnection.sock.close();
			}
			
		}		
		
		private function sessionDispose( e:Event ):void
		{
			var _w:Worker = Worker(e.target);
			
			if ( _w.state == WorkerState.TERMINATED )
			{
				_w.removeEventListener(Event.WORKER_STATE,sessionDispose);
				openSessions.splice( openSessions.indexOf( _w ) , 1 ); 
			}
			ServerStats.ConnectionNumber--;
			ServerStats.updateDisplay();
			System.gc();
		//	cleanSessions();
		}
		
		private function cleanSessions( ):void
		{
			var i:uint=new uint();
			
			while ( i <  openSessions.length )
			{
				if( openSessions[i].state == WorkerState.TERMINATED )
				{
					openSessions[i].removeEventListener( Event.WORKER_STATE , sessionDispose );
					openSessions.splice(  i , 1 );
				}
				else
				{
					i++;
				}
			}
			
		}
		
	}
	
}