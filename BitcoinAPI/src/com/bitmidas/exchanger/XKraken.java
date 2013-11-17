package com.bitmidas.exchanger;

import com.xeiam.xchange.kraken.KrakenExchange;

public class XKraken extends Exchanger {

	private static XKraken instance;

	private XKraken() {
		super(KrakenExchange.class.getName());
	}

	@Override
	protected void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}

	public synchronized static XKraken getInstance() {
		if (instance == null) {
			instance = new XKraken();
		}

		return (XKraken) instance;
	}

}
