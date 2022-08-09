

int main(){


r2 = 0x20200000; //gpio
ip = 0;
r4 = r2;
r3 = 0x00030d40;
lr = 0x00030d40;
r1 = 0x20200000; //gpio


*lr = r3;
*r1 = r2;
r1 = r2 + 0x4; //address of GPIO Function Select 1 register 
r0 = 0x000182ec;

r1 = *r1 || 0x40000 //defines Pin 16 as OUTPUT 

r3 = 0x000182e0 //timer variable
*(r2 + 0x4) = r1;



while(1){
	//*(r0) = 
	// [...]


	if(r2 <= 2) { //r2 is morser var here
		r5 = 65536; //=0x10000
		
		//8048
		//[...]
		
		
		
	}
	
	
	//80c0 gets executed nontheless
	r1 = *lr;
	*r3 = 0;
	r2 = 0;
	r1 = r1*3;	
	


	while(r1 > r2) {
		//jump tp 80d8
		//wait for timer var (r2)
		r2 = *(r3);
		r2 = r2+1;
		*(r3) = r2;
	}
	
	
		
	//80f0
	*(r0) = ip; //morser = 0
	r2 = *(r0);
	
	if(r2 <= 2) {
		r5 = 65536; //=0x10000
	}

}



}

//for loop which cycles 3 times and has different INITS every time


