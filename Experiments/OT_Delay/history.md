## 3/20/2019
* Senza z-score: 
	* RMSE > 36 validation set
	* Sigma = 18
	* Lambda = 10^-16
	* 10.000 centers
	* 5 iterations
	Conclusione: usare z-score o non usarlo è uguale

* Codice nelle pagine degli autori dei paper:
	* https://github.com/SheffieldML/GPy
	* http://bit.ly/2qwR5eW;
	
* Tick tock mi restituisce uno strano valore

* Kernel lineare (Imprevedibile ad ogni iterazione)

* Trovato un nuovo dataset con tutte le informazioni: https://www.dropbox.com/s/32lz1vnjx3bg9hd/airline.pickle.zip
Test con il nuovo kernel:
centers, sigma, lambda, iterations, RMSE-vs, RMSE-ts
10.000, 2, 1e-16, 6, 36.31, 36.28 (0.86 MSE, 0.89-0.81 papers)
-, 6, 1e-16, 5, 36.3, NA
-, -, 1e-8, 4, 37.8
-, 1, 1e-16, 3, 39.8
10.000, 3, -, 7, 36.61, NA
50.000, 6, 1e-16, 2, 35.706788, NA
-, -, -, 4, 35.8, NA
-, -, 1e-8, 4, 37.2, NA
-, 2, 1e-16, 4, 35.7
