package com.bitmidas.exchanger;

import com.xeiam.xchange.bitcoinaverage.BitcoinAverageExchange;

public class XBitCoinAverage extends Exchanger {

	private static XBitCoinAverage instance;
	
	private XBitCoinAverage() {
		super(BitcoinAverageExchange.class.getName());
	}

	@Override
	protected void init() {
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
