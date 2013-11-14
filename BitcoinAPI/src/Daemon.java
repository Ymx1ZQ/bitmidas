import com.xeiam.xchange.dto.marketdata.Ticker;

public class Daemon {

	public static void main(String[] args) {

		System.out.println("starting");

		long ONEMINUTE = 60 * 1000;
		FetcherAPI fetcher = new FetcherAPI();

		while (true) {
			try {
				Ticker lastTicker = fetcher.getLastTicker();
				fetcher.saveTicker(lastTicker);

				System.out.println("saved ticker: " + lastTicker);
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				Thread.sleep(ONEMINUTE);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

	}

}
