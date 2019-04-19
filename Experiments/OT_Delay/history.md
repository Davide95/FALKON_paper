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
	
	
## 4/4/2019
* Sistemata normalizzatione. Nuovi valori:
centers, sigma, lambda, iterations, RMSE-vs, RMSE-ts
10.000,	2,	1e-16,	8 ,	39.49,	NA
-,		-,	1e-8 ,	11,	36.19,	NA
-,		-,	1e-4 ,	4 ,	36.09,	NA
-,		-,	1e-2 ,	2 ,	38.27,	NA
-,		4,	1e-4 ,	3 ,	36.63,	NA
-,		-,	1e-8 ,	11, 35.89,	NA
-,		6,	-    ,	- , 35.65,	NA
-,		-,	-	 ,	12,	35.64,	36.55 <- migliore
50.000,	-,	-	 ,	8,	35.64,	NA
-,		-,	1e-6 ,	- , 36.17,	NA
-,		8,	1e-8 ,	9 ,	35.82,	NA
-,		-,	1e-10,	11,	35.92,	NA
-,		-,	1e-6 ,	4 ,	36.38,	NA
-,		7,	1e-8 ,	11,	35.74,	36.64
-,		-,	1e-6 ,	9 ,	36.3 ,	NA
-,		-,	1e-10,	11,	36.51,	NA

* 4/9/2019
* Christian ha un processodi matlab che occupa il 76.8 GB di RAM fermo da almeno 6 gg;

* Usato fminunc
Sigma params: -0.9912 -1.9376 -1.5306 1.4155 -0.8431 0.1389 -0.3509 0.3040 (1000 points, 10.000 centers)
lambda, iterations, RMSE
1e-16, 20, 37.03
1e-8, 20, 35.17
1e-7, 20, 34.99
1e-6, 20, 35.14
1e-4, 4, 36.08


TODO
* Riprodurre 37% di errore su un ts di 100.000 (niente vs)
* Provare a cercare DSs with FC NN

* 4/17/2019
	* GPL scopo di lucro: NOPE
	* Quel 5.9 ? tutto il dataset
	
* 4/19/2019
centers, sigma, lambda, iterations, RMSE-ts
10000,	2,	1e-16,	49, 46.07
-,		2,	1e-8,	50, 33.18