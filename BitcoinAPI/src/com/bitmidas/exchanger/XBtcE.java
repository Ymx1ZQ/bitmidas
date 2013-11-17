package com.bitmidas.exchanger;

import com.xeiam.xchange.btce.BTCEExchange;

public class XBtcE extends Exchanger {

	private static XBtcE instance;

	private XBtcE() {
		super(BTCEExchange.class.getName());
	}

	@Override
	public void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}

	public synchronized static XBtcE getInstance() {
		if (instance == null) {
			instance = new XBtcE();
		}

		return (XBtcE) instance;
	}

}
