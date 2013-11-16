public class Daemon {

	public static void main(String[] args) {

		System.out.println("starting");

		long ONEMINUTE = 60 * 1000;
		final FetcherAPI fetcher = new FetcherAPI();

		while (true) {

			new Thread(new Runnable() {

				@Override
				public void run() {

					try {
						fetcher.storeTickersInDB();
					} catch (Exception e) {
						e.printStackTrace();
					}

				}
			}).start();

			try {
				Thread.sleep(ONEMINUTE);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}

		}

	}

}
