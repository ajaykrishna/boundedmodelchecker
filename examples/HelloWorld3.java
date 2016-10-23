class HelloWorld1 {

    static int x;
    
    static void main() {
	x = Support.random(0, 10);
	x = 2*x+5;
	assert(x < 26);
    }

}
