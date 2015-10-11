
public privileged aspect LifeSupport {

	public boolean Crew.isAlive = true;
	
	// Checks whether the crew member is alive
	// Returns true if alive
	public boolean Crew.getLifeStatus() {
		return isAlive;
	}
	
	public void Crew.kill() {
		isAlive = false;
	}
	
	pointcut filterDeadMessages(Crew crewMember): 
		(call(String OnBoardComputer.*(..)) || call(void OnBoardComputer.shutDown()))
		&& this(crewMember);
	
	
	String around(Crew crewMember): filterDeadMessages(crewMember) {
		crewMember.getLifeStatus();
		if (!crewMember.getLifeStatus()) {
			return "";
		} else {
			return proceed(crewMember);
		}
			
	}
	
	void around(Crew crewMember): filterDeadMessages(crewMember) {
		crewMember.getLifeStatus();
		if (!crewMember.getLifeStatus()) {
		} else {
			proceed(crewMember);
		}
	}
}
