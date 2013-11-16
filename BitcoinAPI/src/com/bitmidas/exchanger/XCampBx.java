package com.bitmidas.exchanger;

import com.xeiam.xchange.campbx.CampBXExchange;

public class XCampBx extends Exchanger {

	public XCampBx() {
		super(CampBXExchange.class.getName());
	}

	@Override
	public void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}

}
