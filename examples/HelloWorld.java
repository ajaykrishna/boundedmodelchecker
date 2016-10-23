class HelloWorld {

    static int x;
    //    static boolean b; // Only boolean variables for the moment.

    static void utile() {
	//	b = true;
	while (x<5) x=x+1;// block of size >1 are not allowed -> modif the grammar !
    }
    
    static void main() {
	x = 2+2;
	//	b = x < 18;
	// assert(b);
	if (x<1515) x=12 ; else x=42;
    }

}
