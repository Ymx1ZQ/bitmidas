package com.bitmidas.exchanger;

import java.util.ArrayList;

public class ExchangerHelper {

	public static ArrayList<Exchanger> getListExchanger() {

		ArrayList<Exchanger> listExchanger = new ArrayList<Exchanger>();

		listExchanger.add(XBitCoinAverage.getInstance());
		// listExchanger.add(XBitCurex.getInstance()); // TODO NO BTC USD
		listExchanger.add(XBitStamp.getInstance());
		// listExchanger.add(XBTCChina.getInstance());// TODO NO BTC USD
		listExchanger.add(XBtcE.getInstance());
		listExchanger.add(XCampBx.getInstance());
		listExchanger.add(XKraken.getInstance());
		listExchanger.add(XMtGox.getInstance());
		// listExchanger.add(virtex); // TODO NO BTC USD

		return listExchanger;
	}

}
