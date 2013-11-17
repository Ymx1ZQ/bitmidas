package com.bitmidas.exchanger;

import com.xeiam.xchange.bitcurex.BitcurexExchange;

public class XBitCurex extends Exchanger {

	private static XBitCurex instance;

	private XBitCurex() {
		super(BitcurexExchange.class.getName());
	}

	@Override
	protected void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return false;
	}

	public synchronized static XBitCurex getInstance() {
		if (instance == null) {
			instance = new XBitCurex();
		}

		return (XBitCurex) instance;
	}

}
