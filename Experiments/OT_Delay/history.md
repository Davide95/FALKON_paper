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
10.000, 2, 1e-4, 3, 39.13, NA
-, 6, 1e-16, 5, 35.76, NA
