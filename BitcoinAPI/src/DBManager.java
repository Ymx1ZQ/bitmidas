import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.LinkedList;

import com.mysql.jdbc.Connection;

public class DBManager {

	private final Integer maxConnect;
	private final String usernamesql;
	private final String passwsql;
	private final String urlserversql;
	private final String dbnamesql;
	private final String portserversql;
	private final String driver;

	private final LinkedList<Connection> connectionsPool;

	private static DBManager instance;

	private DBManager() throws ClassNotFoundException {
		this.usernamesql = "root";
		this.passwsql = "12sadimtib21";
//		this.urlserversql = "192.241.246.240";
		this.urlserversql = "127.0.0.1";
		this.dbnamesql = "BitMidas";
		this.portserversql = "3306";
		this.driver = "com.mysql.jdbc.Driver"; //
		this.maxConnect = 10;

		this.connectionsPool = new LinkedList<Connection>();

		Class.forName(driver);

	}

	public static DBManager getInstance() {

		if (instance == null) {

			try {
				instance = new DBManager();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}

		}

		return instance;
	}

	private Connection createNewConnection() throws SQLException {

		Connection newconn = (Connection) DriverManager.getConnection("jdbc:mysql://" + urlserversql + ":" + portserversql + "/" + dbnamesql, usernamesql, passwsql);
		newconn.setConnectTimeout(10000);

		return newconn;
	}

	public boolean testConnection() {
		try {
			releaseConnection(getConnection());
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}

	public Connection getConnection() throws SQLException {
		synchronized (connectionsPool) {
			if (connectionsPool.size() > 0) {

				Connection conn = connectionsPool.pop();

				if (!conn.isClosed())
					return conn;
			}
		}

		return createNewConnection();

	}

	public boolean releaseConnection(Connection oldConnection) {

		if (oldConnection == null)
			return false;

		try {

			synchronized (connectionsPool) {
				if (!oldConnection.isClosed() && connectionsPool.size() <= maxConnect) {
					connectionsPool.push(oldConnection);
					return true;
				}
			}

			oldConnection = null;
			return false;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public synchronized void closeAllConnection() {
		for (Connection c : connectionsPool) {
			try {
				c.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

}
