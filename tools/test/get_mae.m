function MAE = get_mae(GT,salmap)
	if(max(max(salmap)) > 1)
		salmap = salmap./255;
	end
	if(max(max(GT)) > 1)
		GT = GT./255;
	end
	MAE = mean2(abs(double(GT) - salmap));
