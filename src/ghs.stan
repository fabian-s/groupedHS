data {
     int<lower=0> n; // num obs
     int<lower=0> d; // num inp
     int<lower=0> g; // num groups
     
     int group_ids[d];
     vector[n] y; // out
     matrix[n, d] x; // inp

     real<lower=0> scale_icept;
     real<lower=0> scale_global;
}

parameters{
     real beta0;
     vector<lower=0>[g] lambda;
     vector[d] z;
     real<lower=0> sigma;
     real<lower=0> tau;
}

transformed parameters{
     vector[d] beta;
     vector[n] f;
     
     //beta = z .* lambda*tau;
     for (m in 1:d) {
		     	beta[m] = z[m] * lambda[group_ids[m]]*tau;
  	 }
     f = beta0 + x*beta;
}

model {
     z ~ normal(0, 1);
     lambda ~ cauchy(0, 1);
     tau ~ cauchy(0, scale_global*sigma);
     beta0 ~ normal(f, scale_icept);

     y ~ normal(f, sigma);
}
