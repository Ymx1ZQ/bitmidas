package com.bitmidas.exchanger;

import com.xeiam.xchange.ExchangeFactory;
import com.xeiam.xchange.currency.Currencies;
import com.xeiam.xchange.dto.marketdata.Ticker;
import com.xeiam.xchange.service.polling.PollingMarketDataService;

public abstract class Exchanger {

	private static final long EXPIRETIME_TICKER = 10 * 1000; // mills

	private com.xeiam.xchange.Exchange exchangeXChange;
	private String identifier = Currencies.BTC;
	private String currency = Currencies.USD;

	private long mLastUpdateTicker = 0;
	private Ticker mLastTicker;

	public Exchanger(String exchangeClass) {
		this.exchangeXChange = ExchangeFactory.INSTANCE.createExchange(exchangeClass);
		init();
	}

	protected abstract void init();

	public Ticker getLastTicker() {

		if (mLastTicker == null || (System.currentTimeMillis() - mLastUpdateTicker) > EXPIRETIME_TICKER) { // keep the ticker for a while
			try {
				PollingMarketDataService pollingMarketDataService = exchangeXChange.getPollingMarketDataService();
				Ticker ticker = pollingMarketDataService.getTicker(identifier, currency);

				mLastTicker = ticker;

			} catch (Exception e) {
				e.printStackTrace();
				mLastTicker = null;
			}
		}

		return mLastTicker;

	}
	
	public abstract boolean isTradingSupported();

	public com.xeiam.xchange.Exchange getExchangeXChange() {
		return exchangeXChange;
	}

	public String getExchangerName() {
		return exchangeXChange.getDefaultExchangeSpecification().getExchangeName();
	}

}
