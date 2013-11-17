package com.bitmidas.exchanger;

import com.xeiam.xchange.Exchange;
import com.xeiam.xchange.ExchangeSpecification;
import com.xeiam.xchange.bitstamp.BitstampExchange;

public class XBitStamp extends Exchanger {

	private static XBitStamp instance;

	private XBitStamp() {
		super(BitstampExchange.class.getName());
	}

	@Override
	public void init(Exchange exhange, ExchangeSpecification specification) {

		specification.setTradeFeePercent(0.5);

		exhange.applySpecification(specification);
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
