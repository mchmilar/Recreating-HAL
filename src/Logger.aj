/**
 * 
 * This aspect 
 * @author Mark Chmilar
 * 
 *
 */
public aspect Logger {

	pointcut lifeSupportMessages():
		execution(* *.getLifeStatus());
	
	before(): lifeSupportMessages() {
		System.out.print(System.currentTimeMillis()%1000 + "  :  ");
		System.out.println("it worked! " + thisJoinPoint);
	}
	
	
	pointcut messagesToOBC(Crew crewMember, OnBoardComputer computer): 
		cflow(call(* OnBoardComputer.*(..))) && this(crewMember) && target(computer);
	
	before(Crew crewMember, OnBoardComputer computer): messagesToOBC(crewMember, computer) {
	System.out.print(System.currentTimeMillis()%1000 + "  :  ");
	System.out.print(computer + " ");
	//System.out.print(crewMember.getLifeStatus() + " ");
	
	}
	
	
}
