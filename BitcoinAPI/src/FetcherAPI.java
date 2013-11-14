import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import com.mysql.jdbc.Connection;
import com.xeiam.xchange.Exchange;
import com.xeiam.xchange.ExchangeFactory;
import com.xeiam.xchange.currency.Currencies;
import com.xeiam.xchange.dto.marketdata.Ticker;
import com.xeiam.xchange.mtgox.v1.MtGoxExchange;
import com.xeiam.xchange.service.polling.PollingMarketDataService;

public class FetcherAPI {

	private Exchange mtGoxExchange;

	public FetcherAPI() {

		mtGoxExchange = ExchangeFactory.INSTANCE.createExchange(MtGoxExchange.class.getName());
	}

	public Ticker getLastTicker() {

		try {
			PollingMarketDataService marketDataService = mtGoxExchange.getPollingMarketDataService();

			Ticker ticker = marketDataService.getTicker(Currencies.BTC, Currencies.USD);
			return ticker;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;

	}

	public void saveTicker(Ticker ticker) {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = DBManager.getInstance().getConnection();

			ps = con.prepareStatement("INSERT INTO mtgox (last,bid,ask,high,low,volume,time) VALUES (?,?,?,?,?,?,?)");
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
			close(con, ps, rs);
		}

	}

	private void close(Connection con, Statement stat, ResultSet resultSet) {

		if (resultSet != null) {
			try {
				resultSet.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		if (stat != null) {
			try {
				stat.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		if (con != null) {
			DBManager.getInstance().releaseConnection(con);
		}

	}

}
