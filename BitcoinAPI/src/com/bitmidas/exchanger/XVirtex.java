package com.bitmidas.exchanger;

import com.xeiam.xchange.virtex.VirtExExchange;

public class XVirtex extends Exchanger {

	public XVirtex() {
		super(VirtExExchange.class.getName());
	}

	@Override
	protected void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return false;
	}

}
