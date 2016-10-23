class HelloWorld {

    static int x, y;
    
    static void main() {
	x = Support.random(0, 10);
	y = x*x + 3;
	assert(5 < y);
    }

}
