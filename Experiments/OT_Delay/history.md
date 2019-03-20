
## TODO
* Provare kernel lineare;
* Provare con meno punti;

## 3/20/2019
* Trovato un nuovo dataset con tutte le informazioni: https://www.dropbox.com/s/32lz1vnjx3bg9hd/airline.pickle.zip

* Senza z-score: 
	* RMSE > 37 validation set
	* Sigma = 12
	* Lambda = 10^-16
	* 10.000 centers
	* 5 iterations
	Conclusione: usare z-score

* Codice nelle pagine degli autori dei paper:
	* https://github.com/SheffieldML/GPy
	* http://bit.ly/2qwR5eW;
	
* Tick tock mi restituisce uno strano valore