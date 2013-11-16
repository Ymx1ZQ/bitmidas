package com.bitmidas.exchanger;

import com.xeiam.xchange.kraken.KrakenExchange;

public class XKraken extends Exchanger {

	public XKraken() {
		super(KrakenExchange.class.getName());
	}

	@Override
	protected void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}

}
