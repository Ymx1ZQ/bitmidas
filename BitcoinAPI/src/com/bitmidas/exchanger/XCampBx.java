package com.bitmidas.exchanger;

import com.xeiam.xchange.campbx.CampBXExchange;

public class XCampBx extends Exchanger {

	private static XCampBx instance;

	private XCampBx() {
		super(CampBXExchange.class.getName());
	}

	@Override
	public void init() {
	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}

	public synchronized static XCampBx getInstance() {
		if (instance == null) {
			instance = new XCampBx();
		}

		return (XCampBx) instance;
	}

}
