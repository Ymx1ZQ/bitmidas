import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;

import org.joda.money.BigMoney;

import com.bitmidas.exchanger.Exchanger;
import com.bitmidas.exchanger.XBitCoinAverage;
import com.bitmidas.exchanger.XBitStamp;
import com.bitmidas.exchanger.XBtcE;
import com.bitmidas.exchanger.XCampBx;
import com.bitmidas.exchanger.XKraken;
import com.bitmidas.exchanger.XMtGox;
import com.mysql.jdbc.Connection;
import com.xeiam.xchange.dto.marketdata.Ticker;

public class FetcherAPI {

	// private XBitCurex bitCurex;
	private XBitStamp bitStamp;
	private XBtcE btcE;
	private XCampBx campBx;
	private XMtGox mtGox;
	// private XVirtex virtex;
	private XKraken kraken;
	// private XBTCChina btcChina;
	private XBitCoinAverage bitCoinAverage;

	private ArrayList<Exchanger> listExchanger;

	public FetcherAPI() {

		bitCoinAverage = new XBitCoinAverage();
		// bitCurex = new XBitCurex();
		bitStamp = new XBitStamp();
		// btcChina = new XBTCChina();
		btcE = new XBtcE();
		campBx = new XCampBx();
		kraken = new XKraken();
		mtGox = new XMtGox();
		// virtex = new XVirtex();

		listExchanger = new ArrayList<Exchanger>();
		listExchanger.add(bitCoinAverage);
		// listExchanger.add(bitCurex); // TODO NO BTC USD
		listExchanger.add(bitStamp);
		// listExchanger.add(btcChina); // TODO NO BTC USD
		listExchanger.add(btcE);
		listExchanger.add(campBx);
		listExchanger.add(kraken);
		listExchanger.add(mtGox);
		// listExchanger.add(virtex); // TODO NO BTC USD

	}

	public void storeTickersInDB() {

		for (Exchanger exch : listExchanger) {
			try {
				Ticker ticker = exch.getLastTicker();
				if (ticker == null) {
					System.err.println("error getting ticker " + exch.getExchangerName());
					continue;
				}
				saveTicker(ticker, exch.getExchangerName());
			} catch (Exception e) {
				e.printStackTrace();
			}
			System.out.println("Tickers saved in db");
		}

	}

	private void saveTicker(Ticker ticker, String exchangerName) {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = DBManager.getInstance().getConnection();

			ps = con.prepareStatement("INSERT INTO `" + exchangerName + "` (last,bid,ask,high,low,volume,time) VALUES (?,?,?,?,?,?,?)");
			ps.setDouble(1, checkBigMoneyDouble(ticker.getLast()));
			ps.setDouble(2, checkBigMoneyDouble(ticker.getBid()));
			ps.setDouble(3, checkBigMoneyDouble(ticker.getAsk()));
			ps.setDouble(4, checkBigMoneyDouble(ticker.getHigh()));
			ps.setDouble(5, checkBigMoneyDouble(ticker.getLow()));
			ps.setDouble(6, (ticker.getVolume() == null) ? 0 : ticker.getVolume().intValue());

			Date time = ticker.getTimestamp();
			if (time == null) { // if null is settet to current Time
				time = new Date(System.currentTimeMillis());
			}
			ps.setTimestamp(7, new Timestamp(time.getTime()));

			ps.executeUpdate();

		} catch (SQLException e) {
			System.err.println("error ticker " + exchangerName);
			e.printStackTrace();
		} finally {
			DBManager.closeQuery(con, ps, rs);
		}

	}

	private double checkBigMoneyDouble(BigMoney bigmoney) {
		if (bigmoney == null) {
			return 0;
		} else {
			return bigmoney.getAmount().doubleValue();
		}
	}

}
