package com.bitmidas.exchanger;

import com.xeiam.xchange.bitcoinaverage.BitcoinAverageExchange;

public class XBitCoinAverage extends Exchanger{

	public XBitCoinAverage() {
		super(BitcoinAverageExchange.class.getName());
	}

	@Override
	protected void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return false;
	}

}
