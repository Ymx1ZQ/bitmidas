import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

import com.bitmidas.exchanger.Exchanger;
import com.bitmidas.exchanger.XBitCurex;
import com.bitmidas.exchanger.XBitStamp;
import com.bitmidas.exchanger.XBtcE;
import com.bitmidas.exchanger.XCampBx;
import com.bitmidas.exchanger.XMtGox;
import com.mysql.jdbc.Connection;
import com.xeiam.xchange.dto.marketdata.Ticker;

public class FetcherAPI {

	private XBitCurex bitCurex;
	private XBitStamp bitStamp;
	private XBtcE btcE;
	private XCampBx xCampBx;
	private XMtGox xMtGox;

	private ArrayList<Exchanger> listExchanger;

	public FetcherAPI() {

		bitCurex = new XBitCurex();
		bitStamp = new XBitStamp();
		btcE = new XBtcE();
		xCampBx = new XCampBx();
		xMtGox = new XMtGox();

		listExchanger = new ArrayList<Exchanger>();
		listExchanger.add(bitCurex);
		listExchanger.add(bitStamp);
		listExchanger.add(btcE);
		listExchanger.add(xCampBx);
		listExchanger.add(xMtGox);

	}

	public void storeTickersInDB() {

		for (Exchanger exch : listExchanger) {
			Ticker ticker = exch.getLastTicker();
			saveTicker(ticker, exch.getExchangerName());
		}

	}

	private void saveTicker(Ticker ticker, String exchangerName) {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = DBManager.getInstance().getConnection();

			ps = con.prepareStatement("INSERT INTO " + exchangerName + " (last,bid,ask,high,low,volume,time) VALUES (?,?,?,?,?,?,?)");
			ps.setDouble(1, ticker.getLast().getAmount().doubleValue());
			ps.setDouble(2, ticker.getBid().getAmount().doubleValue());
			ps.setDouble(3, ticker.getAsk().getAmount().doubleValue());
			ps.setDouble(4, ticker.getHigh().getAmount().doubleValue());
			ps.setDouble(5, ticker.getLow().getAmount().doubleValue());
			ps.setDouble(6, ticker.getVolume().intValue());
			ps.setTimestamp(7, new Timestamp(ticker.getTimestamp().getTime()));

			ps.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBManager.closeQuery(con, ps, rs);
		}

	}

}
