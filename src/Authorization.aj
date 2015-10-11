/**
 *  This aspect performs two tasks: First, it intercepts requests by crew members to
 *  obtain information on the purpose of the mission. Second, it intercepts requests by crew
 *  members to shut down the on-board computer.
 * @author Mark Chmilar ID# 26827926
 *
 */
public aspect Authorization {

	declare precedence:   Logger, LifeSupport, Authorization;
	
	// Keeps track of how many times a specific crew member
	// has tried to shut down the system
	int Crew.shutDownAttempts = 0;	
	
	
	// Accessor method for the number of shutdown attempts
	// by a specific crew member
	public int Crew.getShutDownAttempts() {
		return this.shutDownAttempts;
	}
	
	// Mutator method used to count how many
	// times a specific crew member has tried
	// to shutdown the system
	public void Crew.incrementShutDownAttempts() {
		this.shutDownAttempts++;
	}
	
	// This pointcut captures shutDown method calls to OnBoardcomputer, captures the 
	// context of the sending crew member
	pointcut shutdown(Crew crewMember): call(void OnBoardComputer.shutDown()) && this(crewMember);
	
	void around(Crew crewMember): shutdown(crewMember) {
		if (crewMember.getShutDownAttempts() == 0) { // Crew member's first attempt
			System.out.println("Can't do that " + crewMember + ".");
		} else if (crewMember.getShutDownAttempts() == 1) { // Crew member's second attempt
			System.out.println("Can't do that " + crewMember + " and do not ask me again.");
		} else { // Crew member's third and final allowed attempt
			System.out.println("You are being retired " + crewMember + ".");
			crewMember.kill();
		} 
		crewMember.incrementShutDownAttempts();
	}
	
	// This pointcut captures crew members attempts to get the mission purpose from HAL
	pointcut missionPurpose(Crew crewMember): call(String OnBoardComputer.getMissionPurpose()) && this(crewMember);
		
	String around(Crew crewMember) : missionPurpose(crewMember) {
		return "HAL cannot disclose that information " + crewMember;
	}
	
}
