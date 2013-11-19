public class Daemon {

	public static void main(String[] args) {

		System.out.println("starting");

		long TIME_SLEEP = 60 * 1000;
		final FetcherAPI fetcher = new FetcherAPI();
		// final Arbitrage arbitrage = new Arbitrage();

		while (true) {

			new Thread(new Runnable() {

				@Override
				public void run() {

					try {
						fetcher.storeTickersInDB();
						// arbitrage.watch();
						System.out.println();
					} catch (Exception e) {
						e.printStackTrace();
					}

				}
			}).start();

			try {
				Thread.sleep(TIME_SLEEP);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}

		}

	}

}
