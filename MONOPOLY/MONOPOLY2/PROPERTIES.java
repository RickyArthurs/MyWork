import javax.swing.JDialog;
import javax.swing.JOptionPane;
import java.io.*;
import java.util.ArrayList;

public class PROPERTIES
{
    private String NameCost;
    private int Price;
    private int HouseCost;
    private int Group;
    private int Owner;
    private int Houses;
    private int Hotels;

    
    public PROPERTIES()
    {
        NameCost = "";
        Price = 0;
        HouseCost = 0;
        Group = 0;
        Owner = 0;
        Houses = 0;
        Hotels = 0;
    }

    
    public void readDetails(String rowItems[])
    {
     NameCost = (rowItems[0]);
     Price = Integer.parseInt((rowItems[1]));
     HouseCost = Integer.parseInt((rowItems[2]));
     Group = Integer.parseInt((rowItems[3]));
     Owner = Integer.parseInt((rowItems[4]));
     Houses = Integer.parseInt((rowItems[5]));
     Hotels = Integer.parseInt((rowItems[6]));
    }
    
    public void addHouse()
    {
       Houses++; 
    }
    
    public void addHotel()
    {
       Hotels++;
    }
    
    public void buyProperty1()
    {
        Owner = 0;
    }
    
    public void buyProperty2()
    {
        Owner = 1;
    }
    
    public String getCostName()
    {
     return NameCost;   
    }
    
    public int getPrice()
    {
     return Price;   
    }
    
    public int getHouseCost()
    {
     return HouseCost;   
    }
    
    public int getGroup()
    {
     return Group;   
    }
    
    public int getOwner()
    {
     return Owner;   
    }
    
    public int getHouses()
    {
     return Houses;   
    }
    
    public int getHotels()
    {
     return Hotels;   
    }
}
