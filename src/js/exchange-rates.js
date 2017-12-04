EXHANGE_RATES = {
	EUR: {
		'EUR/BTC': 'eur-btc',
		'EUR/ETH': 'eur-eth'
	},
	USD: {
		'USD/BTC': 'usd-btc',
		'USD/ETH': 'usd-eth'
	}
};

const URL = 'https://api.cryptonator.com/api/ticker/';

function getExchangeRates() {
	var currencies = Object.keys(EXHANGE_RATES);
	for (var i = 0; i < currencies.length; i++) {
		var exchanges = Object.keys(EXHANGE_RATES[currencies[i]]);
		for (var j = 0; j < exchanges.length; j++) {
			exchange = EXHANGE_RATES[currencies[i]][exchanges[j]];
			var url = URL + exchange;
			fetchExchangeRates(url);
		}
	}
}

function fetchExchangeRates(url) {
	axios.get(url).then(function(response) {
		var data = response.data;
		var info;
		if (data.success) {
			info = {
				price: data.ticker.price,
				change: data.ticker.change,
				base: data.ticker.base,
				target: data.ticker.target
			};
		} else {
			info = {
				price: '',
				change: '',
				base: data.ticker.base,
				target: data.ticker.target
			};
		}
		populateExchangeRates(info);
	});
}

function populateExchangeRates(info) {
  var percentage_change;
  console.log(info.change < 0);
  if(info.change < 0 ){
    percentage_change = '<p class="ticker-percentage-change negative-change"> ' + info.change  + ' </p> ';
  }
  else{
    percentage_change = '<p class="ticker-percentage-change positive-change"> ' + info.change  + ' </p> ';
  }
  console.log(percentage_change);
  
	$('#ticker_container').append(
  '<div class="ticker-item">'+
    '<h4 class="ticker-name">'+ info.base +'/'+info.target + '</h4>' +
      '<p class="ticker-price">'+ info.price + ' BTC '+ '</p>' +
       percentage_change +
    '</div>'
  );
}
