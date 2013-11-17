import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;

import org.joda.money.BigMoney;

import com.bitmidas.exchanger.Exchanger;
import com.bitmidas.exchanger.ExchangerHelper;
import com.mysql.jdbc.Connection;
import com.xeiam.xchange.dto.marketdata.Ticker;

public class FetcherAPI {

	private ArrayList<Exchanger> listExchanger;

	public FetcherAPI() {

		this.listExchanger = ExchangerHelper.getListExchanger();

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
