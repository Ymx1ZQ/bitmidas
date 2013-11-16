package com.bitmidas.exchanger;

import com.xeiam.xchange.btce.BTCEExchange;

public class XBtcE extends Exchanger {

	public XBtcE() {
		super(BTCEExchange.class.getName());
	}

	@Override
	public void init() {
	}

}
