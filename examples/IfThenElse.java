class HelloWorld1 {

    static int x;
    
    static void main() {
	x = Support.random(0, 10);
	x = 2*x+5;
	if (x < 15) {
	    x = x-1;
	} else {
	    x = x-10;
	}
	assert(x < 16);
    }

}
