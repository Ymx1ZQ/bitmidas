package com.bitmidas.exchanger;

import com.xeiam.xchange.bitstamp.BitstampExchange;

public class XBitStamp extends Exchanger {

	public XBitStamp() {
		super(BitstampExchange.class.getName());
	}

	@Override
	public void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}


}
