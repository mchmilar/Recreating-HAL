/**
 *  This aspect performs two tasks. First, it extends the definition of class Crew by
introducing an attribute to indicate whether or not an instance is alive or dead together
with functionality to manipulate it. Second, it intercepts all messages sent to the on-board
computer by crew members and performs filtering.
 * @author Mark Chmilar ID# 26827926
 *
 */
public privileged aspect LifeSupport {

	// Used to control the life of a crew member
	private boolean Crew.isAlive = true;
	
	// Checks whether the crew member is alive
	// Returns true if alive
	public boolean Crew.getLifeStatus() {
		return isAlive;
	}
	
	// Kill a specific crew member
	public void Crew.kill() {
		isAlive = false;
	}
	
	// This pointcut captures all calls to OnBoardComputer with return 
	// type String. It also captures the context of the calling
	// crew member
	pointcut filterStrMessages(Crew crewMember): 
		call(String OnBoardComputer.*(..))
		&& this(crewMember);
	
	// This advice filters messages of crew members based on
	// whether they are alive (isAlive = true) or dead (isAlive = false)
	String around(Crew crewMember): filterStrMessages(crewMember) {
		boolean isAlive = crewMember.getLifeStatus();
		if (!isAlive) {
			return "";
		} else {
			return proceed(crewMember);
		}
			
	}
	
	
	// This pointcut is to capture shutDown messages sent to OnBoardComputer
	// It also captures the context of the crew member who sent the message
	pointcut filterShutDownMessages(Crew crewMember):
		call(void OnBoardComputer.shutDown())
		&& this(crewMember);
	
	// This advice filters messages of crew members based on
	// whether they are alive (isAlive = true) or dead (isAlive = false)
	void around(Crew crewMember): filterShutDownMessages(crewMember) {
		boolean isAlive = crewMember.getLifeStatus();
		if (!isAlive) {
		} else {
			proceed(crewMember);
		}
	}
}
