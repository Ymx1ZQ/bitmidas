package com.bitmidas.exchanger;

import com.xeiam.xchange.Exchange;
import com.xeiam.xchange.ExchangeSpecification;
import com.xeiam.xchange.campbx.CampBXExchange;

public class XCampBx extends Exchanger {

	private static XCampBx instance;

	private XCampBx() {
		super(CampBXExchange.class.getName());
	}

	@Override
	public void init(Exchange exchange, ExchangeSpecification specification) {
		
		specification.setTradeFeePercent(0.55);
		
		exchange.applySpecification(specification);
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
