package com.bitmidas.exchanger;

import com.xeiam.xchange.Exchange;
import com.xeiam.xchange.ExchangeSpecification;
import com.xeiam.xchange.bitcoinaverage.BitcoinAverageExchange;

public class XBitCoinAverage extends Exchanger {

	private static XBitCoinAverage instance;
	
	private XBitCoinAverage() {
		super(BitcoinAverageExchange.class.getName());
	}

	@Override
	protected void init(Exchange exhange, ExchangeSpecification specification) {
	}

	@Override
	public boolean isTradingSupported() {
		return false;
	}

	public synchronized static XBitCoinAverage getInstance() {
		if (instance == null) {
			instance = new XBitCoinAverage();
		}

		return (XBitCoinAverage) instance;
	}

}
