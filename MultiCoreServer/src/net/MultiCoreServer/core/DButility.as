package net.MultiCoreServer.core
{
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.filesystem.File;

	public class DButility
	{	
		
		public static var folder:File = File.applicationStorageDirectory; 
		public static var accountDB:File = folder.resolvePath("CheckOffAccounts.db"); 
		public static var listsDB:File = folder.resolvePath("CheckOffLists.db");
		public static var attachmentsDB:File = folder.resolvePath("CheckOffAttachments.db");

				
		public function DButility()
		{

		}
		
		
		public static function checkDB( ):void
		{
			
			if ( !accountDB.exists ) { initDB(); } 
			
		}
		
		
		private static function initDB():void
		{	
			
			var DBconn:SQLConnection = new SQLConnection();
			var createStmt:SQLStatement = new SQLStatement(); 
			createStmt.sqlConnection = DBconn; 

// Table definitions for Accounts DB
			
			var users:String =  
					"CREATE TABLE IF NOT EXISTS CheckOffAccounts.users (" +  
					"    id INTEGER PRIMARY KEY AUTOINCREMENT, " +  
					"    username TEXT UNIQUE INDEX, " +  
					"    email TEXT UNIQUE INDEX, " +  
					"    group_id INTEGER," +  
					"    salt TEXT," +  
					"    passhash TEXT," +  
					"    perm_override_remove INTEGER," +  
					"    perm_override_add INTEGER," +  
					"    reg_date INTEGER," +  
					"    last_login_date INTEGER," +  
					"    reg_ip INTEGER," +  
					"    last_login_ip INTEGER," +
					"    must_validate BOOLEAN)"; 
				
			
			var autologin:String =  
					"CREATE TABLE IF NOT EXISTS CheckOffAccounts.autologin (" +  
					"    id INTEGER PRIMARY KEY AUTOINCREMENT, " +  
					"    user_id INTEGER INDEX," +  
					"    public_key TEXT INDEX," +  
					"    private_key TEXT," +  
					"    created_on INTEGER," +  
					"    last_used_on TEXT," +  
					"    last_login_date INTEGER," +  
					"    last_used_ip INTEGER )"; 
				
			
			var groups:String =  
					"CREATE TABLE IF NOT EXISTS CheckOffAccounts.groups (" +  
					"    id INTEGER PRIMARY KEY AUTOINCREMENT," +  
					"    group_name TEXT," +  
					"    permissions INTEGER)"; 
				
			
			var forced_group_ips:String =  
					"CREATE TABLE IF NOT EXISTS CheckOffAccounts.forced_group_ips (" +  
					"    id INTEGER PRIMARY KEY AUTOINCREMENT, " +  
					"    group_id INTEGER," +  
					"    ip_low INTEGER INDEX," +  
					"    ip_high INTEGER INDEX," +  
					"    created_on INTEGER," +  
					"    notes TEXT )";  
				
			
			var banned_emails:String =  
					"CREATE TABLE IF NOT EXISTS CheckOffAccounts.banned_emails (" +  
					"    id INTEGER PRIMARY KEY AUTOINCREMENT, " +  
					"    email_regex TEXT," +  
					"    created_on INTEGER," +  
					"    notes TEXT )";  
	
			
// Table Definitions for  Lists DB
			
			var lists:String =
				"CREATE TABLE IF NOT EXISTS CheckOffLists.lists (" +  
				"    id INTEGER PRIMARY KEY AUTOINCREMENT," +  
				"    owner_id INTEGER," +  
				"    created_on INTEGER," +
				"	 modified_on INTEGER," +	
				"	 item_group_id INTEGER UNIQUE," +
				"	 share_group_id INTERGER UNIQUE," +
				"    title TEXT )";  	
			
			
			var items:String = 
				"CREAT TABLE IF NOT EXISTS CheckOffLists.lists (" +
				"	 id INTEGER PRIMARY KEY AUTOINCREMENT," +
				"	 item_group_id INTEGER," +
				"	 created_on INTEGER," +
				"	 modified_on INTEGER," +
				"	 attachment_id INTEGER UNIQUE," +
				"	 label TEXT,"
			
				
			var shares:String = 
				"CREATE TABLE IF NOT EXISTS CheckOffLists.shares (" +  
				"    id INTEGER PRIMARY KEY AUTOINCREMENT, " +  
				"    share_group_id INTEGER," +  
				"    user_id INTEGER," +  
				"    permissions INTEGER," +  
				"    created_on INTEGER," +  
				"    notes TEXT )";


// Table Definitions for Attachments DB
			
			var attachments:String =
				"CREATE TABLE IF NOT EXISTS CheckOffAttachments.attachment (" +  
				"    id INTEGER PRIMARY KEY AUTOINCREMENT," +  
				"    owner_id INTEGER," +  
				"    created_on INTEGER," +
				"	 modified_on INTEGER," +	
				"	 item_group_id INTEGER," +
				"	 share_group_id INTERGER," +
				"    name TEXT," +
				"	 filename TEXT," +
				"	 datatype TEXT," +
				"	 data BLOB)";  	
			
			
			var icons:String = 
				"CREATE TABLE IF NOT EXISTS CheckOffAttachments.icons (" +  
				"    id INTEGER PRIMARY KEY AUTOINCREMENT," +
				"    owner_id INTEGER," +
				"    created_on INTEGER," +
				"	 modified_on INTEGER," +
				"    name TEXT," +
				"	 filename TEXT," +
				"	 data BLOB)";

			
			try
			{
				
// Creation of Accounts DB				
				DBconn.open( accountDB , SQLMode.CREATE ); 
				trace("the database was created successfully: accountDB"); 
						 
				createStmt.text = users; 
				createStmt.execute(); 
				trace("Table created: users"); 
					
				createStmt.text = autologin; 
				createStmt.execute(); 
				trace("Table created: autologin"); 
					
				createStmt.text = groups; 
				createStmt.execute(); 
				trace("Table created: groups"); 
					
				createStmt.text = forced_group_ips; 
				createStmt.execute(); 
				trace("Table created: forced_group_ips"); 
					
				createStmt.text = banned_emails; 
				createStmt.execute(); 
				trace("Table created: banned_emails"); 
					
				DBconn.setSavepoint( "Creation" );
				trace("Save point set: Creation");			
				DBconn.close( );		
					
// Creation of Lists DB
				DBconn.open( listsDB , SQLMode.CREATE ); 
				trace("the database was created successfully: listsDB");				

				createStmt.text = lists; 
				createStmt.execute(); 
				trace("Table created: lists"); 
					
				createStmt.text = items; 
				createStmt.execute(); 
				trace("Table created: items"); 
					
				createStmt.text = shares; 
				createStmt.execute(); 
				trace("Table created: shares"); 
					
				DBconn.setSavepoint( "Creation" );
				trace("Save point set: Creation");			
				DBconn.close( );		
					
// Creation of Attachments DB				 
				DBconn.open( attachmentsDB , SQLMode.CREATE ); 
				trace("the database was created successfully: attachmentsDB");				

				createStmt.text = attachments; 
				createStmt.execute(); 
				trace("Table created: attachments"); 
					
				createStmt.text = icons; 
				createStmt.execute(); 
				trace("Table created: icons"); 
					
				DBconn.setSavepoint( "Creation" );
				trace("Save point set: Creation");			
				DBconn.close( );		
					
			} 
			catch (error:SQLError) 
			{ 
				trace("Error message:", error.message); 
				trace("Details:", error.details); 
			} 
					
				
		}
				
		
	}

	
}
