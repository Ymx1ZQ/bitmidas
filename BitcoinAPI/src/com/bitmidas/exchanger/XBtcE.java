package com.bitmidas.exchanger;

import com.xeiam.xchange.Exchange;
import com.xeiam.xchange.ExchangeSpecification;
import com.xeiam.xchange.btce.BTCEExchange;

public class XBtcE extends Exchanger {

	private static XBtcE instance;

	private XBtcE() {
		super(BTCEExchange.class.getName());
	}

	@Override
	public void init(Exchange exhange, ExchangeSpecification specification) {

		specification.setApiKey("7RA66MRR-FO1OVEQY-PA8P7HX7-DL92UW2N-2XUSD39P");
		specification.setSecretKey("b69b62f6dff6f6548cb0f1b4c1c5364496cd9d8b43b3f8a56d2bc24a5fc26431");
		specification.setTradeFeePercent(0.25);

		exhange.applySpecification(specification);

	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}

	public synchronized static XBtcE getInstance() {
		if (instance == null) {
			instance = new XBtcE();
		}

		return (XBtcE) instance;
	}

}
