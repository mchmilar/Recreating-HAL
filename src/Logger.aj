import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;

/**
 * 
 * This aspect creates a text file system-logs.txt to keep a log of all messages sent within
 * the system together with the relative time in milliseconds (modulo 1000). To avoid clutter, 
 * the aspect performs some filtering on which messages are to be logged. 
 * @author Mark Chmilar ID# 26827926
 * 
 *
 */
public aspect Logger {

	//Pointcut to capture calls by HAL to get a crew member's life status
	pointcut lifeSupportMessages( ):
		execution(* Crew.getLifeStatus()) || call(* Crew.kill());
	
	// getLifeStatus() calls are logged before execution
	before( ): lifeSupportMessages() {
		
		// Here we capture the location of the method call and parse
		// the name to exclude the file extension and line number
		String location = thisJoinPoint.getSourceLocation().toString();
		location = location.substring(0, location.lastIndexOf('.'));
		
		// Here we capture the method name by parsing the joinpoint signature
		String methodName = thisJoinPoint.getSignature().toString();
		methodName = methodName.substring(methodName.lastIndexOf('.') + 1, methodName.lastIndexOf('('));
		
		// This captures the name of the object executing the code
		String executer = thisJoinPoint.getTarget().toString();
		
		// Calls the private method which will write the gathered information
		// to the log file
		printToLog(location, executer, methodName);
	}
	
	// This pointcut is intended to catch crew member's calls to HAL
	pointcut messagesToOBC(Crew crewMember, OnBoardComputer computer): 
		cflow(call(* OnBoardComputer.*(..))) && this(crewMember) && target(computer);
	
	// We log the calls before execution
	before(Crew crewMember, OnBoardComputer computer): messagesToOBC(crewMember, computer) {
		
		// Here we capture the location of the method call and parse
		// the name to exclude the file extension and line number
		String location = thisJoinPoint.getSourceLocation().toString();
		location = location.substring(0, location.lastIndexOf('.'));
		
		// Here we capture the method name by parsing the joinpoint signature
		String methodName = thisJoinPoint.getSignature().toString();
		methodName = methodName.substring(methodName.lastIndexOf('.') + 1, methodName.lastIndexOf('('));
		
		// This captures the name of the object executing the code
		String executer = thisJoinPoint.getTarget().toString();
		
		// Calls the private method which will write the gathered information
		// to the log file
		printToLog(location, executer, methodName);
	
	}
	
	
	// This pointcut will capture 
	
	// Private method to simplify writing to our log file
	private void printToLog(String location, String executer, String method ) {
	
		PrintWriter output = null;
		
		try {
			output = new PrintWriter(new FileOutputStream("systems-log.txt", true));
		} catch (FileNotFoundException e) {
			System.out.println("Error opening file");
		}
		output.print(System.currentTimeMillis()%1000 + " : "); // Timestamp the information
		output.print(location + " : ");
		output.print(executer + " : ");
		output.println(method);
		
		output.close();
	}
	
	
}
