package com.bitmidas.exchanger;

import com.xeiam.xchange.Exchange;
import com.xeiam.xchange.ExchangeSpecification;
import com.xeiam.xchange.mtgox.v2.MtGoxExchange;

public class XMtGox extends Exchanger {

	private static XMtGox instance;

	private XMtGox() {
		super(MtGoxExchange.class.getName());
	}

	public void init(Exchange exhange, ExchangeSpecification specification) {

		specification.setApiKey("6026e0f1-a505-456b-9b0e-69f3d5c41ba3");
		specification.setSecretKey("DQxyKbE/AX16d/CSkIq2Kd6irpDV5arUIz6NJ7jGikPrAV+U38lSlnFQOktRzyXGY2GBd7zz8WxhvJis4usyhQ==");
		specification.setTradeFeePercent(0.6);

		exhange.applySpecification(specification);
	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}

	public synchronized static XMtGox getInstance() {
		if (instance == null) {
			instance = new XMtGox();
		}
		return (XMtGox) instance;
	}

}
