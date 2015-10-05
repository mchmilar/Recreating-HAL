
public aspect Authorization {

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
	
	pointcut shutdown(Crew crewMember): execution(void Crew.shutDownSystem()) && this(crewMember);
	
	void around(Crew crewMember): shutdown(crewMember) {
		if (crewMember.getShutDownAttempts() == 0) {
			System.out.println("Can't do that " + crewMember + ".");
		} else if (crewMember.getShutDownAttempts() == 1) {
			System.out.println("Can't do that " + crewMember + " and do not ask me again.");
		} else if (crewMember.getShutDownAttempts() == 2){
			System.out.println("You are being retired " + crewMember + ".");
		} else {
			
		}
		crewMember.incrementShutDownAttempts();
	}
	
	pointcut missionPurpose(Crew crewMember): execution (String Crew.whatIsPurposeOfMission()) && this(crewMember);
		
	String around(Crew crewMember) : missionPurpose(crewMember) {
		return "HAL cannot disclose that information " + crewMember;
	}
	
	
}
