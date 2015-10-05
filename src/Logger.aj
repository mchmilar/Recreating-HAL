/**
 * 
 * This aspect 
 * @author Mark Chmilar
 * 
 *
 */
public aspect Logger {

	pointcut systemLog(): call(* OnBoardComputer.*(..));
	
	before(): systemLog() {
	System.out.print(System.currentTimeMillis()%1000 + "  :  ");
	
	}
}
