package com.bitmidas.exchanger;

import com.xeiam.xchange.bitcurex.BitcurexExchange;

public class XBitCurex extends Exchanger {

	public XBitCurex() {
		super(BitcurexExchange.class.getName());
	}

	@Override
	protected void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return false;
	}

}
