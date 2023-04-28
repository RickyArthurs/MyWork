import javax.swing.JDialog;
import javax.swing.JOptionPane;
import java.io.*;
import java.util.ArrayList;

public class CARDS
{
    private String Name;
    private int Cost;
 
    
    public CARDS()
    {
        Name = "";
        Cost = 0;
        
    }

    
    public void readDetails2(String rowItems2[])
    {
     Name = (rowItems2[0]);
     Cost = Integer.parseInt((rowItems2[1]));
     
     
    }
    
    public String getCardName()
    {
     return Name;   
    }
    
    public int getCost()
    {
     return Cost;   
    }
    
    
}
