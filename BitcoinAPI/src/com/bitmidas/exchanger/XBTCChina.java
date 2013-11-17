package com.bitmidas.exchanger;

import com.xeiam.xchange.btcchina.BTCChinaExchange;

public class XBTCChina extends Exchanger {

	private static XBTCChina instance;

	private XBTCChina() {
		super(BTCChinaExchange.class.getName());
	}

	@Override
	protected void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}

	public synchronized static XBTCChina getInstance() {
		if (instance == null) {
			instance = new XBTCChina();
		}

		return (XBTCChina) instance;
	}

}
