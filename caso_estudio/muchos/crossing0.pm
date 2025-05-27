dtmc

// probabilidades de que se coman
const double p_lobo_come = 0;
const double p_oveja_come = 0;

module river
	// objetos
	// 0 -> muerto, 1 -> izquierdo, 2-> derecho
	lechuga:  [0..2] init 1;
	oveja: 	  [0..2] init 1;
	lobo:     [0..2] init 1;
	granjero: [1..2] init 1;
	viajando: bool init false;
	
	// granjero va a cruzar
	[] viajando = false -> (granjero' =  3 - granjero) & (viajando' = true);
	[] viajando = false & granjero = lechuga -> (granjero' =  3 - granjero) & (lechuga' =  3 - lechuga) & (viajando' = true);
	[] viajando = false & granjero = oveja   -> (granjero' =  3 - granjero) & (oveja' =  3 - oveja) & (viajando' = true);
	[] viajando = false & granjero = lobo    -> (granjero' =  3 - granjero) & (lobo' =  3 - lobo) & (viajando' = true);
	
	// el no-determinismo es intencional para simplificar el modelado
	// esto resutla en que cualquiera de las opciones (posibles) tiene igual probabilidad
	
	// están cruzando, se comen?
	[] viajando = true & (lobo != oveja | lobo = granjero) & (oveja != lechuga | oveja = granjero) -> (viajando' = false);
	[] viajando = true & lobo = oveja & lobo != granjero -> p_lobo_come:(oveja' = 0) & (viajando' = false) + (1-p_lobo_come):(viajando' = false);
	[] viajando = true & oveja = lechuga & oveja != granjero -> p_oveja_come:(lechuga' = 0) & (viajando' = false) + (1-p_oveja_come):(viajando' = false);

	// acá también hay no-determinismo 
	// solo importa en el caso en el que el granjero del otro lado sin las tres cosas
endmodule

rewards "crueces"
	(viajando = false) : 1;
endrewards

//rewards "sitaciones_de_peligro"
//	(viajando = true) & (oveja != granjero) & (oveja = lobo | oveja = lechuga): 1;
//endrewards
