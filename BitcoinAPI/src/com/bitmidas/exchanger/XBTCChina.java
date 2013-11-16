package com.bitmidas.exchanger;

import com.xeiam.xchange.btcchina.BTCChinaExchange;

public class XBTCChina extends Exchanger{

	public XBTCChina() {
		super(BTCChinaExchange.class.getName());
	}

	@Override
	protected void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}

}
