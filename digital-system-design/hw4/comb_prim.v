primitive comb_prim(Y, A, B, C, D);
	// define output and input
	output Y;
	input A, B, C, D; 
	
	table
		// primitive table
		0 0 0 0 : 0; 
		0 0 0 1 : 0;
		0 0 1 0 : 0;
		0 0 1 1 : 0;
		0 1 0 0 : 0;
		0 1 0 1 : 0;
		0 1 1 0 : 1;
		0 1 1 1 : 0;
		1 0 0 0 : 0; 
		1 0 0 1 : 0;
		1 0 1 0 : 0;
		1 0 1 1 : 0;
		1 1 0 0 : 0;
		1 1 0 1 : 0;
		1 1 1 0 : 0;
		1 1 1 1 : 0;   
	endtable
endprimitive
	
	