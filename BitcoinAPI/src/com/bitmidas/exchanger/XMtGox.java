package com.bitmidas.exchanger;

import com.xeiam.xchange.Exchange;
import com.xeiam.xchange.ExchangeSpecification;
import com.xeiam.xchange.mtgox.v2.MtGoxExchange;

public class XMtGox extends Exchanger {

	public XMtGox() {
		super(MtGoxExchange.class.getName());
	}

	public void init() {
		Exchange exchange = getExchangeXChange();

		ExchangeSpecification specification = exchange.getDefaultExchangeSpecification();

		specification.setApiKey("APIKEY");

		getExchangeXChange().applySpecification(specification);
	}

	@Override
	public boolean isTradingSupported() {
		return true;
	}

}
