import java.sql.Timestamp;
import java.util.ArrayList;

import org.joda.money.BigMoney;

import com.bitmidas.exchanger.Exchanger;
import com.bitmidas.exchanger.ExchangerHelper;
import com.xeiam.xchange.dto.marketdata.Ticker;

public class Arbitrage {

	private ArrayList<Exchanger> listExchanger;

	public Arbitrage() {

		this.listExchanger = ExchangerHelper.getListExchanger();

	}

	public void watch() {

		for (Exchanger seller : listExchanger) {

			if (!seller.isTradingSupported()) {
				continue;
			}

			Ticker tickerSeller = seller.getLastTicker();
			if (tickerSeller == null) {
				System.err.println("error getting ticker " + seller.getExchangerName());
				continue;
			}

			for (Exchanger buyer : listExchanger) {

				if (!buyer.isTradingSupported()) {
					continue;
				}

				Ticker tickerBuyer = buyer.getLastTicker();

				if (tickerBuyer == null) {
					System.err.println("error getting ticker " + buyer.getExchangerName());
					continue;
				}

				BigMoney ask = tickerSeller.getAsk();
				BigMoney bid = tickerBuyer.getBid();

				if (ask == null || bid == null) {

					System.err.println("ask or bid null.");
					System.err.println("ask " + seller.getExchangerName() + " " + tickerSeller);
					System.err.println("bid " + buyer.getExchangerName() + " " + tickerBuyer);
					continue;

				}

				if (tickerSeller.getAsk().isLessThan(tickerBuyer.getBid())) {

					double profit = tickerBuyer.getBid().getAmount().doubleValue() - tickerSeller.getAsk().getAmount().doubleValue();
					double percentProfit = (profit / tickerBuyer.getBid().getAmount().doubleValue()) * 100;

					if (percentProfit > 5) {
						System.out.println(new Timestamp(System.currentTimeMillis()) + " buy " + tickerSeller.getAsk() + " [" + seller.getExchangerName() + "] -> sell " + tickerBuyer.getBid() + " ["
								+ buyer.getExchangerName() + "] = " + percentProfit + "%");
					}

				}

			}

		}

	}

}
