import java.util.ArrayList;

public class AStar {
	/**
	 * Main function of the program.
	 * 
	 * @param args
	 */
	public static void main(String args[]) {
		ArrayList<Node> route = new ArrayList<Node>();
		Node root = new Node();
		// starting location.
		root.location = "Truck";
		// number of each package in the appropriate location at the start.
		root.nS = 3;
		root.nMA = 4;
		root.nL = 2;
		root.nMB = 0;
		root.h = root.geth();
		Node temp1 = root;
		// Calls the findPath function to find the best path.
		temp1 = findPath(root);

		while (temp1.parent != null) {
			route.add(temp1);
			temp1 = temp1.parent;

		}
		// prints whole path of route
		System.out.print("Path: ");
		int j = route.size();
		for (int i = 0; i < route.size(); i++) {
			System.out.print(route.get(j - 1).location + " -> ");
			j--;
		}
		// prints each move on a new line
		System.out.println();
		System.out.println("Moves:");
		j = route.size();
		for (int i = 0; i < route.size() - 1; i++) {
			System.out.printf("%10s -> %-10s Move:%d\n", route.get(j - 1).location, route.get(j - 2).location, i + 1);
			j--;
		}

	}

	/**
	 * Finds the most efficient path to deliver packages between locations using an
	 * a* search to do so.
	 * 
	 * @param n
	 * @return
	 */
	public static Node findPath(Node n) {
		ArrayList<Node> missed = new ArrayList<Node>();
		int i = 1;
		int parent = 0;
		boolean found = false;

		Node root = new Node();
		// set the parameters for the first node in the search.
		root.parent = n;
		root.nS = n.nS;
		root.nL = n.nL;
		root.nMA = n.nMA;
		root.nMB = n.nMB;
		root.g = n.g;
		root.location = n.location;
		root.h = n.h;
		root.value = 0;
		n.children.add(root);
		// loops until packages are delivered to the appropriate location.
		while (!found) {
			Node child1 = new Node();
			Node child2 = new Node();
			// Sets the parameters of the 2 children of the node.
			child1.parent = n.children.get(parent);
			child1.nS = n.children.get(parent).nS;
			child1.nL = n.children.get(parent).nL;
			child1.nMA = n.children.get(parent).nMA;
			child1.nMB = n.children.get(parent).nMB;
			child1.g = n.g;
			child1.value = i;

			i++;
			child2.nS = n.children.get(parent).nS;
			child2.nL = n.children.get(parent).nL;
			child2.nMA = n.children.get(parent).nMA;
			child2.nMB = n.children.get(parent).nMB;
			child2.g = n.g;
			child2.parent = n.children.get(parent);
			child2.value = i;
			System.out
					.println("S-- " + child1.nS + "  L-- " + child1.nL + "  MA-- " + child1.nMA + "MB-- " + child1.nMB);
			i++;
			// If the node is at the truck it will set the children to go to
			// Warehouse A and Warehouse B.
			if (child2.parent.location.equals("Truck")) {
				child1.location = "Warhouse A";
				child2.location = "Warhouse B";
				// Child 1 is at Warehouse A so move 1 small package there if
				// possible.
				if (child1.nS != 0) {
					child1.nS = child1.nS - 1;
				}
				// Child 2 is at warehouse B so move 1 large package there if
				// possible.
				if (child2.nL != 0) {
					child2.nL = child2.nL - 1;
				}

			}
			// if the location of the node is Warehouse A then set the children
			// to Warehouse B and Truck.
			if (child2.parent.location.equals("Warhouse A")) {
				child1.location = "Warhouse B";
				child2.location = "Truck";
				// Child 2 is at the Truck so move 1 Medium package from
				// Warehouse A to the Truck.
				if (child2.nMA != 0) {
					child2.nMA = child2.nMA - 1;
				}

			}
			// if the location of the node is Warehouse B then set the children
			// to Truck and Warehouse A.
			if (child2.parent.location.equals("Warhouse B")) {
				child1.location = "Truck";
				child2.location = "Warhouse A";
				// Child 1 is at the Truck so move 1 Medium package there from
				// Warehouse B.
				if (child1.nMB != 0) {
					child1.nMB--;
				}

			}
			// calculate the heuristics of the children
			child1.h = child1.geth();
			child2.h = child2.geth();
			// calculate the sum (f) of the heuristic + path cost for the
			// children
			child1.f = child1.getf();
			child2.f = child2.getf();
			// Adds the children to the list of nodes already created.
			n.children.add(child1);
			n.children.add(child2);
			// If the f value of Child 1 is less than the Child 2 then add child
			// 2 to a list of nodes that haven't been visited.
			if (child1.getf() <= child2.getf()) {
				missed.add(child2);
				// set the node to expand next.
				parent = child1.value;
				// repeat for every node that has been missed.
				for (int k = 0; k < missed.size(); k++) {
					// if it finds a node with a lower f value it will set that
					// as the new node to expand and add child 1 to the list.
					if (child1.f > missed.get(k).f) {
						System.out.println("missed" + missed.get(k).value);
						missed.add(child1);
						child1 = missed.get(k);
						parent = missed.get(k).value;
						missed.remove(k);
						n.g = missed.get(k).g;
					}
				}
				// If the f value of Child 2 is less than the Child 1 then add
				// child 1 to a list of nodes that haven't been visited
			} else {
				missed.add(child1);
				// set the node to expand next.
				parent = child2.value;
				// repeat for every node that has been missed
				for (int k = 0; k < missed.size(); k++) {
					// if it finds a node with a lower f value it will set that
					// as the new node to expand and add child 2 to the list.
					if (child2.f > missed.get(k).f) {
						missed.add(child2);
						System.out.println(missed.get(k).f);
						child2 = missed.get(k);
						parent = missed.get(k).value;
						missed.remove(k);
						n.g = missed.get(k).g;
					}
				}

			}
			System.out.println("child1 = " + child1.f + ", child2 = " + child2.f);
			System.out.println();
			System.out.println();
			System.out.println();
			// if a path is found that delivers all the boxes return the final
			// node.
			if (child1.getWP() == 0) {

				found = true;
				return child1;
			}
			if (child2.getWP() == 0) {

				found = true;
				return child2;
			}

			n.g++;
		}
		return n;
	}

}