
public aspect LifeSupport {

	private boolean Crew.isAlive = true;
	
	public boolean Crew.getLifeStatus() {
		return this.isAlive;
	}
	
	public void Crew.setLifeStatus(boolean lifeStatus) {
		this.isAlive = lifeStatus;
	}
	
	pointcut filterDeadMessages(Crew crewMember): call(String Crew.*(..)) && this(crewMember);
	
	
	String around(Crew crewMember): filterDeadMessages(crewMember) {
		if (!crewMember.getLifeStatus()) {
			return "";
		} else {
			return proceed();
		}
			
	}
}
