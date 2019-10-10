
import java.util.*;

class Node {
	// declaring the variables for the node.
	String label;
	ArrayList<Node> children = new ArrayList<Node>();
	ArrayList<Integer> cost = new ArrayList<Integer>();
	Node parent;
	String location;
	int nS;
	int nMA;
	int nMB;
	int nL;
	int h;
	int g = 1;
	int f;
	int value;

	/**
	 * returns the total number of packages in the wrong place.
	 * 
	 * @return
	 */
	int getWP() {
		return nS + nMA + nMB + nL;
	}

	/**
	 * first heuristic: gets the number of total packages currently in the wrong
	 * place.
	 * 
	 * second heuristic: gets the package type with the most amount of packages in
	 * the wrong place and multiples it by 2
	 * 
	 * @return
	 */
	int geth() {
		return nS + nMA + nMB + nL;
		// return Math.max(Math.max(nMB, nL),Math.max(nS, nMA));

	}

	/**
	 * Calculates the sum (f) of the heuristic and the path cost and returns it.
	 * 
	 * @return
	 */
	int getf() {
		return this.g + this.h;
	}

}