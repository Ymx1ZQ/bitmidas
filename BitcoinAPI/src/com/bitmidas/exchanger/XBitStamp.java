package com.bitmidas.exchanger;

import com.xeiam.xchange.bitstamp.BitstampExchange;

public class XBitStamp extends Exchanger {

	private static XBitStamp instance;

	private XBitStamp() {
		super(BitstampExchange.class.getName());
	}

	@Override
	public void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}

	public synchronized static XBitStamp getInstance() {
		if (instance == null) {
			instance = new XBitStamp();
		}

		return (XBitStamp) instance;
	}

}
