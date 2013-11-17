package com.bitmidas.trading;

import java.util.Date;

public class TickerBM {

	private long high;
	private long low;
	private long last;
	private long bid;
	private long ask;
	private long volume;
	private Date time;
	
	public TickerBM(long high, long low, long last, long bid, long ask, long volume, Date time) {
		this.high = high;
		this.low = low;
		this.last = last;
		this.bid = bid;
		this.ask = ask;
		this.volume = volume;
		this.time = time;
	}

	public long getHigh() {
		return high;
	}

	public void setHigh(long high) {
		this.high = high;
	}

	public long getLow() {
		return low;
	}

	public void setLow(long low) {
		this.low = low;
	}

	public long getLast() {
		return last;
	}

	public void setLast(long last) {
		this.last = last;
	}

	public long getBid() {
		return bid;
	}

	public void setBid(long bid) {
		this.bid = bid;
	}

	public long getAsk() {
		return ask;
	}

	public void setAsk(long ask) {
		this.ask = ask;
	}

	public long getVolume() {
		return volume;
	}

	public void setVolume(long volume) {
		this.volume = volume;
	}

	public Date getTime() {
		return time;
	}

	public void setTime(Date time) {
		this.time = time;
	}

	
	
}
