## 3/20/2019
* Senza z-score: 
	* RMSE > 36 validation set
	* Sigma = 18
	* Lambda = 10^-16
	* 10.000 centers
	* 5 iterations
	Conclusione: usare z-score o non usarlo ? uguale

* Codice nelle pagine degli autori dei paper:
	* https://github.com/SheffieldML/GPy
	* http://bit.ly/2qwR5eW;

* Kernel lineare
centers, sigma, iterations, RMSE-vs, MSE-ts
1.000, 1e-16, 10, 38.87, 38.9
-, 1e-8, 10, 38.34, 39
-, 0, 10, 1000, 2246
10.000, 1e-16, 6, 38.6, NA
-, 1e-30, 3, 39, NA


* Trovato un nuovo dataset con tutte le informazioni: https://www.dropbox.com/s/32lz1vnjx3bg9hd/airline.pickle.zip
Test con il nuovo kernel:
centers, sigma, lambda, iterations, RMSE-vs, RMSE-ts
10.000, 2, 1e-16, 6, 36.31, 36.28 (0.86 MSE, 0.89-0.81 papers) <- migliore, t5 = 0.0944
-, 6, 1e-16, 5, 36.3, NA
-, -, 1e-8, 4, 37.8, NA
-, 1, 1e-16, 3, 39.8, NA
10.000, 3, -, 7, 36.61, NA
50.000, 6, 1e-16, 2, 35.706788, NA
-, -, -, 4, 35.8, NA
-, -, 1e-8, 4, 37.2, NA
-, 2, 1e-16, 4, 35.7, NA <- migliore
100.000, 2, 1e-16, 2, 35.79, NA <- migliore
5.000, 2, 1e-16, 10, 36.26, 37.2
-, -, 1e-14, 10, 36.99, 35.8
-, 6, 1e-16, 10, 36.10, 35.8 <- migliore
-, 8, -, 10, 38, NA
-, 8, 1e-8, 7, 38, NA
1.000, 6, 1e-16, 36.15, 37.2
-, 2, -, 38.65, 38.06
-, 5, 1e-16, 36.03, 37.72 <- migliore
500, 4, 1e-16, 37.23, 37.24
-, 2, -, 37.8, 39.1
-, 6, -, -, 36.2
500, 6, 1e-14, 37.01, 37.13 <- migliore
100, -, 1e-10, 37, 37.4

## 3/25/2019

* Tick tock mi restituisce uno strano valore:
	* t5 = 0.0944 invece di 3:51 min;