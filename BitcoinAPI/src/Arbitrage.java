import java.sql.Timestamp;
import java.util.ArrayList;

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

			for (Exchanger buyer : listExchanger) {

				if (!buyer.isTradingSupported()) {
					continue;
				}

				Ticker tickerBuyer = buyer.getLastTicker();

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
