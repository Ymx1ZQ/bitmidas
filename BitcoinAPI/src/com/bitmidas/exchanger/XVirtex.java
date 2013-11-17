package com.bitmidas.exchanger;

import com.xeiam.xchange.virtex.VirtExExchange;

public class XVirtex extends Exchanger {

	private static XVirtex instance;

	private XVirtex() {
		super(VirtExExchange.class.getName());
	}

	@Override
	protected void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return false;
	}

	public synchronized static XVirtex getInstance() {
		if (instance == null) {
			instance = new XVirtex();
		}

		return (XVirtex) instance;
	}

}
